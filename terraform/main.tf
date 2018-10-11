provider "aws" {
  region     = "us-west-2"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.aws_vpc_tag_name}"]
  }
}

data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = ["${var.aws_sg_group_name}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.selected.id}"] 
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.s3_bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.dynamodb_table_name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "${var.dynamodb_hash_key}"

  attribute {
    name = "${var.dynamodb_hash_key}"
    type = "S"
  }
}

resource "aws_security_group" "default" {
  name = "${var.aws_sg_default_name}"
}

resource "aws_security_group_rule" "allow_all" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  source_security_group_id = "${data.aws_security_group.sg.id}"

  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group" "instance" {
  ingress {
    from_port   = "${var.web_server_port}"
    to_port     = "${var.web_server_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr_block_range}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr_block_range}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.egress_cidr_block_range}"]
  }
}

resource "aws_instance" "myfirstec2" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "${var.key_pair_key_name}"
  user_data = <<-EOF
	      #!/bin/bash
	      yum install httpd -y
	      echo "This is running on George EC2 Instance" > /var/www/html/index.html
	      yum update -y
	      service httpd start
	      EOF
  tags {
    Name = "${var.aws_instance_tag_name}"
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
