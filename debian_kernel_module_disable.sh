#!/bin/bash

KERNEL_VERSION="5.10"  # Kernel Version
IMAGE_PATH="/path/to/backup.img"  # Path to save image
REMOTE_USER="your_remote_user"
REMOTE_HOST="your_remote_host"
REMOTE_PATH="/path/to/remote/backup.img"
STATIC_IP="192.168.1.100"
STATIC_NETMASK="255.255.255.0"
STATIC_GATEWAY="192.168.1.1"
DNS_SERVERS="8.8.8.8,8.8.4.4"

MODULES_TO_DISABLE=(
    "FLOPPY"
    "PARPORT"
    "WLAN"
    "BT"
    "SOUND"
    "SND"
    "DRM"
    "FB"
    "VGA"
    "KVM"
    "XEN"
    "VIRTUALBOX"
    "JOYSTICK"
    "INPUT_JOYSTICK"
    "VIDEO_DEV"
    "MEDIA"
    "PRINTER"
    "USB_PRINTER"
    "DEBUG_KERNEL"
    "FTRACE"
    "BT_HIDP"
    "NFS"
    "CIFS"
    "FAT"
    "NTFS"
    "NET_PROTOCOLS"
    "DECNET"
    "APPLETALK"
)

# List software to install
SOFTWARE_TO_INSTALL=(
    "net-tools"
    "selinux"
    "apparmor"
    "openssh-server"
    "fail2ban"
    "unattended-upgrades"
    "ufw"
    "elasticsearch"
    "logstash"
    "kibana"
)

install_packages() {
    sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
    sudo apt-get install -y "${@}" || { echo "Failed to install packages. Exiting..."; exit 1; }
}

configure_elk() {
    # Elasticsearch Config
    sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster/' /etc/elasticsearch/elasticsearch.yml || { echo "Failed to configure Elasticsearch. Exiting..."; exit 1; }

    # Logstash config
    sudo cat << EOF > /etc/logstash/conf.d/01-my-input.conf || { echo "Failed to configure Logstash input. Exiting..."; exit 1; }
input {
  beats {
    port => 5044
  }
}
EOF

    # Logstash filter
    sudo cat << EOF > /etc/logstash/conf.d/02-my-filter.conf || { echo "Failed to configure Logstash filter. Exiting..."; exit 1; }
filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}
EOF

    # Logstash output
    sudo cat << EOF > /etc/logstash/conf.d/03-my-output.conf || { echo "Failed to configure Logstash output. Exiting..."; exit 1; }
output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
EOF

    # Kibana Config
    sudo sed -i 's/#server.host: "localhost"/server.host: "localhost"/' /etc/kibana/kibana.yml || { echo "Failed to configure Kibana. Exiting..."; exit 1; }

    sudo systemctl enable elasticsearch || { echo "Failed to enable Elasticsearch service. Exiting..."; exit 1; }
    sudo systemctl start elasticsearch || { echo "Failed to start Elasticsearch service. Exiting..."; exit 1; }
    sudo systemctl enable logstash || { echo "Failed to enable Logstash service. Exiting..."; exit 1; }
    sudo systemctl start logstash || { echo "Failed to start Logstash service. Exiting..."; exit 1; }
    sudo systemctl enable kibana || { echo "Failed to enable Kibana service. Exiting..."; exit 1; }
    sudo systemctl start kibana || { echo "Failed to start Kibana service. Exiting..."; exit 1; }
}

# Disable unnecessary kernel modules
sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
sudo apt-get install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev linux-source || { echo "Failed to install build dependencies. Exiting..."; exit 1; }

cd /usr/src || { echo "Failed to change directory. Exiting..."; exit 1; }
tar -xf linux-source-${KERNEL_VERSION}.tar.xz || { echo "Failed to extract kernel source. Exiting..."; exit 1; }
cd linux-source-${KERNEL_VERSION} || { echo "Failed to change directory. Exiting..."; exit 1; }

cp /boot/config-$(uname -r) .config || { echo "Failed to copy kernel config. Exiting..."; exit 1; }

for module in "${MODULES_TO_DISABLE[@]}"; do
    sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
    sed -i "s/CONFIG_${module}=m/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }  # Also disable modules set as loadable
done

# SCSI enable
sed -i "s/# CONFIG_SCSI_DISK is not set/CONFIG_SCSI_DISK=y/" .config || { echo "Failed to enable SCSI disk support. Exiting..."; exit 1; }

# Ethernet Bridging enable
sed -i "s/# CONFIG_BRIDGE is not set/CONFIG_BRIDGE=y/" .config || { echo "Failed to enable Ethernet bridging support. Exiting..."; exit 1; }

make menuconfig || { echo "Failed to run make menuconfig. Exiting..."; exit 1; }

make -j$(nproc) || { echo "Failed to compile kernel. Exiting..."; exit 1; }
sudo make modules_install || { echo "Failed to install kernel modules. Exiting..."; exit 1; }
sudo make install || { echo "Failed to install kernel. Exiting..."; exit 1; }

sudo update-grub || { echo "Failed to update grub. Exiting..."; exit 1; }

install_packages "${SOFTWARE_TO_INSTALL[@]}"

# Configure ELK
configure_elk

echo "Rebooting into the new kernel..."
sudo reboot

sleep 60

echo "Creating golden image..."
sudo dd if=/dev/sda of=${IMAGE_PATH} bs=4M status=progress || { echo "Failed to create golden image. Exiting..."; exit 1; }

echo "Golden image created at ${IMAGE_PATH}"