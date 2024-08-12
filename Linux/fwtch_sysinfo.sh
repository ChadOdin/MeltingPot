#!/bin/bash

get_os_info() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$PRETTY_NAME"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "$DISTRIB_DESCRIPTION"
    elif [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ -f /etc/debian_version ]; then
        echo "Debian $(cat /etc/debian_version)"
    else
        echo "Unknown OS"
    fi
}

os_info=$(get_os_info)

kernel=$(uname -r)

uptime_info=$(uptime -p)

shell=$(echo $SHELL)

user=$(whoami)

hostname=$(hostname)

cpu=$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)

gpu=$(lspci | grep -i 'vga\|3d\|2d' | head -n 1 | cut -d ':' -f3 | xargs)
if [ -z "$gpu" ]; then
    gpu="GPU information not available"
fi

memory=$(free -h --si | awk '/Mem:/ {print $2}')

disk_usage=$(df -h --total | grep 'total' | awk '{print $3 " / " $2 " used (" $5 " used)"}')

disks=$(lsblk -b -o NAME,SIZE,TYPE | grep 'disk' | while read name size type; do
    size_gb=$(echo "scale=2; $size/1024/1024/1024" | bc)
    if (( $(echo "$size_gb >= 1024" | bc -l) )); then
        size_tb=$(echo "scale=2; $size_gb/1024" | bc)
        size_display="$size_tb TB"
    else
        size_display="$size_gb GB"
    fi
    mountpoints=$(lsblk -no MOUNTPOINT "/dev/$name" | grep -v '^$')
    if [ -n "$mountpoints" ]; then
        total_used=0
        total_size=0
        total_used_perc=0
        for mountpoint in $mountpoints; do
            usage_info=$(df -B1 "$mountpoint" | awk 'NR==2 {print $3, $2}')
            used=$(echo "$usage_info" | awk '{print $1}')
            size=$(echo "$usage_info" | awk '{print $2}')
            used_perc=$(echo "scale=2; $used/$size*100" | bc)
            total_used=$((total_used + used))
            total_size=$((total_size + size))
        done
        total_used_gb=$(echo "scale=2; $total_used/1024/1024/1024" | bc)
        total_size_gb=$(echo "scale=2; $total_size/1024/1024/1024" | bc)
        used_percentage=$(echo "scale=2; $total_used/$total_size*100" | bc)
        echo "/dev/$name: $size_display - $total_used_gb GB / $total_size_gb GB (${used_percentage}% used)"
    else
        echo "/dev/$name: $size_display - Not mounted"
    fi
done)

echo -e "User:            $user\n\
OS:              $os_info\n\
Kernel:          $kernel\n\
Uptime:          $uptime_info\n\
Shell:           $shell\n\
Hostname:        $hostname\n\
CPU:             $cpu\n\
GPU:             $gpu\n\
Memory:          $memory\n\
Disk Usage:      $disk_usage\n\
Disks and Sizes:\n$disks"