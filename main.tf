resource "aws_vpc" "aron_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "aron_public_subnet" {
  vpc_id                  = aws_vpc.aron_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "aron_internet_gateway" {
  vpc_id = aws_vpc.aron_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "aron_public_rt" {
  vpc_id = aws_vpc.aron_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.aron_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aron_internet_gateway.id
}

resource "aws_route_table_association" "aron_public_assoc" {
    subnet_id = aws_subnet.aron_public_subnet.id
    route_table_id = aws_route_table.aron_public_rt.id
}

resource "aws_security_group" "aron_sg" {
    name = "dev_sg"
    description = "dev security group"
    vpc_id = aws_vpc.aron_vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["replace"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_key_pair" "aron_auth" {

}