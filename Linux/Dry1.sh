#!/bin/bash

KERNEL_VERSION="5.10"  # Kernel Version
IMAGE_PATH="/path/to/backup.img"  # Path to save image
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
)

DRY_RUN=false  # Set to true for a simulated run

install_packages() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating package installation..."
    else
        sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
        sudo apt-get install -y "${@}" || { echo "Failed to install packages. Exiting..."; exit 1; }
    fi
}

configure_elk() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating ELK configuration..."
    else
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
    fi
}

disable_modules() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating disabling of kernel modules..."
    else
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
    fi
}

configure_kernel() {
    cd /usr/src || { echo "Failed to change directory. Exiting..."; exit 1; }

    # Check if kernel source exists
    if [ ! -d "linux-source-${KERNEL_VERSION}" ]; then
        echo "Kernel source not found. Downloading..."
        if [ "$DRY_RUN" = true ]; then
            echo "Simulating download of kernel source..."
        else
            wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz || { echo "Failed to download kernel source. Exiting..."; exit 1; }
            tar -xf linux-${KERNEL_VERSION}.tar.xz || { echo "Failed to extract kernel source. Exiting..."; exit 1; }
            mv linux-${KERNEL_VERSION} linux-source-${KERNEL_VERSION} || { echo "Failed to move kernel source. Exiting..."; exit 1; }
        fi
    fi

    cd linux-source-${KERNEL_VERSION} || { echo "Failed to change directory. Exiting..."; exit 1; }

    # Make sure .config files exist
    if [ ! -f ".config" ]; then
        echo "Kernel config file not found. Exiting..."
        exit 1
    fi

    # Run make olddefconfig to update .config
    make olddefconfig || { echo "Failed to run make olddefconfig. Exiting..."; exit 1; }

    # Check if .config has been updated
    if ! grep -q '^# CONFIG_' .config; then
        echo "Kernel config not updated. Exiting..."
        exit 1
    fi

    disable_modules
}

create_golden_image() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating creation of golden image..."
    else
        echo "Creating golden image..."
        sudo dd if=/dev/sda of=${IMAGE_PATH} bs=4M status=progress || { echo "Failed to create golden image. Exiting..."; exit 1; }
        echo "Golden image created at ${IMAGE_PATH}"
    fi
}

# Main script execution
echo "Starting kernel configuration..."

install_packages "${SOFTWARE_TO_INSTALL[@]}"
configure_elk
configure_kernel
create_golden_image

echo "Rebooting into the new kernel..."
sudo reboot
