#!/bin/bash

set -e  # Dừng script nếu có lỗi xảy ra

echo "🚀 Bắt đầu cài đặt Monitoring Server..."

echo "🔄 Cập nhật hệ thống..."
sudo apt update -y && sudo apt upgrade -y

echo "🐳 Cài đặt Docker và Docker Compose..."
sudo apt install -y docker.io docker-compose

echo "🔑 Cấu hình quyền truy cập Docker cho user ubuntu..."
sudo usermod -aG docker ubuntu

echo "📂 Cấu hình thư mục cho Prometheus..."
sudo mkdir -p /tools/monitoring/prometheus
sudo chown -R 65534:65534 /tools/monitoring/prometheus

sudo tee /tools/monitoring/prometheus/prometheus.yml > /dev/null <<EOL
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'blackbox_exporter'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
          - http://your-website.com
          - http://localhost:9115
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115
EOL

echo "📂 Cấu hình thư mục cho Grafana..."
sudo mkdir -p /tools/monitoring/grafana
sudo chown -R 472:472 /tools/monitoring/grafana

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