provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t3.large"
  key_name = "mumbai_proton"
  vpc_security_group_ids = [aws_security_group.demo-sg-proton.id]
  subnet_id = aws_subnet.proton-pubsub-1.id
  for_each = toset(["Jenkins-master", "Build-Server", "Ansible-Server"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "demo-sg-proton" {
  name = "demo-sg-proton"
  description = "SSH Access"
  vpc_id = aws_vpc.proton-vpc.id
  
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

resource "aws_vpc" "proton-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "proton-vpc"
  }
}

resource "aws_subnet" "proton-pubsub-1" {
  vpc_id = aws_vpc.proton-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "proton-pubsub-1"
  }
}

resource "aws_subnet" "proton-pubsub-2" {
  vpc_id = aws_vpc.proton-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "proton-pubsub-2"
  }
}

resource "aws_internet_gateway" "proton-igw" {
  vpc_id = aws_vpc.proton-vpc.id
  tags = {
    Name = "proton-igw"
  }
}

resource "aws_route_table" "proton-pub-rt" {
  vpc_id = aws_vpc.proton-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proton-igw.id
  }
}

resource "aws_route_table_association" "proton-rta-pubsub-1" {
  subnet_id = aws_subnet.proton-pubsub-1.id
  route_table_id = aws_route_table.proton-pub-rt.id
}

resource "aws_route_table_association" "proton-rta-pubsub-2" {
  subnet_id = aws_subnet.proton-pubsub-2.id
  route_table_id = aws_route_table.proton-pub-rt.id
}
