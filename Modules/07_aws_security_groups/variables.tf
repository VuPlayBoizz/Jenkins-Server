variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}
variable "My_computer_ip" {
  description = "My computer IP address"
  type        = string
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the security group"
  type        = string
}
variable "prefix_list_ids" {
  description = "The prefix list IDs to allow traffic from"
  type        = string
}