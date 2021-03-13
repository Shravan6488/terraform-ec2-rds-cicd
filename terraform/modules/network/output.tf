output "out_vpc_id" {
  value = aws_vpc.vpc.id
}
output "out_vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}
output "out_rds_subnet_name" {
  value = aws_db_subnet_group.rds_subnet.name
}

output "out_subnet_public_1b_id" {
  value = aws_subnet.subnet_public_1b.id
}

output "out_subnet_public_1a_id" {
  value = aws_subnet.subnet_public_1a.id
}
