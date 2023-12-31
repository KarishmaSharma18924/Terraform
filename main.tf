provider "aws" {

  region = "eu-west-1"

}
data "aws_ami" "ubuntu" {

  most_recent = true

 

  filter {

    name   = "name"

    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }

 

  filter {

    name   = "virtualization-type"

    values = ["hvm"]

  }

 

  owners = ["099720109477"] # Canonical

}
esource "aws_instance" "instance" {

  ami           = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  count=4

  key_name = "user10_deployer-key"

  tags = {

    Name = "instance-${count.index}",

    role=count.index==0?"lb": (count.index<3?"web":"backend")

  }

}

 

output "ips"{

  value = aws_instance.instance.*.public_ip

}
