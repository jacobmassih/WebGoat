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
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "K8S VPC"
  }
}

# Create Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public Subnet"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "k8s_gw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = {
    Name = "K8S GW"
  }
}
# Create Routing table
resource "aws_route_table" "k8s_route" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_gw.id
  }

  tags = {
    Name = "K8S Route"
  }
}
# Associate Routing table
resource "aws_route_table_association" "k8s_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.k8s_route.id
}
# Create security group
resource "aws_security_group" "allow_ssh_http" {
  name        = "Web_SG"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.k8s_vpc.id
  ingress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "K8S SG"
  }
}

# create 1 m4.large orchestrator instance
resource "aws_instance" "k8s_master" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
<<<<<<< HEAD
  instance_type               = "t2.medium"
=======
  instance_type               = "m5.2xlarge"
>>>>>>> origin/main
  key_name                    = aws_key_pair.terraformkey.key_name
  user_data                   = file("scripts/master.sh") # used to run script which deploys docker container on each instance
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  root_block_device {
    volume_size = 30
  }
  tags = {
    Name = "k8s-master"
  }
}

# create 4 m4.large worker instances
resource "aws_instance" "k8s_worker" {
  depends_on             = [aws_instance.k8s_master]
  ami                    = "ami-0fc5d935ebf8bc3bc"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  subnet_id              = aws_subnet.public_subnet.id
<<<<<<< HEAD
  instance_type          = "t2.medium"
=======
  instance_type          = "m5.2xlarge"
>>>>>>> origin/main
  key_name               = aws_key_pair.terraformkey.key_name
  root_block_device {
    volume_size = 30
  }
  user_data = file("scripts/worker.sh") # used to run script which deploys docker container on each instance
  tags = {
    Name = "k8s-worker"
  }
}

