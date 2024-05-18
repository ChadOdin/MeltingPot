#!/bin/bash

DRY_RUN=true # Set to false to execute the actual commands
KERNEL_VERSION="5.10"
IMAGE_PATH="/path/to/backup.img"
# REMOTE_USER="your_remote_user"
# REMOTE_HOST="your_remote_host"
# REMOTE_PATH="/remote/path/backup.img"

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
    "pv"
)

run_command() {
    if [ "$DRY_RUN" = true ]; then
        echo "DRY RUN: $*"
    else
        eval "$@"
    fi
}

install_packages() {
    run_command sudo apt-get update
    run_command sudo apt-get install -y "$@"
}

configure_elk() {
    run_command sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster/' /etc/elasticsearch/elasticsearch.yml
    run_command sudo tee /etc/logstash/conf.d/01-my-input.conf > /dev/null << EOF
input {
  beats {
    port => 5044
  }
}
EOF

    run_command sudo tee /etc/logstash/conf.d/02-my-filter.conf > /dev/null << EOF
filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}
EOF

    run_command sudo tee /etc/logstash/conf.d/03-my-output.conf > /dev/null << EOF
output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
EOF

    run_command sudo sed -i 's/#server.host: "localhost"/server.host: "localhost"/' /etc/kibana/kibana.yml

    run_command sudo systemctl enable elasticsearch
    run_command sudo systemctl start elasticsearch

    run_command sudo systemctl enable logstash
    run_command sudo systemctl start logstash

    run_command sudo systemctl enable kibana
    run_command sudo systemctl start kibana
}

# send_image_via_sftp() {
#     run_command sftp ${REMOTE_USER}@${REMOTE_HOST} <<EOF
# put ${IMAGE_PATH} ${REMOTE_PATH}
# exit
# EOF
# }

install_packages build-essential libncurses-dev bison flex libssl-dev libelf-dev linux-source "${SOFTWARE_TO_INSTALL[@]}"

run_command cd /usr/src
run_command tar -xf linux-source-${KERNEL_VERSION}.tar.xz
run_command cd linux-source-${KERNEL_VERSION}
run_command cp /boot/config-$(uname -r) .config

for module in "${MODULES_TO_DISABLE[@]}"; do
    run_command sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config
    run_command sed -i "s/CONFIG_${module}=m/CONFIG_${module}=n/" .config
done

run_command sed -i "s/# CONFIG_SCSI_DISK is not set/CONFIG_SCSI_DISK=y/" .config
run_command sed -i "s/# CONFIG_BRIDGE is not set/CONFIG_BRIDGE=y/" .config
run_command make menuconfig
run_command make -j$(nproc)
run_command sudo make modules_install
run_command sudo make install
run_command sudo update-grub

configure_elk

run_command echo "Rebooting into the new kernel..."
run_command sudo reboot

sleep 60

run_command sudo dd if=/dev/sda | pv | sudo dd of=${IMAGE_PATH} bs=4M

# send_image_via_sftp
