locals {
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
curl http://169.254.169.254/latest/meta-data/public-ipv4 > /var/www/html/index.html
  EOF

}