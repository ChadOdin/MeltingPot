#!/bin/bash

KERNEL_VERSION="5.10"  # Specify the desired kernel version
IMAGE_PATH="/path/to/backup.img"  # Path to save the golden image
MODULES_TO_DISABLE=("FLOPPY" "IPV6")  # List of modules to disable

sudo apt-get update
sudo apt-get install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev linux-source

cd /usr/src
tar -xf linux-source-${KERNEL_VERSION}.tar.xz
cd linux-source-${KERNEL_VERSION}

cp /boot/config-$(uname -r) .config

for module in "${MODULES_TO_DISABLE[@]}"; do
    sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config
done

make menuconfig

make -j$(nproc)
sudo make modules_install
sudo make install

sudo update-grub

echo "Rebooting into the new kernel..."
sudo reboot

sleep 60

# Create golden image after reboot
echo "Creating golden image..."
sudo dd if=/dev/sda of=${IMAGE_PATH} bs=4M status=progress

echo "Golden image created at ${IMAGE_PATH}"