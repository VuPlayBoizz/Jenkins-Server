#!/bin/bash

echo "🔄 Cập nhật hệ thống..."
sudo apt update -y

echo "🐳 Cài đặt Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

echo "📂 Tạo thư mục cho volume hiện tại: "
sudo mkdir -p /tools/sonarqube/data
sudo mkdir -p /tools/sonarqube/logs
sudo mkdir -p /tools/sonarqube/extensions

sudo chown -R 1000:0 /tools/sonarqube

echo "📦 Kéo và chạy container SonarQube ..."
sudo docker pull sonarqube:community

sudo docker run -d --name sonarqube \
  --restart=always \
  -p 9000:9000 \
  -v /tools/sonarqube/data:/opt/sonarqube/data \
  -v /tools/sonarqube/logs:/opt/sonarqube/logs \
  -v /tools/sonarqube/extensions:/opt/sonarqube/extensions \
  sonarqube:community

echo "⏳ Đợi vài giây để SonarQube khởi động..."
sleep 20

echo "✅ Kiểm tra trạng thái container SonarQube..."
sudo docker ps -a | grep sonarqube

echo "🚀 SonarQube Community đang chạy trên cổng 9000!"

