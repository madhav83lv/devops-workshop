provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t3.large"
  key_name = "mumbai_proton"
  security_groups = [ "demo-sg-proton" ]
}

resource "aws_security_group" "demo-sg-proton" {
  name = "demo-sg-proton"
  description = "SSH Access"

  ingress {
    description = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SSH-port"
  }
}