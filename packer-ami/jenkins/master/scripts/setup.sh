#!/bin/bash

echo "Get Updates"
sudo yum -y update

echo "Install Java"
sudo yum -y install java-1.8.0-openjdk-devel

echo "Install Git"
sudo yum install -y git

echo "Install Jenkins"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

echo "change time zone"
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime