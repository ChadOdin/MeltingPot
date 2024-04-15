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