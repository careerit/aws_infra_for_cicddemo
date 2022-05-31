#!/bin/bash

# export DEBIAN_FRONTEND="noninteractive"
 
sudo apt-get update && sudo apt-get -y install ruby-full wget apache2

# Deploy Code Deploy Agent 

wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x install
sudo ./install auto
sudo service codedeploy-agent status

# Enable Apache Modules

sudo a2enmod proxy
sudo a2enmod proxy_http 

