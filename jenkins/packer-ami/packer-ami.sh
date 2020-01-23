#!/bin/bash

# Create jenkins ami
cd jenkins
cd master
packer validate master-ami.json
packer inspect master-ami.json
packer build master-ami.json

cd ..
cd slave
packer validate slave-ami.json
packer inspect slave-ami.json
packer build slave-ami.json

cd ../..
cd monitoring
packer validate monitoring-packer.json
packer inspect monitoring-packer.json
packer build monitoring-packer.json

