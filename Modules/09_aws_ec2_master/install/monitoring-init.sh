#!/bin/bash

echo "🚀 Bắt đầu cài đặt Monitoring Server..."
echo "🔄 Cập nhật hệ thống..."
sudo apt update -y

echo "🐳 Cài đặt Docker và Docker Compose..."
sudo apt install docker.io docker-compose -y

echo "🔑 Cấu hình quyền truy cập Docker cho user ubuntu..."
sudo usermod -aG docker ubuntu
newgrp docker

echo "📁 Tạo thư mục cho hệ thống giám sát..."
sudo mkdir -p /tools/monitoring
sudo chown -R ubuntu:ubuntu /tools/monitoring
sudo chmod -R 755 /tools/monitoring

echo "📂 Cấu hình thư mục cho Prometheus..."
sudo mkdir -p /tools/monitoring/prometheus
sudo chown -R 65534:65534 /tools/monitoring/prometheus

echo "📂 Cấu hình thư mục cho Grafana..."
sudo mkdir -p /tools/monitoring/grafana
sudo chown -R 472:472 /tools/monitoring/grafana

echo "✅ Đặt quyền sở hữu cho toàn bộ thư mục Monitoring..."
sudo chown -R 1000:1000 /tools/monitoring


# Tạo tệp Docker Compose để khởi chạy monitoring stack
DOCKER_COMPOSE_CONFIG="/tools/monitoring/docker-compose.yml"
echo "🛠️ Tạo tệp cấu hình Docker Compose tại $DOCKER_COMPOSE_CONFIG..."
sudo tee $DOCKER_COMPOSE_CONFIG > /dev/null <<EOL
version: '3.7'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - /tools/monitoring/prometheus:/etc/prometheus
    ports:
      - "9090:9090"
    networks:
      - monitoring
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - /tools/monitoring/grafana:/var/lib/grafana
    networks:
      - monitoring
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    networks:
      - monitoring
    restart: unless-stopped

  blackbox_exporter:
    image: prom/blackbox-exporter:latest
    container_name: blackbox_exporter
    ports:
      - "9115:9115"
    networks:
      - monitoring
    restart: unless-stopped

networks:
  monitoring:
    driver: bridge
EOL

# Khởi động Monitoring Stack
echo "🚀 Khởi động Monitoring Stack với Docker Compose..."
cd /tools/monitoring
docker-compose up -d
