provider "aws" {
  region = "ca-central-1"
}

# Create an Ec2 Instance
resource "aws_instance" "Devops-Project-2-EC2-Instance" {
  ami                     = "ami-0ea18256de20ecdfc" //Ubuntu AMI ID
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.Devops-Project-2-Subnet-1A.id
  for_each = toset(["Jenkins-master", "Build-slave", "Ansible"])
  tags = {
     Name = "${each.key}"
   }
  key_name                = "Devops-Project-2-Key"
  vpc_security_group_ids = [aws_security_group.Devops-Project-2-SG.id]
 
}




# Create VPC
resource "aws_vpc" "Devops-Project-2-VPC" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "Devops-Project-2-VPC"
  }
}

# Create Subnet-1
resource "aws_subnet" "Devops-Project-2-Subnet-1A" {
  vpc_id     = aws_vpc.Devops-Project-2-VPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ca-central-1a"

  tags = {
    Name = "Devops-Project-2-Subnet-1A"
  }
}

# Create Subnet-2

resource "aws_subnet" "Devops-Project-2-Subnet-1B" {
  vpc_id     = aws_vpc.Devops-Project-2-VPC.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ca-central-1b"

  tags = {
    Name = "Devops-Project-2-Subnet-1B"
  }
}

# Create an Seurity group for Devops-Project-2

resource "aws_security_group" "Devops-Project-2-SG" {
  name        = "Devops-Project-2-SG"
  description = "Devops-Project-2-SG"
  vpc_id      = aws_vpc.Devops-Project-2-VPC.id

  ingress {
    description      = "SSH-Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "All-traffic-Allow"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Jenkins-Port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Devops-Project-2-SG"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "Devops-Project-2-IGW" {
  vpc_id = aws_vpc.Devops-Project-2-VPC.id

  tags = {
    Name = "Devops-Project-2-IGW"
  }
}

# RouteTable Creation

resource "aws_route_table" "Devops-Project-2-RT" {
  vpc_id = aws_vpc.Devops-Project-2-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Devops-Project-2-IGW.id
  }
  tags = {
    Name = "Devops-Project-2-RT"
  }
}

# Routetable Asscoication

resource "aws_route_table_association" "Devops-Project-2-RT-Subnet-1A" {
    subnet_id = aws_subnet.Devops-Project-2-Subnet-1A.id
    route_table_id = aws_route_table.Devops-Project-2-RT.id
}

resource "aws_route_table_association" "Devops-Project-2-RT-Subnet-1B" {
    subnet_id = aws_subnet.Devops-Project-2-Subnet-1B.id
    route_table_id = aws_route_table.Devops-Project-2-RT.id
}

