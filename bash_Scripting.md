# Bash Scripting Cheatsheet

### Bash Script Basics
- **Shebang**: `#!/bin/bash` at the top of the script to specify the interpreter.
- **Comments**: `#` for single-line comments.
- **Variables**:
  ```bash
  VAR=value
  echo $VAR
  ```
- **Quotes**: `"` double quotes for variable interpolation, `'` single quotes for literal strings.
- **Escape Characters**: `\` to escape special characters.

### Control Structures
- **If-Else Statement**:
  ```bash
  if [ condition ]; then
      # commands
  elif [ condition ]; then
      # commands
  else
      # commands
  fi
  ```

- **For Loop**:
  ```bash
  for item in list; do
      # commands
  done
  ```

- **While Loop**:
  ```bash
  while [ condition ]; do
      # commands
  done
  ```

- **Case Statement**:
  ```bash
  case expression in
      pattern1) commands ;;
      pattern2) commands ;;
      *) default commands ;;
  esac
  ```

### File Operations
- **File Test Operators**:
  ```bash
  -e file # File exists
  -f file # File is a regular file
  -d file # File is a directory
  -r file # File is readable
  -w file # File is writable
  -x file # File is executable
  ```

- **File Operations**:
  ```bash
  touch file.txt # Create an empty file
  rm file.txt # Remove a file
  mv oldfile newfile # Rename a file
  cp file1 file2 # Copy a file
  ```

### Functions
- **Defining Functions**:
  ```bash
  function_name() {
      # commands
  }
  ```

- **Calling Functions**:
  ```bash
  function_name arg1 arg2
  ```

### Input/Output
- **Reading Input**:
  ```bash
  read -p "Prompt: " variable
  ```

- **Output**:
  ```bash
  echo "Text" > file.txt # Write to a file (overwrites)
  echo "Text" >> file.txt # Append to a file
  ```

### Advanced
- **Command Substitution**:
  ```bash
  result=$(command)
  ```

- **Arithmetic Operations**:
  ```bash
  $(( expression ))
  ```

- **Arrays**:
  ```bash
  array=(item1 item2 item3)
  echo ${array[0]} # Access element
  ```

- **Exit Status**:
  ```bash
  command
  if [ $? -eq 0 ]; then
      echo "Success"
  else
      echo "Failure"
  fi
  ```

- **File Redirection**:
  ```bash
  command > output.txt 2>&1 # Redirect stdout and stderr to a file
  ```

### Error Handling
- **Exit on Error**:
  ```bash
  set -e
  ```
- **Error Message**:
  ```bash
  echo "Error message" >&2
  ```

### Conditional Expressions
- **Numeric Comparison**:
  ```bash
  -eq, -ne, -lt, -le, -gt, -ge
  ```
- **String Comparison**:
  ```bash
  =, !=, <, >
  ```

### String Operations
- **Substring Extraction**:
  ```bash
  ${string:position:length}
  ```
- **String Length**:
  ```bash
  ${#string}
  ```

### Environment Variables
- **Accessing Environment Variables**:
  ```bash
  $VAR
  ```
- **Setting Environment Variables**:
  ```bash
  export VAR=value
  ```

### Command-Line Arguments
- **Positional Parameters**:
  ```bash
  $1, $2, ..., $n
  ```
- **Number of Arguments**:
  ```bash
  $# 
  ```
- **Getopts for Parsing Options**:
  ```bash
  while getopts ":abc" opt; do
      case $opt in
          a) # option a
             ;;
          b) # option b
             ;;
          c) # option c
             ;;
          \?) echo "Invalid option: -$OPTARG" >&2
              ;;
      esac
  done
  ```