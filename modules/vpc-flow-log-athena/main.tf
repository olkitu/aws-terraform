data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_athena_workgroup" "vpc_flow_logs" {
  name = var.workgroup_name

  configuration {
    result_configuration {
      output_location = "s3://${var.s3_bucket_name}/athena-results/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = var.force_destroy

  tags = local.tags
}

resource "aws_glue_catalog_database" "vpc_flow_logs" {
  name        = local.name
  description = "VPC Flow Logs"
}

resource "aws_glue_catalog_table" "vpc_flow_logs" {
  name          = var.glue_catalog_table_name
  database_name = aws_glue_catalog_database.vpc_flow_logs.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "storage.location.template" = "s3://${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${data.aws_region.current.name}/$${date}"
  }

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${data.aws_region.current.name}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = " "
      }
    }

    dynamic "columns" {
      for_each = local.ordered_table_columns
      content {
        name = columns.value.key
        type = columns.value.value
      }
    }
  }

  dynamic "partition_keys" {
    for_each = local.ordered_partition_keys
    content {
      name = partition_keys.value.key
      type = partition_keys.value.value
    }
  }
}

resource "aws_athena_named_query" "VpcFlowLogsTotalBytesTransferred" {
  name        = "VpcFlowLogsTotalBytesTransferred"
  description = "Top 50 pairs of source and destination IP addresses with the most bytes transferred."
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
SELECT SUM(bytes) as totalbytes, srcaddr, dstaddr from ${aws_glue_catalog_table.vpc_flow_logs.name}
GROUP BY srcaddr, dstaddr
ORDER BY totalbytes
LIMIT 50
EOT
}

resource "aws_athena_named_query" "VpcFlowLogsSshRdpTraffic" {
  name        = "VpcFlowLogsSshRdpTraffic"
  description = "Monitor SSH and RDP traffic"
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
SELECT *
FROM ${aws_glue_catalog_table.vpc_flow_logs.name}
WHERE srcport in (22,3389) OR dstport IN (22, 3389)
ORDER BY "start" ASC
limit 50
EOT
}

resource "aws_athena_named_query" "VpcFlowLogsTopRejects" {
  name        = "VpcFlowLogsTopRejects"
  description = "Recorded traffic which was not permitted by the security groups or network ACLs."
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
SELECT srcaddr, dstaddr,  count(*) count, "action"
FROM ${aws_glue_catalog_table.vpc_flow_logs.name}
WHERE "action" = 'REJECT'
GROUP BY srcaddr, dstaddr, "action"
ORDER BY count desc
LIMIT 25
EOT
}

resource "aws_athena_named_query" "VpcFlowLogsAdminPortTraffic" {
  name        = "VpcFlowLogsAdminPortTraffic"
  description = "Monitor the traffic on administrative web app ports"
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
SELECT ip, sum(bytes) as total_bytes
FROM (
  SELECT dstaddr as ip,sum(bytes) as bytes
  FROM ${aws_glue_catalog_table.vpc_flow_logs.name}
  GROUP BY 1
  UNION ALL
  SELECT srcaddr as ip,sum(bytes) as bytes
  FROM ${aws_glue_catalog_table.vpc_flow_logs.name}
  GROUP BY 1
)
GROUP BY ip
ORDER BY total_bytes
DESC LIMIT 10
EOT
}

module "lambda_initial_partitioner" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.0"

  function_name = "${local.name}-initial_partitioner"
  description   = "Create initial partition for Athena table"
  handler       = "initial_partitioner.handler"
  runtime       = "nodejs20.x"

  timeout = 60

  source_path = "${path.module}/./src"

  attach_policy_json = true
  policy_json        = local.lambda_policy_json

  tags = local.tags
}

resource "aws_lambda_invocation" "initial_partitioner" {
  function_name = module.lambda_initial_partitioner.lambda_function_name

  input = jsonencode({
    dbName     = local.name
    hive       = false
    account_id = data.aws_caller_identity.current.account_id
    service    = "vpcflowlogs"
    region     = data.aws_region.current.name
    athenaIntegrations = [{
      partitionTableName     = aws_glue_catalog_table.vpc_flow_logs.name,
      partitionLoadFrequency = "daily"
      partitionStartDate     = local.partition_start_date,
      partitionEndDate       = local.timedate
    }]
  })

}

module "lambda_daily_partitioner" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.0"

  function_name = "${local.name}-daily_partitioner"
  description   = "Create daily partition for Athena table"
  handler       = "daily_partitioner.handler"
  runtime       = "nodejs20.x"

  timeout = 30

  source_path = "${path.module}/./src"

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    eventbridge = {
      service    = "events"
      source_arn = module.eventbridge_daily_partitioner.eventbridge_rule_arns["crons"]
    }
  }

  attach_policy_json = true
  policy_json        = local.lambda_policy_json

  tags = local.tags
}

module "eventbridge_daily_partitioner" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.14.2"

  create_bus = false

  rules = {
    crons = {
      description         = "Invoke Lambda daily partitioner to create daily partition"
      schedule_expression = "cron(0 0 * * ? *)"
    }
  }

  targets = {
    crons = [
      {
        name = "lambda_daily_partitioner"
        arn  = module.lambda_daily_partitioner.lambda_function_arn
        input = jsonencode({
          db         = aws_glue_catalog_database.vpc_flow_logs.name
          hive       = false
          account_id = data.aws_caller_identity.current.account_id
          service    = "vpcflowlogs"
          region     = data.aws_region.current.name
          athena = [{
            partitionTableName = aws_glue_catalog_table.vpc_flow_logs.name,
            frequency          = "daily"
          }]
        })
      }
    ]
  }

  tags = local.tags
}