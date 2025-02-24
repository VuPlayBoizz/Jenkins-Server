data "aws_ami" "ubuntu_ami" {
    most_recent = true
    owners      = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}

resource "aws_instance" "ec2_instance" {
    ami                         = data.aws_ami.ubuntu_ami.id # Ubuntu Server 24.04 LTS (x86)
    instance_type               = var.instance_type
    key_name                    = var.key_name
    subnet_id                   = var.subnet_id
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [var.security_groups_id]
    root_block_device {
        volume_size = 20
        volume_type = "gp3"
    }

    user_data = base64encode(<<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install -y openjdk-17-jdk
        sudo apt install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker ubuntu
        sudo apt update -y

        # Tạo thư mục cho Jenkins Agent
        mkdir -p /home/ubuntu/jenkins_agent
        chown -R ubuntu:ubuntu /home/ubuntu/jenkins_agent
        wget -O /home/ubuntu/jenkins_agent/agent.jar http://${var.jenkins_master_ip}:8080/jnlpJars/agent.jar

        # Cài đặt wget và GPG nếu chưa có
        sudo apt-get install -y wget gnupg

        # Cài đặt Trivy
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install -y trivy
    EOF
    )
  

    tags = {
        Name = var.name
    }
}
