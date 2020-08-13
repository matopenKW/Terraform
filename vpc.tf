resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr[var.env]
    enable_dns_hostnames = true
    tags = {
        Name = "${var.env}-${var.project}-vpc"
    }
}

resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr["${var.env}_public_a"]
    availability_zone = var.az["az_a"]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.env}-${var.project}-public-a-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.env}-${var.project}-igw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.env}-${var.project}-public-rtb"
    }
}

resource "aws_route_table_association" "public_a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}