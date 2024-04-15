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