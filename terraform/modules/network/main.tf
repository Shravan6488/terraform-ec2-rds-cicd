
#resources
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block_range
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = test_vpc
  }
}

#================ IGW ================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
     tags =test_vpc_igw"
  }
}
#================ Public Subnet ================
resource "aws_subnet" "subnet_public_1a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet1_cidr_block_range
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone_a
  tags = {
    Environment = var.environment_tag
    Type  = "Public"
  }
}



resource "aws_subnet" "subnet_public_1b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet2_cidr_block_range
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone_b
  tags = {
    Environment = var.environment_tag
    Type  = "Public"
  }
}


#================ RDS Subnet ================
resource "aws_db_subnet_group" "rds_subnet" {
  name = "rds_subnet"
  subnet_ids = [aws_subnet.pvt_subnet_1.id, aws_subnet.pvt_subnet_2.id]

  tags = rds_subnet
  
}



#================ Public Route Table ================
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
     Environment = var.environment_tag
  }
}

#================ Route Table Association ================
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_db_subnet_group" "myapp-db" {
    name = "main"
    description = "Our main group of subnets"
    subnet_ids = ["${aws_subnet.subnet_public.id}","${aws_subnet.subnet_public_1b.id}"]
    tags = {
        Name = "MyApp DB subnet group"
    }
}