#!/bin/bash

# GPG Key
wget -q0 https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# editing APT repo
echo "deb https://artifacts.elastic.co/packages/7.x /apt stable main" | sudo tee /etc/apt/sources.list.d/elastic/7.x.list

sudo apt-get update

sudo apt-get install -y elasticsearch

sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster/g' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 172.30.100.11/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#https.port: 9200/http.port: 9200/g' /etc/elasticsearch/elasticsearch.yml

sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch