#!/bin/bash

EFS_DNS_NAME="${efs_dns_name}"

sudo mkdir -p /var/lib/jenkins
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS_NAME:/ /var/lib/jenkins/
sudo chmod go+rw /var/lib/jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins