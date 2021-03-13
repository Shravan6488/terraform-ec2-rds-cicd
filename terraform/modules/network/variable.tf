# Variables

variable "availability_zone" {
  default = "eu-central-1a"
}
variable "availability_zone_b" {
  default = "eu-central-1b"
}
variable "cidr_block_range" {
  description = "The CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "subnet1_cidr_block_range" {
  description = "The CIDR block for public subnet of VPC"
  default = "10.1.0.0/24"
}
variable "subnet2_cidr_block_range" {
  description = "The CIDR block for public subnet of VPC"
  default = "10.1.1.0/24"
}

