#!/bin/bash

# GPG Key
wget -q0 https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# editing APT repo
echo "deb https://artifacts.elastic.co/packages/7.x /apt stable main" | sudo tee /etc/apt/sources.list.d/elastic/7.x.list

sudo apt-get update

sudo apt-get install kibana -y

sudo systemctl start kibana

sudo systemctl enable kibana