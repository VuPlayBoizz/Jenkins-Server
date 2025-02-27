#!/bin/bash

echo "Cập nhật hệ thống..."
sudo apt update -y

echo "Kiểm tra và cài đặt OpenJDK 17..."
sudo apt install openjdk-17-jdk -y

echo "Java đã được cài đặt."

echo "Thêm khóa GPG của Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "Thêm repository của Jenkins..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Cập nhật hệ thống sau khi thêm repo..."
sudo apt update -y

echo "Cài đặt Jenkins..."
sudo apt install jenkins -y

echo "Khởi động Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Mở cổng 8080 trên tường lửa..."
sudo ufw allow 8080

echo "Kiểm tra trạng thái Jenkins..."
sudo systemctl status jenkins --no-pager

echo "Cài đặt hoàn tất!"
