resource "aws_security_group" "public-sg" {
    name        = "jenkins-public-sg"
    description = "Security group for public resources"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.My_computer_ip]
    }

    ingress {
        from_port   = 25
        to_port     = 25
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }

    ingress {
        from_port   = 465
        to_port     = 465
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }

    ingress {
        from_port   = 3000
        to_port     = 10000
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }
    ingress {
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }

    ingress {
        from_port   = 50000
        to_port     = 50000
        protocol    = "tcp"
        prefix_list_ids = [var.prefix_list_ids]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "jenkins-public-sg"
    }
}

resource "aws_security_group" "private-sg" {
    name        = "jenkins-private-sg"
    description = "Security group for private resources"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # Allow all inbound traffic
        prefix_list_ids = [var.prefix_list_ids]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "jenkins-private-sg"
    }
}