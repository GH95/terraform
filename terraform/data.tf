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