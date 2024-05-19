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

# List software to install
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
    "linux-source"
    "bc"
)

install_packages() {
    sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
    sudo apt-get install -y "${@}" || { echo "Failed to install packages. Exiting..."; exit 1; }
}

compile_kernel() {
    cd /usr/src || { echo "Failed to change directory. Exiting..."; exit 1; }

    # Download kernel source if not already present
    if [ ! -d "linux-source-${KERNEL_VERSION}" ]; then
        wget "https://www.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz" || { echo "Failed to download kernel source. Exiting..."; exit 1; }
        tar -xf "linux-${KERNEL_VERSION}.tar.xz" || { echo "Failed to extract kernel source. Exiting..."; exit 1; }
    fi

    cd "linux-${KERNEL_VERSION}" || { echo "Failed to change directory. Exiting..."; exit 1; }

    # Copy existing kernel config
    sudo cp /boot/config-$(uname -r) .config || { echo "Failed to copy kernel config. Exiting..."; exit 1; }

    # Apply module configuration changes
    for module in "${MODULES_TO_DISABLE[@]}"; do
        sudo sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
        sudo sed -i "s/CONFIG_${module}=m/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }  # Also disable modules set as loadable
    done

    # Compile and install the kernel
    make olddefconfig || { echo "Failed to apply kernel config. Exiting..."; exit 1; }
    make -j$(nproc) || { echo "Failed to compile kernel. Exiting..."; exit 1; }
    sudo make modules_install || { echo "Failed to install kernel modules. Exiting..."; exit 1; }
    sudo make install || { echo "Failed to install kernel. Exiting..."; exit 1; }
    sudo update-grub || { echo "Failed to update grub. Exiting..."; exit 1; }
}

# Install required software packages
install_packages "${SOFTWARE_TO_INSTALL[@]}"

# Compile and install the kernel
compile_kernel

echo "Kernel compilation and installation completed successfully."

echo "Test"
