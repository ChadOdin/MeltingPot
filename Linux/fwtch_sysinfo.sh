#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    os_info="$NAME $VERSION"
elif type lsb_release >/dev/null 2>&1; then
    os_info=$(lsb_release -ds)
elif [ -f /etc/redhat-release ]; then
    os_info=$(cat /etc/redhat-release)
elif [ -f /etc/debian_version ]; then
    os_info="Debian $(cat /etc/debian_version)"
else
    os_info="$(uname -s) $(uname -r)"
fi

kernel=$(uname -r)
uptime_info=$(uptime -p)
shell=$(basename $SHELL)
hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')
cpu=$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)
memory=$(free -h --si | awk '/Mem:/ {print $2}')
disk_usage=$(df -h --total | grep 'total' | awk '{print $3 " / " $2 " (" $5 " used)"}')

cpu_cores=$(nproc)
load_avg=$(uptime | awk -F 'load average:' '{ print $2 }' | xargs)
load_1_min=$(echo $load_avg | cut -d, -f1)
load_5_min=$(echo $load_avg | cut -d, -f2)
load_15_min=$(echo $load_avg | cut -d, -f3)
load_1_min_pct=$(awk -v load="$load_1_min" -v cores="$cpu_cores" 'BEGIN { printf "%.2f", (load/cores)*100 }')
load_5_min_pct=$(awk -v load="$load_5_min" -v cores="$cpu_cores" 'BEGIN { printf "%.2f", (load/cores)*100 }')
load_15_min_pct=$(awk -v load="$load_15_min" -v cores="$cpu_cores" 'BEGIN { printf "%.2f", (load/cores)*100 }')

top_process=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 2 | tail -n 1)
top_process_pid=$(echo $top_process | awk '{print $1}')
top_process_name=$(echo $top_process | awk '{print $2}')
top_process_cpu=$(echo $top_process | awk '{print $3}')

process_count=$(ps aux | wc -l)
thread_count=$(ps -eo nlwp | tail -n +2 | awk '{ num_threads += $1 } END { print num_threads }')

disks=$(lsblk -b -o NAME,SIZE | grep '^sd' | awk '
{
    size_gb = $2/1024/1024/1024;
    if (size_gb >= 1024) {
        size_display = sprintf("%.2f TB", size_gb/1024);
    } else {
        size_display = sprintf("%.2f GB", size_gb);
    }
    disk_name = "/dev/" $1;
    usage=$(df -h | grep $disk_name | awk "{print \$3 \"/\" \$2 \" (\" \$5 \" used)\"}");
    if (usage == "") {
        usage = "Not mounted";
    }
    printf "Disk: %s | Size: %s | Usage: %s\n", disk_name, size_display, usage;
}')

temp_dirs=$(for dir in /tmp /var/tmp /run; do
    if [ -d "$dir" ]; then
        size=$(du -sh $dir 2>/dev/null | awk '{print $1}')
        echo "$dir: $size"
    else
        echo "$dir: Not present"
    fi
done)

echo -e "\nSystem Information:\n===================\nOS:              $os_info\nKernel:          $kernel\nUptime:          $uptime_info\nShell:           $shell\nHostname:        $hostname\nIP Address:      $ip_address\nCPU:             $cpu\nMemory:          $memory\nDisk Usage:      $disk_usage"

echo -e "\nCPU Load (Percentage):\n=====================\n 1 min:  $load_1_min_pct%\n 5 min:  $load_5_min_pct%\n15 min:  $load_15_min_pct%"

echo -e "\nTop CPU-Consuming Process:\n==========================\nPID:   $top_process_pid\nName:  $top_process_name\nCPU%:  $top_process_cpu%"

echo -e "\nRunning Processes and Threads:\n=============================\nProcesses: $process_count\nThreads:   $thread_count"

echo -e "\nDisk Details:\n==============\n$disks"

echo -e "\nTemporary File Storage:\n=======================\n$temp_dirs"