terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# connect to aws
provider "aws" {
  region = "us-east-1"
}

# Provides EC2 key pair
resource "aws_key_pair" "terraformkey" {
  key_name   = "terraform_key"
  public_key = tls_private_key.k8s_ssh.public_key_openssh
}

# create vpc
data "aws_vpc" "default" {
  default = true
}

# create security group
resource "aws_security_group" "tp2_security_group" {
  name        = "tp2_security_group"
  description = "Allow traffic to the m4 orchestrator"
  vpc_id      = data.aws_vpc.default.id
  
  # Define your security group rules here
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create 1 m4.large orchestrator instance
resource "aws_instance" "k8s_master" {
  ami = "ami-0fc5d935ebf8bc3bc"
  vpc_security_group_ids = [aws_security_group.tp2_security_group.id]
  instance_type = "m4.large"
  key_name = aws_key_pair.terraformkey.key_name
  user_data = file("scripts/master.sh") # used to run script which deploys docker container on each instance
  tags = {
    Name = "k8s-master"
  }
}

# create 4 m4.large worker instances
resource "aws_instance" "k8s_worker" {
  depends_on = [ aws_instance.k8s_master ]
  ami           = "ami-0fc5d935ebf8bc3bc"
  vpc_security_group_ids = [aws_security_group.tp2_security_group.id]
  instance_type = "m4.large"
  key_name = aws_key_pair.terraformkey.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = file("scripts/worker.sh") # used to run script which deploys docker container on each instance
    tags = {
      Name = "k8s-worker"
  } 
}

resource "local_file" "ansible_host" {
    depends_on = [ aws_instance.k8s_worker ]
    content     = "[Master_Node]\n${aws_instance.k8s_master.public_ip}\n\n[Worker_Node]\n${aws_instance.k8s_worker.public_ip}"
    filename    = "inventory"
  }

output "master_ip" {
  value = aws_instance.k8s_master.private_ip
}