#!/bin/bash

sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common


sudo apt install nginx -y

echo "<h1>Sóc l'equip 2</h1>" > /var/www/html/index.html
systemctl start nginx
systemctl enable nginx
