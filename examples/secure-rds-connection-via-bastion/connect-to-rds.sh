#!/bin/bash
# Connect to RDS via Bastion Host

TERRAFORM_OUTPUT=$(terraform output -json)

aws ssm start-session \
    --region $(echo $TERRAFORM_OUTPUT | jq -r .aws_region.value) \
    --target $(echo $TERRAFORM_OUTPUT | jq -r .bastion_id.value) \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters host="$(echo $TERRAFORM_OUTPUT | jq -r .rds_address.value)",portNumber="$(echo $TERRAFORM_OUTPUT | jq -r .rds_port.value)",localPortNumber="33069" &

sleep 5

# Create databse account to allow access using IAM Authentication
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html

echo "Create Database account allow IAM Authentication if not exist"
mysql -h 127.0.0.1 -P 33069 -u admin -p$(echo $TERRAFORM_OUTPUT | jq -r .rds_password.value) -e "CREATE USER IF NOT EXISTS iam_admin IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS'; GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'iam_admin'@'%';"

## Temporary token to use as password when authenticate to RDS
echo "Generate temporary token to access to database"
TOKEN=$(aws rds generate-db-auth-token \
    --hostname $(echo $TERRAFORM_OUTPUT | jq -r .rds_address.value) \
    --port $(echo $TERRAFORM_OUTPUT | jq -r .rds_port.value) \
    --region $(echo $TERRAFORM_OUTPUT | jq -r .aws_region.value) \
    --username iam_admin
    )

echo $TOKEN

echo "Connect to the database. To exit use exit command or \q"
mysql -h 127.0.0.1 -P 33069 -u iam_admin --enable-cleartext-plugin -p$TOKEN
    
DESCRIBE_ACTIVE_SESSIONS=$(aws ssm describe-sessions --state "Active" --filters "key=Target,value=$(echo $TERRAFORM_OUTPUT | jq -r .bastion_id.value)" "key=Owner,value=$(aws sts get-caller-identity --query 'Arn' --output text)")

echo "Terminate session"
aws ssm terminate-session --session-id $(echo $DESCRIBE_ACTIVE_SESSIONS | jq -r .Sessions[0].SessionId)