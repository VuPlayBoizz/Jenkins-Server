resource "aws_ec2_managed_prefix_list" "jenkins_prefix_list" {
  name        = "jenkins_vpc_prefix_list"
  address_family = "IPv4"
  max_entries = 3

  entry {
    cidr        = var.eks_vpc_cidr
    description = "CIDR cho 10.0.0.0/16"
  }

  entry {
    cidr        = var.jenkins_vpc_cidr
    description = "CIDR cho 11.0.0.0/16"
  }

  entry {
    cidr        = var.My_computer_ip
    description = "CIDR cho 1.52.248.169/32"
  }
}