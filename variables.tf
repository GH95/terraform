variable "ami_id" {
  default = ""
}

variable "key_pair_key_name" {
  default = ""
}

variable "aws_instance_tag_name" {
  default = ""
}

variable "ingress_cidr_block_range" {
  default = "0.0.0.0/0"
}

variable "egress_cidr_block_range" {
  default = "0.0.0.0/0"
}

variable "web_server_port" {
  default = 80
}
