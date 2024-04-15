# Bash Cheat Sheet

## Basic Commands

### Navigation
- `cd`: Change directory
  Example: `cd Documents`

- `ls`: List directory contents
  Example: `ls -l`

- `pwd`: Print working directory
  Example: `pwd`

### File Operations
- `mkdir`: Make directory
  Example: `mkdir new_dir`

- `touch`: Create empty file
  Example: `touch new_file.txt`

- `cp`: Copy files or directories
  Example: `cp file1.txt file2.txt`

- `mv`: Move or rename files or directories
  Example: `mv file1.txt new_dir`

- `rm`: Remove files or directories
  Example: `rm old_file.txt`

## Intermediate Commands

### Text Manipulation
- `grep`: Search for patterns in text
  Example: `grep "pattern" file.txt`

- `sed`: Stream editor for filtering and transforming text
  Example: `sed 's/old/new/' file.txt`

- `awk`: Pattern scanning and text processing language
  Example: `awk '{print $1}' file.txt`

### Advanced File Operations
- `find`: Search for files in a directory hierarchy
  Example: `find . -name "*.txt"`

- `tar`: Archive files
  Example: `tar -cvf archive.tar file1 file2`

- `zip`: Package and compress files
  Example: `zip archive.zip file1 file2`

## Advanced Commands

### Regular Expressions
- Regular expressions are patterns used to match character combinations in strings. They are used extensively in commands like `grep`, `sed`, and `awk`.
  
  Example:
  ```bash
  grep -E "[0-9]{3}-[0-9]{3}-[0-9]{4}" file.txt
  ```

### Process Control
- Process management commands allow you to control running processes and manage system resources.

  Example:
  ```bash
  nice -n 10 command
  ```

### Networking
- Advanced networking commands enable network diagnostics and management.

  Example:
  ```bash
  traceroute example.com
  ```

### System Monitoring
- System monitoring commands provide insights into system performance and resource usage.

  Example:
  ```bash
  vmstat 1
  ```

### System Information
- Commands to gather system information such as hardware details and system configuration.

  Example:
  ```bash
  uname -a
  ```

### Filesystem Management
- Advanced filesystem operations for disk management and maintenance.

  Example:
  ```bash
  fdisk -l
  ```
  
### Remote Access
- Tools for remote access and administration of systems.

  Example:
  ```bash
  ssh user@example.com
  ```

### Text Editors
- Basic usage of text editors for editing files in the terminal.

  Example:
  ```bash
  nano file.txt
  ```

### Environment Variables
- Explanation: How to view, set, and use environment variables.
- Example: `PATH`, `HOME`, `USER`.

### Redirection
- Explanation: How to redirect input and output streams.
- Example: `command > output.txt`, `command < input.txt`, `command 2> error.txt`.

### Conditional Statements
- Explanation: Basic conditional statements using `if`, `elif`, and `else`.
- Example: 
  ```bash
  if [ "$variable" -eq 1 ]; then
      echo "Variable is equal to 1"
  elif [ "$variable" -gt 1 ]; then
      echo "Variable is greater than 1"
  else
      echo "Variable is less than 1"
  fi
  ```

### Loops
- Explanation: Basic loop constructs such as `for` and `while`.
- Example:
  ```bash
  for i in {1..5}; do
      echo $i
  done
  ```

### Functions
- Explanation: How to define and use functions in Bash scripts.
- Example:
  ```bash
  my_function() {
      echo "Hello, world!"
  }
  ```

### Command Substitution
- Explanation: How to use command substitution to capture the output of a command.
- Example: `result=$(ls -l)`

## Advanced Topics

### Shell Scripting
- Explanation: How to write and execute shell scripts.
- Example: `#!/bin/bash`, `chmod +x script.sh`, `./script.sh`

### Arrays
- Explanation: How to declare and use arrays in Bash.
- Example: `my_array=(element1 element2 element3)`, `${my_array[0]}`

### Error Handling
- Explanation: Techniques for error handling in Bash scripts.
- Example: `set -e`, `trap 'error_handling_function' ERR`

### Debugging
- Explanation: Methods for debugging Bash scripts.
- Example: `set -x`, `echo "Debugging message"`

### String Manipulation
- Explanation: Advanced string manipulation techniques.
- Example: `substring=${string:start:length}`

### Arithmetic Operations
- Explanation: Performing arithmetic operations in Bash.
- Example: `result=$(( 5 + 3 ))`

### Regular Expressions (Advanced)
- Explanation: More advanced usage of regular expressions.
- Example: Lookaheads, lookbehinds, capturing groups.

### File Permissions
- Explanation: Understanding file permissions in Unix-like systems and how to change them.
- Example: `chmod u+x script.sh`

### Process Management
- Explanation: More advanced process management techniques such as backgrounding processes, job control, and process manipulation.
- Example: `ps aux | grep process_name`

### Scripting Best Practices
- Explanation: Guidelines for writing clean, efficient, and maintainable Bash scripts.
- Example: Proper commenting, code organization, and error handling.

### Advanced Text Processing
- Explanation: Techniques for advanced text processing using tools like `awk`, `sed`, and `cut`.
- Example: `awk '{print $1}' file.txt`

### Shell Variables
- Explanation: More in-depth coverage of shell variables, including environment variables, local variables, and special variables.
- Example: `$USER`, `$HOME`, `$?`


## File System Structure (Linux)

### Linux File System Hierarchy Standard (FHS)

- Explanation: The Linux File System Hierarchy Standard defines the structure and organization of files and directories in Linux-based operating systems.
- Example: 

  ```plaintext
  /           Root directory
  ├── bin     Essential command binaries
  ├── boot    Boot loader files
  ├── dev     Device files
  ├── etc     System configuration files
  ├── home    User home directories
  ├── lib     Shared libraries
  ├── media   Removable media mounts
  ├── mnt     Mount points for temporary file systems
  ├── opt     Add-on application software packages
  ├── proc    Virtual file system providing process information
  ├── root    Home directory for the root user
  ├── run     Application state information
  ├── srv     Data for services provided by the system
  ├── sys     Virtual file system providing kernel and hardware information
  ├── tmp     Temporary files
  ├── usr     User utilities and applications
  └── var     Variable data files
  ```

### Distribution-Specific Variations

- Explanation: Different Linux distributions may have variations in their file system structures, but they generally adhere to the Linux FHS to maintain compatibility and interoperability.
- Example: 

  - **Ubuntu/Debian**: Follows the FHS closely with `/bin`, `/etc`, `/home`, `/lib`, `/usr`, and `/var` directories.
  - **Red Hat/CentOS**: Similar to Ubuntu/Debian but may have differences in package management and configuration directories.
  - **Arch Linux**: Minimalistic approach with `/bin`, `/etc`, `/home`, `/usr`, and `/var` directories. Uses the `/mnt` directory for mounting drives.
  - **Fedora**: Similar to Red Hat/CentOS but may have newer software versions and additional development tools.
  - **openSUSE**: Similar to Red Hat/CentOS but may have differences in package management and system configuration.

### Understanding the File System

- Explanation: Understanding the file system structure is crucial for navigating and managing files and directories effectively in Linux-based systems.
- Example: Knowing the location of important directories such as `/etc` for system configuration files and `/home` for user home directories.


## Networking Commands

### ifconfig
- Explanation: View and configure network interfaces.
- Example: `ifconfig eth0`

### netstat
- Explanation: Display network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.
- Example: `netstat -ano`

### ip
- Explanation: Show and manipulate routing, devices, policy routing, and tunnels.
- Example: `ip addr show`

### ss
- Explanation: Utility to investigate sockets.
- Example: `ss -tuln`

## Package Management

### apt (Debian/Ubuntu)
- Explanation: Advanced Package Tool for managing software packages.
- Example: `apt-get install package_name`

### yum/dnf (Red Hat/CentOS/Fedora)
- Explanation: Yellowdog Updater Modified and Dandified Yum (DNF) for managing software packages.
- Example: `yum install package_name` or `dnf install package_name`

### pacman (Arch Linux)
- Explanation: Package manager for Arch Linux and its derivatives.
- Example: `pacman -S package_name`

### zypper (openSUSE)
- Explanation: Package manager for openSUSE and its derivatives.
- Example: `zypper install package_name`

## System Administration

### User and Group Management
- Explanation: Managing users and groups on the system.
- Example: `useradd username` or `groupadd groupname`

### Service Management
- Explanation: Starting, stopping, and managing system services.
- Example: `systemctl start service_name`

### System Performance Monitoring
- Explanation: Tools for monitoring system performance and resource usage.
- Example: `top` or `htop`

## Security

### Firewall Configuration
- Explanation: Configuring firewall rules to control incoming and outgoing network traffic.
- Example: `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`

### User Permissions
- Explanation: Setting permissions on files and directories to control access.
- Example: `chmod 755 filename` or `chown user:group filename`

### SSH Access Management
- Explanation: Managing SSH access to the system.
- Example: Editing `/etc/ssh/sshd_config` to configure SSH settings.

## Backup and Recovery

### Data Backup
- Explanation: Strategies and tools for backing up data.
- Example: `rsync -avz /source/path/ /destination/path/`

### System Recovery
- Explanation: Basic steps for system recovery in case of boot issues or system failures, including using recovery modes and Live CDs.
- Example: Booting into a Live CD and using it to repair the system.

### Disk Partitioning
- Explanation: Strategies for disk partitioning and tools like `fdisk` or `parted` for creating and managing partitions.
- Example: `sudo fdisk /dev/sda`

### File Compression
- Explanation: Techniques for compressing and decompressing files and directories using tools like `gzip` and `tar`.
- Example: `tar -czvf archive.tar.gz directory`

### System Updates
- Explanation: Updating the system and installing security patches using package managers like `apt` or `yum`.
- Example: `sudo apt update && sudo apt upgrade`

### Customization
- Explanation: Tips for customizing the Linux desktop environment, including changing themes, wallpapers, and desktop layouts.
- Example: Installing and applying a new GTK theme using a package manager.

### System Logs
- Explanation: Introduction to system log files and how to view and analyze them for troubleshooting purposes.
- Example: Viewing the system log file `/var/log/syslog` using `less` or `tail`.

### Modifying the Kernel
- Explanation: Overview of modifying and recompiling the Linux kernel, including adding or removing kernel modules and configuring kernel parameters.
- Example: Downloading the Linux kernel source code, modifying kernel configuration options using `make menuconfig`, and compiling the kernel.