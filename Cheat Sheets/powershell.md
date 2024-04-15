# PowerShell Cheat Sheet

## Basic Commands

### Get-ChildItem
- Description: Lists the files and folders in a directory.
- Syntax: `Get-ChildItem [-Path] <String[]> [-Filter <String>] [-Recurse] [-File] [-Directory] [-Hidden] [-Force] [-Name] [-Attributes <FileAttributes[]>] [-Depth <UInt32>] [-ErrorAction <ActionPreference>] [-HiddenAttribute <FileAttributes>] [-ReadOnly] [-System] [-UseTransaction [<SwitchParameter>]] [-Credential <PSCredential>] [-Stream <String[]>] [<CommonParameters>]`

- Parameters:
  - `-Path`: Specifies the path to the items.
  - `-Filter`: Specifies a filter to qualify the Path parameter.
  - `-Recurse`: Retrieves the items in the specified locations and in all child items of the locations.
  - and more...
- Example: 
  ```powershell
  Get-ChildItem -Path C:\Windows -Recurse -Filter "*.txt"
  ```

### Get-Process
- Description: Retrieves information about processes running on the computer.
- Syntax: `Get-Process [[-Name] <String[]>] [-ComputerName <String[]>] [-FileVersionInfo] [-Module] [<CommonParameters>]`
- Parameters:
  - `-Name`: Specifies the process names of the processes to be retrieved.
  - `-ComputerName`: Specifies the names of the computers from which to retrieve processes.
  - and more...
- Example: 
  ```powershell
  Get-Process -Name "chrome"
  ```

### Get-Help
- Description: Displays information about PowerShell commands and concepts.
- Syntax: `Get-Help [-Name] <String> [-Parameter <String>] [-Category <String>] [-Component <String>] [-Role <String>] [-Functionality <String>] [-RoleCapability <String>] [-Online] [-ShowWindow] [<CommonParameters>]`
- Parameters:
  - `-Name`: Specifies the name of the cmdlet, function, or script about which you want to get Help content.
  - `-Online`: Displays the most recent help topic online.
  - and more...
- Example: 
  ```powershell
  Get-Help Get-ChildItem -Online
  ```

## Interoperability with CMD

### Running CMD Commands
- Description: You can run CMD commands directly within PowerShell.
- Example: `cmd /c dir`

### WMIC (Windows Management Instrumentation Command-line)
- Description: Allows access to various system management information and operations.
- Example: `wmic process get Caption,ProcessId,CommandLine`

## Basic Scripting

### Variables
- Description: Used to store data.
- Example: `$name = "John"`

### If Statement
- Description: Executes a block of code if a condition is true.
- Example: 
  ```powershell
  if ($name -eq "John") {
      Write-Output "Hello, John!"
  }
  ```

### Loops
- Description: Repeats a block of code multiple times.
- Example: 
  ```powershell
  for ($i=1; $i -le 5; $i++) {
      Write-Output "Iteration $i"
  }
  ```

### Functions
- Description: Blocks of reusable code.
- Example: 
  ```powershell
  function SayHello {
      param($name)
      Write-Output "Hello, $name!"
  }
  SayHello -name "Alice"
  ```

### Comments
- Description: Annotations within the code that are not executed.
- Example: 
  ```powershell
  # This is a comment
  ```

## Additional Concepts

### Error Handling Techniques
- Description: Handling errors gracefully in PowerShell scripts.
- Example:
  ```powershell
  try {
      # Code that might cause an error
  } catch {
      # Error handling code
  }
  ```

### Pipeline Concepts
- Description: Understanding PowerShell pipelines.
- Example: 
  ```powershell
  Get-ChildItem | Where-Object { $_.Name -like "*.txt" } | Select-Object FullName
  ```

### Environment Management
- Description: Managing environment variables in PowerShell.
- Example: 
  ```powershell
  $env:PATH += ";C:\new\path"
  ```

### Module Management
- Description: Managing PowerShell modules.
- Example: 
  ```powershell
  Install-Module -Name ModuleName
  ```

### Remote Management
- Description: Managing remote systems using PowerShell.
- Example: 
  ```powershell
  Enter-PSSession -ComputerName RemoteComputer
  ```

### Script Execution Policies
- Description: Setting script execution policies.
- Example: 
  ```powershell
  Set-ExecutionPolicy RemoteSigned
  ```

### Common Cmdlets for Specific Tasks
- Description: Commonly used cmdlets for various tasks.
- Example: 
  ```powershell
  Get-Content -Path "file.txt"
  ```

### Regular Expressions
- Description: Using regular expressions in PowerShell.
- Example: 
  ```powershell
  "Hello World" -match "Hello"
  ```

### PowerShell ISE Shortcuts
- Description: Keyboard shortcuts and tips for using PowerShell ISE.
- Example: 
  `Ctrl + J` - Show command completions

### Debugging Techniques
- Description: Techniques for debugging PowerShell scripts.
- Example: 
  ```powershell
  Set-PSBreakpoint -Script script.ps1 -Line 10
  ```

### Best Practices
- Description: Best practices for writing PowerShell scripts.
- Example: 
  - sanatize all inputs, loops and outputs. this can be done by clearing credentials or loops every time it processes and/or once you no longer need them.
  - Use meaningful variable names
  - Comment your code only while testing beta versions. a full script should have cryptic and minimal comments. this helps to reduce attack surface for bad actors.

### Online Resources
- Description: References to online documentation and communities.
- Example:
  - [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
  - [PowerShell.org Forums](https://powershell.org/forums/)

## Pipelines

### Introduction
- Description: Allows chaining of multiple cmdlets to perform complex operations.
- Example: 
  ```powershell
  Get-Process | Where-Object { $_.Handles -gt 1000 } | Sort-Object -Property CPU -Descending | Select-Object -First 5
  ```
- Explanation:
  - `Get-Process`: Retrieves information about processes.
  - `Where-Object { $_.Handles -gt 1000 }`: Filters processes with more than 1000 handles.
  - `Sort-Object -Property CPU -Descending`: Sorts processes by CPU usage in descending order.
  - `Select-Object -First 5`: Selects the first 5 processes after sorting.
