resource "aws_cloud9_environment_ec2" "cloud9_environment" {
  name          = var.name
  instance_type = var.instance_type

  automatic_stop_time_minutes = var.automatic_stop_time_minutes

  tags = local.tags
}

data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.cloud9_environment.id
    ]
  }
}

data "aws_region" "current" {}