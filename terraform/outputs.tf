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
