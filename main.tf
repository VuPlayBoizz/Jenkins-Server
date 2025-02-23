module "vpc" {
    source                  = "./Modules/01_aws_vpc"
    cidr_block              = var.cidr_block
    enable_dns_hostnames    = var.enable_dns_hostnames
    enable_dns_support      = var.enable_dns_support
    tags                    = var.tags
}

module "vpc-subnet" {
    source                          = "./Modules/02_aws_subnet"
    vpc_id                          = module.vpc.vpc_id
    public_subnet_cidr_block        = var.public_subnet_cidr_block
    private_subnet_cidr_block       = var.private_subnet_cidr_block
    availability_zone               = var.availability_zone
    tags                            = var.tags
}

module "vpc-internet-gateway" {
    source                  = "./Modules/03_aws_igw"
    vpc_id                  = module.vpc.vpc_id
    tags                    = var.tags
}

module "vpc-nat-gateway" {
    source                  = "./Modules/04_aws_nat"
    vpc_id                  = module.vpc.vpc_id
    public_subnet_id        = module.vpc-subnet.public_subnet_id
    tags                    = var.tags
}

module "vpc-route-table" {
    source              = "./Modules/05_aws_route_tables"
    vpc_id              = module.vpc.vpc_id
    internet_gateway_id = module.vpc-internet-gateway.internet_gateway_id
    nat_gateway_id      = module.vpc-nat-gateway.nat_gateway_id
    public_subnet_id    = module.vpc-subnet.public_subnet_id
    private_subnet_ids  = [module.vpc-subnet.private_subnet_id]
    tags                = var.tags
}

module "prefix-list" {
    source              = "./Modules/06_aws_prefixlist"
    jenkins_vpc_cidr    = var.cidr_block
    eks_vpc_cidr        = var.eks_vpc_cidr
    My_computer_ip      = var.My_computer_ip
}

module "security-group" {
    source              = "./Modules/07_aws_security_groups"
    vpc_id              = module.vpc.vpc_id
    My_computer_ip      = var.My_computer_ip
    vpc_cidr_block      = var.cidr_block
    prefix_list_ids     = module.prefix-list.jenkin_prefix_list_id
}

module "key-pair" {
    source      = "./Modules/08_aws_key_pair"
    key_name    = var.key_name 
}

module "Jenkin-server" {
    source                      = "./Modules/09_aws_ec2_master"
    instance_type               = var.instance_type[0]
    private_key_path            = var.private_key_path    
    key_name                    = module.key-pair.key_name
    subnet_id                   = module.vpc-subnet.public_subnet_id
    security_groups_id          = module.security-group.public_security_group_id
    script_name                 = "jenkins-init.sh"
    workspace_path              = "/tools/jenkins"
    name                        = "Jenkins-Server"
    associate_public_ip_address = true  

    depends_on                  = [module.vpc-nat-gateway]
}

module "Sonar-server" {
    source                      = "./Modules/09_aws_ec2_master"
    instance_type               = var.instance_type[0]
    private_key_path            = var.private_key_path    
    key_name                    = module.key-pair.key_name
    subnet_id                   = module.vpc-subnet.public_subnet_id
    security_groups_id          = module.security-group.public_security_group_id
    script_name                 = "sonarqube-init.sh"
    workspace_path              = "/tools/sonarqube"
    name                        = "Sonar-Server"
    associate_public_ip_address = true  

    depends_on                  = [module.Jenkin-server]
}

module "Nexus-server" {
    source                      = "./Modules/09_aws_ec2_master"
    instance_type               = var.instance_type[0]
    private_key_path            = var.private_key_path    
    key_name                    = module.key-pair.key_name
    subnet_id                   = module.vpc-subnet.public_subnet_id
    security_groups_id          = module.security-group.public_security_group_id
    script_name                 = "nexus-init.sh"
    workspace_path              = "/tools/nexus"
    name                        = "Nexus-Server"
    associate_public_ip_address = true  

    depends_on                  = [module.Sonar-server]
}

module "jenkin-agent" {
    source                      = "./Modules/10_aws_ec2_slave"
    instance_type               = var.instance_type[0]
    private_key_path            = var.private_key_path    
    key_name                    = module.key-pair.key_name
    subnet_id                   = module.vpc-subnet.private_subnet_id
    security_groups_id          = module.security-group.private_security_group_id
    jenkins_master_ip           = module.Jenkin-server.master_public_ip
    name                        = "Jenkins-Agent"
    associate_public_ip_address = false

    depends_on                  = [module.Nexus-server]    
}


