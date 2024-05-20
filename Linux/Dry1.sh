#!/bin/bash

KERNEL_VERSION="5.10"  # Kernel Version
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz"
KERNEL_DIR="/usr/src/linux-${KERNEL_VERSION}"
IMAGE_PATH="/path/to/backup.img"  # Path to save image
LOG_FILE="/var/log/kernel_build.log"

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
    "selinux-utils"
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
    "dpkg-dev"
)

DRY_RUN=true  # Set to true for dry run, false for actual execution

install_packages() {
    if [ "$DRY_RUN" = true ]; then
        for package in "${@}"; do
            echo "Simulating package installation: $package"
            sleep 1
        done
    else
        sudo apt-get update | tee -a $LOG_FILE || { echo "Failed to update package lists. Exiting..."; exit 1; }
        sudo apt-get install -y "${@}" | tee -a $LOG_FILE || { echo "Failed to install packages. Exiting..."; exit 1; }
    fi
}

download_kernel_source() {
    cd /usr/src || { echo "Failed to change directory to /usr/src. Exiting..."; exit 1; }

    if [ ! -d "$KERNEL_DIR" ]; then
        if [ ! -f "linux-${KERNEL_VERSION}.tar.xz" ]; then
            if [ "$DRY_RUN" = true ]; then
                echo "Simulating download of kernel source from $KERNEL_URL"
                sleep 1
            else
                wget "$KERNEL_URL" | tee -a $LOG_FILE || { echo "Failed to download kernel source. Exiting..."; exit 1; }
            fi
        fi
        if [ "$DRY_RUN" = true ]; then
            echo "Simulating extraction of kernel source"
            sleep 1
        else
            tar -xf "linux-${KERNEL_VERSION}.tar.xz" | tee -a $LOG_FILE || { echo "Failed to extract kernel source. Exiting..."; exit 1; }
        fi
    fi
}

configure_kernel() {
    cd "$KERNEL_DIR" || { echo "Failed to change directory to $KERNEL_DIR. Exiting..."; exit 1; }

    if [ "$DRY_RUN" = true ]; then
        echo "Simulating copying of current kernel config"
        sleep 1
    else
        sudo cp /boot/config-$(uname -r) .config | tee -a $LOG_FILE || { echo "Failed to copy kernel config. Exiting..."; exit 1; }
    fi

    for module in "${MODULES_TO_DISABLE[@]}"; do
        if [ "$DRY_RUN" = true ]; then
            echo "Simulating disabling module ${module}"
            sleep 1
        else
            sudo sed -i "s/CONFIG_${module}=y/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
            sudo sed -i "s/CONFIG_${module}=m/CONFIG_${module}=n/" .config || { echo "Failed to disable module ${module}. Exiting..."; exit 1; }
        fi
    done

    if [ "$DRY_RUN" = true ]; then
        echo "Simulating enabling of SCSI disk and Ethernet bridging support"
        sleep 1
    else
        sudo sed -i "s/# CONFIG_SCSI_DISK is not set/CONFIG_SCSI_DISK=y/" .config || { echo "Failed to enable SCSI disk support. Exiting..."; exit 1; }
        sudo sed -i "s/# CONFIG_BRIDGE is not set/CONFIG_BRIDGE=y/" .config || { echo "Failed to enable Ethernet bridging support. Exiting..."; exit 1; }
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "Simulating make olddefconfig"
        sleep 1
    else
        make olddefconfig | tee -a $LOG_FILE || { echo "Failed to apply kernel config. Exiting..."; exit 1; }
    fi
}

compile_kernel() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating kernel compilation and installation"
        sleep 1
    else
        make -j$(nproc) | tee -a $LOG_FILE || { echo "Failed to compile kernel. Exiting..."; exit 1; }
        sudo make modules_install | tee -a $LOG_FILE || { echo "Failed to install kernel modules. Exiting..."; exit 1; }
        sudo make install | tee -a $LOG_FILE || { echo "Failed to install kernel. Exiting..."; exit 1; }
        sudo update-grub | tee -a $LOG_FILE || { echo "Failed to update grub. Exiting..."; exit 1; }
    fi
}

create_golden_image() {
    if [ "$DRY_RUN" = true ]; then
        echo "Simulating creation of golden image"
        sleep 1
    else
        echo "Creating golden image..." | tee -a $LOG_FILE
        sudo dd if=/dev/sda of=${IMAGE_PATH} bs=4M status=progress | tee -a $LOG_FILE || { echo "Failed to create golden image. Exiting..."; exit 1; }
        echo "Golden image created at ${IMAGE_PATH}" | tee -a $LOG_FILE
    fi
}

# Main script execution
install_packages "${SOFTWARE_TO_INSTALL[@]}"
download_kernel_source
configure_kernel
compile_kernel

echo "Kernel compilation and installation completed successfully."
create_golden_image
