provider "aws" {
  region     = "us-west-2"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["George"]
  }
}

data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = ["MyFirewall"] 
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.selected.id}"] 
  }
}

resource "aws_security_group" "default" {
  name = "Bastion-SG"
}

resource "aws_security_group_rule" "allow_all" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  source_security_group_id = "${data.aws_security_group.sg.id}"

  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_instance" "myfirstec2" {
  ami = ""
  instance_type = "t2.micro"
  	tags {
	      Name = "My EC2 Instance"
	}
}

output "public_ip" {
 value = "${aws_instance.myfirstec2.public_ip}"
}

output "id" {
 value = "${aws_instance.myfirstec2.id}"
}

output "public_dns" {
 value = "${aws_instance.myfirstec2.public_dns}"
}

output "security_groups" {
 value = "${aws_instance.myfirstec2.security_groups}"
}

output "subnet_id" {
 value = "${aws_instance.myfirstec2.subnet_id}"
}

output "VPC_security_group" {
 value = "${aws_instance.myfirstec2.vpc_security_group_ids}"
}
