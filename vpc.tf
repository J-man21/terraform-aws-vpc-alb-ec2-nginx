resource "aws_vpc" "vpc_terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "igw_vpc_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id
}

/*
  Public Subnet
*/
resource "aws_subnet" "public-az-a" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  map_public_ip_on_launch = true

  cidr_block        = var.public_subnet_cidr_az_a
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "public-az-a" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc_terraform.id
  }

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "public-az-a" {
  subnet_id      = aws_subnet.public-az-a.id
  route_table_id = aws_route_table.public-az-a.id
}

/*
  Public Subnet az b
*/
resource "aws_subnet" "public-az-b" {
  vpc_id = aws_vpc.vpc_terraform.id

  map_public_ip_on_launch = true

  cidr_block        = var.public_subnet_cidr_az_b
  availability_zone = "us-west-2b"

  tags = {
    Name = "Public Subnet az b"
  }
}

resource "aws_route_table" "public-az-b" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc_terraform.id
  }

  tags = {
    Name = "Public Subnet az b"
  }
}

resource "aws_route_table_association" "public-az-b" {
  subnet_id      = aws_subnet.public-az-b.id
  route_table_id = aws_route_table.public-az-b.id
}