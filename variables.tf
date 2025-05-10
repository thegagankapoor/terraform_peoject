variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "ami" {
  description = "The AMI to use for the instance"
}

variable "instance_type" {
  description = "The type of instance to start"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
}