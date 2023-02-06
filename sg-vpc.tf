
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = var.aws_security_group_name
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Inbound traffic for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Inbound traffic for HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Inbound traffic for HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.ec2_lb_sg_tags-name
  }
}

resource "aws_subnet" "public_subnet1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "Public Subnet1"
    }
}

resource "aws_subnet" "private_subnet1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1c"
  
    tags = {
      Name = "Private Subnet1"
    }
}

resource "aws_subnet" "public_subnet2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
  
    tags = {
      Name = "Public Subnet2"
    }
}

resource "aws_subnet" "private_subnet2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1d"
  
    tags = {
      Name = "Private Subnet2"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.main.id
  
    tags = {
      Name = "Internet Gateway"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet_gateway.id
    }
  
    route {
      ipv6_cidr_block = "::/0"
      gateway_id      = aws_internet_gateway.internet_gateway.id
    }
  
    tags = {
      Name = "Public Route Table"
    }
}

resource "aws_route_table_association" "public_1_rt_a" {
    subnet_id      = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_rt_a" {
    subnet_id      = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_rt.id
}