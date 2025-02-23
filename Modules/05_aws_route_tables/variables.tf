variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "internet_gateway_id" {
    description = "The Internet Gateway ID"
    type        = string
}

variable "nat_gateway_id" {
    description = "The NAT Gateway ID"
    type        = string
}

variable "public_subnet_id" {
    description = "The Public Subnet IDs"
    type        = string
}

variable "private_subnet_ids" {
  description = "Danh sách ID của Private Subnets"
  type        = list(string)
}

variable "tags" {
    description = "The tags to apply to the resources"
    type        = map(string)  
}