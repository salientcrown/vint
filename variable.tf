
variable "region" {
  default = "us-east-1"
}

variable "aws_cidr" {
  default = "192.168.0.0/16"
}

variable "env" {
  default = "Dev"
}

variable "aws_public_cidr" {
  default = ["192.168.0.0/24", "192.168.2.0/24", "192.168.4.0/24"]
}

variable "aws_private_cidr" {
  default = ["192.168.1.0/24", "192.168.3.0/24", "192.168.5.0/24"]
}

variable "instance_type" {
  default = "t2.medium"
}


variable "key_pair" {
  default = "con"
}

variable "ami_id" {
  default = "ami-09d3b3274b6c5d4aa"
}