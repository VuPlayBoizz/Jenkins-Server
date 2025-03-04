#!/bin/bash

set -e  # Dừng script nếu có lỗi

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Tạo user hệ thống cho Prometheus
echo "🔹 Tạo user Prometheus..."
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Cài đặt Prometheus
PROMETHEUS_VERSION="2.53.3"
echo "🔹 Cài đặt Prometheus v$PROMETHEUS_VERSION..."
wget -q https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar -xzf prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
sudo mkdir -p /data /etc/prometheus
cd prometheus-$PROMETHEUS_VERSION.linux-amd64/
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles console_libraries /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus /data
cd && rm -rf prometheus-$PROMETHEUS_VERSION.linux-amd64*

# Tạo service Prometheus
echo "🔹 Tạo Prometheus service..."
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/data \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090 \\
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# Kích hoạt Prometheus
echo "🔹 Khởi động Prometheus..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Cài đặt Grafana
echo "🔹 Cài đặt Grafana..."
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.2_amd64.deb
sudo dpkg -i grafana-enterprise_11.5.2_amd64.deb
sudo /bin/systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Cài đặt Blackbox Exporter
BLACKBOX_VERSION="0.26.0"
echo "🔹 Cài đặt Blackbox Exporter v$BLACKBOX_VERSION..."
wget -q https://github.com/prometheus/blackbox_exporter/releases/download/v$BLACKBOX_VERSION/blackbox_exporter-$BLACKBOX_VERSION.linux-amd64.tar.gz
tar -xzf blackbox_exporter-$BLACKBOX_VERSION.linux-amd64.tar.gz
sudo mv blackbox_exporter-$BLACKBOX_VERSION.linux-amd64/blackbox_exporter /usr/local/bin/
sudo mkdir -p /etc/blackbox_exporter
sudo mv blackbox_exporter-$BLACKBOX_VERSION.linux-amd64/blackbox.yml /etc/blackbox_exporter/blackbox.yml
sudo useradd --system --no-create-home --shell /bin/false blackbox
sudo chown -R blackbox:blackbox /etc/blackbox_exporter
cd && rm -rf blackbox_exporter-$BLACKBOX_VERSION.linux-amd64*

# Tạo service Blackbox Exporter
echo "🔹 Tạo Blackbox Exporter service..."
cat <<EOF | sudo tee /etc/systemd/system/blackbox_exporter.service
[Unit]
Description=Blackbox Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=blackbox
Group=blackbox
Type=simple
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox_exporter/blackbox.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Kích hoạt Blackbox Exporter
echo "🔹 Khởi động Blackbox Exporter..."
sudo systemctl daemon-reload
sudo systemctl enable blackbox_exporter
sudo systemctl start blackbox_exporter

# Hoàn tất
echo "✅ Cài đặt hoàn tất!"
echo "🎯 Prometheus: http://localhost:9090"
echo "📊 Grafana: http://localhost:3000"
echo "🔍 Blackbox Exporter: http://localhost:9115"