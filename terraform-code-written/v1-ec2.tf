provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t3.large"
  key_name = "mumbai_proton"
}