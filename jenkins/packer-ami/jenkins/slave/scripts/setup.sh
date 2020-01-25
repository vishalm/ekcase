#!/bin/bash
echo "Install Docker"
sudo yum update -y
sudo yum -y install docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
sudo yum install epel-release -y
sudo yum install jq -y
jq --version

echo "Install Java"
sudo yum -y install java-1.8.0-openjdk-devel

echo "Install Git"
sudo yum install -y git

echo "change time zone"
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime

