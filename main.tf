provider "aws" {
  region = var.aws_region
}

#create first ec2 webserver nginx-01 in AZ us-west-2a
resource "aws_instance" "nginx-01" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    =  var.key_name 
  associate_public_ip_address = true
  tags = {
    Name = "nginx-01"
  }
  user_data = file("install_nginx.sh") #Script to update ubuntu and install nginx webserver

  vpc_security_group_ids = [
    aws_security_group.sg_webserver.id,
  ]

  availability_zone = "us-west-2a"
  subnet_id         = aws_subnet.public-az-a.id

}

#create second ec2 webserver nginx-02 in AZ us-west-2b
resource "aws_instance" "nginx-02" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    =  var.key_name 
  associate_public_ip_address = true
  tags = {
    Name = "nginx-02"
  }
  user_data = file("install_nginx.sh") #Script to update ubuntu and install nginx webserver

  vpc_security_group_ids = [
    aws_security_group.sg_webserver.id,
  ]

  subnet_id = aws_subnet.public-az-b.id

  availability_zone = "us-west-2b"

}

#create security group to webservers
resource "aws_security_group" "sg_webserver" {
  name        = "sg_webserver"
  description = "Allow incoming HTTP, HTTPS and ICMP connections from VPC. Allow incoming SSH from all"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [aws_vpc.vpc_terraform.cidr_block]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_terraform.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.vpc_terraform.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "sg_webserver"
  }
}

