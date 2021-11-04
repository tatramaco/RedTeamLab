resource "aws_vpc" "lab-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "lab-subnet" {
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" #it makes this a public subnet
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "lab-subnet"
  }
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    Name = "lab-igw"
  }
}

resource "aws_route_table" "lab-rtble" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internetDevSecOps
    gateway_id = aws_internet_gateway.lab-igw.id
  }

  tags = {
    Name = "lab-rtble"
  }
}

resource "aws_route_table_association" "lab-rta" {
  subnet_id      = aws_subnet.lab-subnet.id
  route_table_id = aws_route_table.lab-rtble.id
}