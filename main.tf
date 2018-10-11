provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "myfirstec2" {
  ami = ""
  instance_type = "t2.micro"
  	tags {
	      Name = "terraform-myfirstec2"
	}
}
