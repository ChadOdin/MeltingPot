#!/bin/bash

KERNEL_VERSION="5.10"  # Kernel Version
IMAGE_PATH="/path/to/backup.img"  # Path to save image
KERNEL_DIR="/usr/src/linux-${KERNEL_VERSION}"

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
    "wget"
    "build-essential"
    "libncurses-dev"
    "bison"
    "flex"
    "libssl-dev"
    "libelf-dev"
    "bc"
)

install_packages() {
    sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
    sudo apt-get install -y "${@}" || { echo "Failed to install packages. Exiting..."; exit 1; }
}

download_kernel_source() {
    cd /usr/src || { echo "Failed to change directory to /usr/src. Exiting..."; exit 1; }

    if [ ! -d "$KERNEL_DIR" ]; then
        if [ ! -f "linux-${KERNEL_VERSION}.tar.xz" ]; then
            wget "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz" || { echo "Failed to download kernel source. Exiting..."; exit 1; }
        fi
        tar -xf "linux-${KERNEL_VERSION}.tar.xz" || { echo "Failed to extract kernel source. Exiting..."; exit 1; }
    fi
}

compile_kernel() {
    cd "$KERNEL_DIR" || { echo "Failed to change directory to $KERNEL_DIR. Exiting..."; exit 1; }

    sudo cp /boot/config-$(uname -r) .config || { echo "Failed to copy kernel config. Exiting..."; exit 1; }

    for module in "${MODULES_TO_DISABLE[@]}"; do
        sudo sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
        sudo sed -i "s/CONFIG_${module}=m/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
    done

    sudo sed -i "s/# CONFIG_SCSI_DISK is not set/CONFIG_SCSI_DISK=y/" .config || { echo "Failed to enable SCSI disk support. Exiting..."; exit 1; }
    sudo sed -i "s/# CONFIG_BRIDGE is not set/CONFIG_BRIDGE=y/" .config || { echo "Failed to enable Ethernet bridging support. Exiting..."; exit 1; }

    make olddefconfig || { echo "Failed to apply kernel config. Exiting..."; exit 1; }
    make -j$(nproc) || { echo "Failed to compile kernel. Exiting..."; exit 1; }
    sudo make modules_install || { echo "Failed to install kernel modules. Exiting..."; exit 1; }
    sudo make install || { echo "Failed to install kernel. Exiting..."; exit 1; }
    sudo update-grub || { echo "Failed to update grub. Exiting..."; exit 1; }
}

install_packages "${SOFTWARE_TO_INSTALL[@]}"
download_kernel_source
compile_kernel

echo "Kernel compilation and installation completed successfully."
