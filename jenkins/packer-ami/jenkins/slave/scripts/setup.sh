#!/bin/bash
echo "Install Docker"
sudo yum update -y
sudo yum -y install docker


echo "Install Java"
sudo yum -y install java-1.8.0-openjdk-devel

echo "Install Git"
sudo yum install -y git

echo "change time zone"
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime

