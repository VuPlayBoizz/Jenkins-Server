#!/bin/bash

echo "🔄 Cập nhật hệ thống..."
sudo apt update -y && sudo apt upgrade -y

echo "🐳 Cài đặt Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu


echo "📂 Tạo thư mục cho volume hiện tại: "
sudo mkdir -p /tools/nexus/data

sudo chown -R 200:200 /tools/nexus

echo "📦 Kéo và chạy container Nexus với volume mount..."
sudo docker pull sonatype/nexus3

sudo docker run -d --name nexus \
  --restart=always \
  -p 8081:8081 \
  -v /tools/nexus/data:/nexus-data \
  sonatype/nexus3

echo "⏳ Đợi vài giây để Nexus khởi động..."
sleep 20

echo "✅ Kiểm tra trạng thái container Nexus..."
sudo docker ps -a | grep nexus

echo "🚀 Nexus Repository Manager đang chạy trên cổng 8081!"

