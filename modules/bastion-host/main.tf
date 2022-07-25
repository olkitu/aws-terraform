/**
* # Bastion Host
*/
module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.1.1"

  name = "${local.name}-bastion"

  ami                    = aws_ami_copy.amazon-linux-2-encrypted.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.ec2_bastion_sg.security_group_id]
  subnet_id              = var.vpc_subnet_ids[0] # Select first private subnet

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = local.tags
}

module "ec2_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.9.0"

  name        = "${local.name}-bastion-sg"
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr_block]

  tags = local.tags
}

resource "aws_ami_copy" "amazon-linux-2-encrypted" {
  name              = "${data.aws_ami.amazon-linux-2.name}-encrypted"
  description       = "${data.aws_ami.amazon-linux-2.description} (encrypted)"
  source_ami_id     = data.aws_ami.amazon-linux-2.id
  source_ami_region = local.region
  encrypted         = true

  tags = merge(local.tags, {
    Name      = "${data.aws_ami.amazon-linux-2.name}-encrypted"
    ImageType = "encrypted-amzn2-linux"
  })
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${local.name}-instance-profile"
  role = aws_iam_role.instance_profile_role.name
}

resource "aws_iam_role" "instance_profile_role" {
  name = "${local.name}-instance-profile-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "instance_profile_attach" {
  role       = aws_iam_role.instance_profile_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}