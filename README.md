# Terraform Infrastructure for Jenkins Deployment

This Terraform configuration automates the provisioning of AWS infrastructure for a Jenkins deployment. The setup includes a Virtual Private Cloud (VPC), subnets, security groups, and an EC2 instance for Jenkins.

## **Infrastructure Overview**
![Picture_1](https://github.com/user-attachments/assets/f5201cae-8d70-4e7d-8aa6-1b89ce44fe96)


This Terraform script provisions the following AWS resources:

- **VPC** with configurable CIDR block, DNS support, and hostname resolution.
- **Subnets** (Public and Private) in a specified availability zone.
- **Internet Gateway (IGW)** for public subnet connectivity.
- **NAT Gateway** for private subnet connectivity.
- **Route Tables** to manage traffic routing.
- **Security Groups** to control inbound and outbound access.
- **Key Pair** for SSH access to EC2 instances.
- **EC2 Instance** configured for Jenkins deployment.

## **Configuration Variables**

Below are the configurable variables used in the Terraform script:

### **General Tags**

```hcl
tags = {
    Name        = "<vpc-name>"
    Environment = "<environment>"
    Owner       = "<owner>"
}
```

- `Name`: Name assigned to the VPC.
- `Environment`: Deployment environment (e.g., Development, Staging, Production).
- `Owner`: Owner of the infrastructure.

### **AWS Provider**

```hcl
region = "<aws-region>"
```

- `region`: AWS region where the infrastructure will be deployed.

### **VPC Configuration**

```hcl
cidr_block           = "<vpc-cidr-block>"
enable_dns_support   = <true/false>
enable_dns_hostnames = <true/false>
```

- `cidr_block`: CIDR range for the VPC.
- `enable_dns_support`: Enable/disable DNS resolution support.
- `enable_dns_hostnames`: Enable/disable DNS hostnames for instances.

### **Subnet Configuration**

```hcl
public_subnet_cidr_block  = "<public-subnet-cidr>"
private_subnet_cidr_block = "<private-subnet-cidr>"
availability_zone         = "<availability-zone>"
```

- `public_subnet_cidr_block`: CIDR block for the public subnet.
- `private_subnet_cidr_block`: CIDR block for the private subnet.
- `availability_zone`: AWS availability zone to deploy the subnets.

### **Security Group Configuration**

```hcl
My_computer_ip = "<your-ip-address>/32"
```

- `My_computer_ip`: IP address allowed to connect via SSH.

### **Key Pair**

```hcl
key_name = "<key-pair-name>"
```

- `key_name`: Name of the SSH key pair used for EC2 instance access.

### **EC2 Instance Configuration**

```hcl
instance_type      = ["<instance-type>"]
private_key_path   = "<path-to-private-key>"
```

- `instance_type`: AWS instance type for the Jenkins server.
- `private_key_path`: Path to the private key file for SSH access.

## **Usage**

1. **Initialize Terraform**
   ```bash
   terraform init
   ```
2. **Validate Configuration**
   ```bash
   terraform validate
   ```
3. **Plan Deployment**
   ```bash
   terraform plan
   ```
4. **Apply Configuration**
   ```bash
   terraform apply -auto-approve
   ```
5. **Destroy Infrastructure (if needed)**
   ```bash
   terraform destroy -auto-approve
   ```
## Variables

| Variable Name               | Description                                      | Example Value |
|-----------------------------|--------------------------------------------------|---------------|
| `tags`                      | General tags for resource identification        | `{ Name = "jenkins-vpc", Environment = "Production" }` |
| `region`                    | AWS region for resource deployment              | `ap-southeast-1` |
| `cidr_block`                | CIDR block for VPC                              | `11.0.0.0/16` |
| `enable_dns_support`        | Enable DNS resolution support                   | `true` |
| `enable_dns_hostnames`      | Enable DNS hostnames for instances              | `true` |
| `public_subnet_cidr_block`  | CIDR block for public subnet                    | `11.0.1.0/24` |
| `private_subnet_cidr_block` | CIDR block for private subnet                   | `11.0.3.0/24` |
| `availability_zone`         | Availability zone for subnets                   | `ap-southeast-1a` |
| `My_computer_ip`           | IP address allowed for SSH access               | `192.168.154.131/32` |
| `key_name`                 | SSH key pair name                               | `jenkins-key` |
| `instance_type`            | AWS instance type                               | `t2.medium` |
| `private_key_path`         | Path to the SSH private key                     | `./Modules/08_aws_key_pair/jenkins-key.pem` |


## **Prerequisites**

- Terraform installed (`>= v5.0`).
- AWS CLI configured with necessary permissions.
- SSH key pair created for EC2 instance access.

## **Author**

- **VuPlayBoizz**

