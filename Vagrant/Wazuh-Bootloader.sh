#!/bin/bash

wget -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -

echo 'deb https://packages.wazuh.com/4.x/apt/stable main' | sudo tee /etc/apt/sources.list.d/wazuh.list

sudo apt-get update
sudo apt-get install wazuh-manager -y

sudo systemctl start wazuh-manager
sudo systemctl enable wazuh-manager

