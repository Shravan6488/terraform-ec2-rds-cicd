#================ VPC ================
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"  #You can change the CIDR block as per required
  enable_dns_hostnames = true

  tags =  test_vpc
  
}

#================ IGW ================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
   tags =test_vpc_igw"
}

#================ Public Subnet ================
resource "aws_subnet" "pub_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"  #You can change the CIDR block as per required
  availability_zone = var.aws_region
  map_public_ip_on_launch = "true"

  tags = pub_subnet_1

}

output "out_pub_subnet_1_id" {
  value = aws_subnet.pub_subnet_1.id
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"  #You can change the CIDR block as per required
  availability_zone = var.aws_region
  map_public_ip_on_launch = "true"

  tags = pub_subnet_2
  
}

output "out_pub_subnet_2_id" {
  value = aws_subnet.pub_subnet_2.id
}


#================ RDS Subnet ================
resource "aws_db_subnet_group" "rds_subnet" {
  name = "rds_subnet"
  subnet_ids = [aws_subnet.pvt_subnet_1.id, aws_subnet.pvt_subnet_2.id]

  tags = rds_subnet
  
}

output "out_rds_subnet_name" {
  value = aws_db_subnet_group.rds_subnet.name
}

#================ Public Route Table ================
resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = pub_rtb
  
}

#================ Route Table Association ================
resource "aws_route_table_association" "pub_rtb_assoc_1" {
  subnet_id = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "pub_rtb_assoc_2" {
  subnet_id = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.pub_rtb.id
}