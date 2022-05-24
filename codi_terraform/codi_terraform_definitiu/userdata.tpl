#!/bin/bash

sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common


sudo apt install nginx -y
systemctl start nginx
systemctl enable nginx
