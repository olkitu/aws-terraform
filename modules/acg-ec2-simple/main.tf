/**
* # Simple EC2 Autoscalegroup
* Deploy simple EC2 Autoscalegroup to AWS.
*/
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.5.1"

  name = local.name

  min_size = var.min_size
  max_size = var.max_size

  health_check_type = "EC2"

  vpc_zone_identifier = var.vpc_zone_identifier

  image_id      = aws_ami_copy.amazon-linux-2-encrypted.id
  instance_type = var.instance_type

  create_iam_instance_profile = true
  iam_role_name               = "${local.name}-instance_role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role to EC2 Autoscale"

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.volume_size
        volume_type           = "gp2"
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.ssh_security_group.security_group_id]
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        "Name" = "${local.name}-autoscale-instance"
      }
    },
    {
      resource_type = "volume"
      tags = {
        "Name" = "${local.name}-autoscale-instance"
      }
    }
  ]
}

module "ssh_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 4.0"

  name   = "${local.name}-ssh-in"
  vpc_id = var.vpc_id

  ingress_cidr_blocks = [
    var.vpc_cidr_block
  ]

  tags = local.tags
}

resource "aws_ami_copy" "amazon-linux-2-encrypted" {
  name              = "${data.aws_ami.amazon-linux-2.name}-encrypted"
  description       = "${data.aws_ami.amazon-linux-2.description} (encrypted)"
  source_ami_id     = data.aws_ami.amazon-linux-2.id
  source_ami_region = var.region
  encrypted         = true

  tags = {
    ImageType = "encrypted-amzn2-linux"
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}