provider "aws" {
  region = "ca-central-1"
}

resource "aws_security_group" "All-Traffic-Allow-SG" {
  name        = "All-Traffic-Allow-SG"
  description = "This Security group is used to use the Devops Project 2"
  
  // Define ingress rules to allow inbound traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow SSH from anywhere
  }

  // Ingress rule to allow all incoming traffic from all sources
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow tcp from anywhere
  
  }
  // Define additional ingress rules as needed
}

resource "aws_instance" "test-server" {
  ami                     = "ami-038fa9e464182bc03"
  instance_type           = "t2.micro"
  key_name                = "Devops-Project-2-Key"
  tags = {
    Name = "Demo-Server"
  }
  vpc_security_group_ids = [aws_security_group.All-Traffic-Allow-SG.id]
  
  
  
  
}

