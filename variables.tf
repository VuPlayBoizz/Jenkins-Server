//Define tags name
variable "tags" {
    description = "A map of tags to assign to the resources"
    type        = map(string)
}

//Define the variables Provider
variable "region" {
    description = "The AWS region to deploy to"
    type = string
}

// Define the variables in aws_vpc module
variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
}
variable "enable_dns_hostnames" {
    description = "A boolean flag to enable/disable DNS hostnames in the VPC"
    type        = bool
}
variable "enable_dns_support" {
    description = "A boolean flag to enable/disable DNS support in the VPC"
    type        = bool
}

// Define the variables in aws_subnet module
variable "public_subnet_cidr_block" {
    description = "The CIDR block for the public subnet"
    type        = string
}
variable "private_subnet_cidr_block" {
    description = "The CIDR block for the private subnet"
    type        = string
}
variable "availability_zone" {
    description = "The availability zone for the subnet"
    type        = string
}

// Define the variables in aws_igw module
// Define the variables in aws_nat module
// Define the variables in aws_route_tables module

//Define the variables in aws_route_tables module
//Define the variables in aws_prefix_list module
variable "eks_vpc_cidr" {
    description = "The CIDR block for the EKS VPC"
    type        = string
}
variable "jenkins_vpc_cidr" {
    description = "The CIDR block for the Jenkins VPC"
    type        = string
}
variable "ec2_vpc_cidr" {
    description = "The CIDR block for the ec2 VPC"
    type        = string
}
//Define the variables in aws_security_groups module
variable "My_computer_ip" {
    description = "My computer IP address"
    type        = string
}

//Define the aws_key_pair variable
variable "key_name" {
    description = "Name of the key pair"
    type        = string
}

//Define the variables in aws_instance module
variable "instance_type" {
    description = "The instance type to use"
    type        = list(string)
}
variable "private_key_path" {
    description = "The path to the private key"
    type        = string
}





