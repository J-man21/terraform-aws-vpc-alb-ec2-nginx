variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.nano"
}

variable "key_name" {
  description = "EC2 Key Name"
  default     = "aws-key-us-west-2" ### Please replace it to you key pair name ####
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_az_a" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr_az_b" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.1.0/24"
}