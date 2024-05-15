```
C:\
└── Windows
    └── System32
        ├── config
        │   ├── BCD           # Boot Configuration Data
        │   ├── SAM           # Security Account Manager
        │   ├── SECURITY      # Security settings
        │   ├── software      # Software registry hive
        │   └── system        # System registry hive
        ├── etc              # System configuration files
        ├── drivers          # Device drivers
        │   ├── etc
        │   │   ├── acpi.sys          # ACPI Driver for NT
        │   │   ├── disk.sys          # Disk driver
        │   │   ├── fvevol.sys        # BitLocker Drive Encryption
        │   │   ├── ndis.sys          # Network Driver Interface Specification (NDIS)
        │   │   ├── ntfs.sys          # NT File System Driver
        │   │   ├── pci.sys           # Peripheral Component Interconnect (PCI) bus driver
        │   │   ├── tcpip.sys         # TCP/IP Protocol Driver
        │   │   ├── usbccgp.sys       # USB Common Class Generic Parent Driver
        │   │   └── ...
        │   ├── etc...
        │   └── ...
        ├── LogFiles         # System log files
        ├── Tasks            # Task Scheduler tasks
        ├── Spool            # Printer spooler files
        ├── Tasks            # Task Scheduler tasks
        ├── Microsoft.NET    # .NET framework files
        ├── PowerShell       # PowerShell scripts and modules
        ├── wbem             # Windows Management Instrumentation (WMI)
        ├── winsxs           # Windows side-by-side assemblies
        └── ...
```


## Default Extensions

- **.sys**: System files
- **.dll**: Dynamic Link Libraries
- **.exe**: Executable files
- **.bat**: Batch files
- **.cmd**: Command scripts
- **.msi**: Windows Installer package
- **.lnk**: Shortcut files
- **.ini**: Initialization files
- **.log**: Log files
- **.tmp**: Temporary files
- **.cfg**: Configuration files
- **.inf**: Information files
- **.dat**: Data files

## CMD CLI Commands

- **cd**: Change directory
```cmd
C:\$ cd C:\windows\system32
```
- **dir**: List directory contents
```cmd
C:\windows\system32$ dir
C:\windows\system32
```
- **mkdir**: Make directory
```cmd
C:\windows\system32$ mkdir temp
C:\windows\system32$ cd /temp/

C:\windows\system32\temp$
```
- **rmdir**: Remove directory
- **copy**: Copy files and directories
- **move**: Move files and directories
- **del**: Delete files
- **ren**: Rename files and directories
- **cls**: Clear the command prompt screen
- **echo**: Display message or enable/disable echoing of commands
- **type**: Display the contents of a file
- **ipconfig**: Display TCP/IP network configuration
- **ping**: Test network connection
- **tasklist**: List running processes
- **taskkill**: Terminate processes by process ID or image name
- **shutdown**: Shutdown or restart the computer
- **net**: Network commands (e.g., net user, net share)
- **reg**: Registry manipulation commands
- **sfc**: System File Checker
- **chkdsk**: Check disk for errors
- **format**: Format a disk
- **sc**: Service Control Manager commands
- **gpupdate**: Update Group Policy settings
- **wmic**: Windows Management Instrumentation Command-line

## System Utilities

- **Task Manager**:
  - **Description**: Monitor and manage running processes, performance, and applications.
  - **PowerShell Command**: `taskmgr`
  - **CMD Command**: `taskmgr`

- **Disk Cleanup**:
  - **Description**: Free up disk space by deleting temporary files and unnecessary system files.
  - **PowerShell Command**: `cleanmgr`
  - **CMD Command**: `cleanmgr`

- **System Restore**:
  - **Description**: Restore the system to a previous state if problems occur.
  - **PowerShell Command**: `rstrui`
  - **CMD Command**: `rstrui`

- **Control Panel**:
  - **Description**: Centralized configuration and management of system settings.
  - **PowerShell Command**: `control`
  - **CMD Command**: `control`

- **Device Manager**:
  - **Description**: Manage hardware devices and drivers.
  - **PowerShell Command**: `devmgmt.msc`
  - **CMD Command**: `devmgmt.msc`

- **Computer Management**:
  - **Description**: Comprehensive management console for various system tasks (e.g., disk management, event viewer, services).
  - **PowerShell Command**: `compmgmt.msc`
  - **CMD Command**: `compmgmt.msc`

- **System Configuration (msconfig)**:
  - **Description**: Configure system startup, services, and boot options.
  - **PowerShell Command**: `msconfig`
  - **CMD Command**: `msconfig`

- **System Information**:
  - **Description**: View detailed information about the system hardware, software, and components.
  - **PowerShell Command**: `msinfo32`
  - **CMD Command**: `msinfo32`

- **Windows PowerShell**:
  - **Description**: Powerful shell and scripting environment for system administration tasks.
  - **PowerShell Command**: `powershell`
  - **CMD Command**: `powershell`

- **Remote Desktop Connection**:
  - **Description**: Access and control a remote desktop from another computer.
  - **PowerShell Command**: `mstsc`
  - **CMD Command**: `mstsc`

- **Remote Assistance**:
  - **Description**: Allow someone else to connect to your computer remotely to help troubleshoot issues.
  - **PowerShell Command**: `msra`
  - **CMD Command**: `msra`

## File Management Commands

- **copy**: Copy files and directories.
  - **PowerShell Command**: `Copy-Item`
  - **CMD Command**: `copy`

- **move**: Move files and directories.
  - **PowerShell Command**: `Move-Item`
  - **CMD Command**: `move`

- **del**: Delete files and directories.
  - **PowerShell Command**: `Remove-Item`
  - **CMD Command**: `del`

- **ren**: Rename files and directories.
  - **PowerShell Command**: `Rename-Item`
  - **CMD Command**: `ren`

- **dir**: List directory contents.
  - **PowerShell Command**: `Get-ChildItem`
  - **CMD Command**: `dir`

- **mkdir**: Make directories.
  - **PowerShell Command**: `New-Item`
  - **CMD Command**: `mkdir`

- **rmdir**: Remove directories.
  - **PowerShell Command**: `Remove-Item`
  - **CMD Command**: `rmdir`

- **xcopy**: Copy files and directories with advanced options.
  - **PowerShell Command**: N/A
  - **CMD Command**: `xcopy`

## Registry Commands

- **regedit**: Registry Editor.
  - **PowerShell Command**: N/A
  - **CMD Command**: `regedit`

- **reg add**: Add a new registry entry.
  - **PowerShell Command**: N/A
  - **CMD Command**: `reg add`

- **reg delete**: Delete a registry entry.
  - **PowerShell Command**: N/A
  - **CMD Command**: `reg delete`

- **reg query**: Query the registry for information.
  - **PowerShell Command**: N/A
  - **CMD Command**: `reg query`

- **reg export**: Export a registry key to a file.
  - **PowerShell Command**: N/A
  - **CMD Command**: `reg export`

- **reg import**: Import a registry file into the registry.
  - **PowerShell Command**: N/A
  - **CMD Command**: `reg import`

## Task Scheduler Commands

- **schtasks**: Create, modify, delete, or view scheduled tasks.
  - **PowerShell Command**: N/A
  - **CMD Command**: `schtasks`

- **Task Scheduler GUI**: Graphical interface for managing scheduled tasks.
  - **PowerShell Command**: N/A
  - **CMD Command**: `taskschd.msc`

## System Information Tools

- **System Information**: Display detailed information about the system hardware, software, and components.
  - **PowerShell Command**: N/A
  - **CMD Command**: `msinfo32`

- **Device Manager**: View and manage hardware devices and drivers.
  - **PowerShell Command**: N/A
  - **CMD Command**: `devmgmt.msc`

- **DirectX Diagnostic Tool (dxdiag)**: Diagnose and troubleshoot DirectX-related issues.
  - **PowerShell Command**: N/A
  - **CMD Command**: `dxdiag`

## Recovery and Repair Tools

- **System File Checker (sfc)**: Scan and repair corrupted system files.
  - **PowerShell Command**: `sfc /scannow`
  - **CMD Command**: `sfc /scannow`

- **Check Disk (chkdsk)**: Check disk for errors and repair them.
  - **PowerShell Command**: N/A
  - **CMD Command**: `chkdsk`

- **Windows Recovery Environment (WinRE)**: Access troubleshooting and recovery tools when the system fails to boot.
  - **PowerShell Command**: N/A
  - **CMD Command**: `winre`

- **Automatic Repair**: Automatically attempt to repair common startup issues.
  - **PowerShell Command**: N/A
  - **CMD Command**: `bootrec /fixmbr`

## Networking Commands

- **ping**: Test network connection by sending ICMP echo request packets to a target host.
  - **PowerShell Command**: `Test-Connection`
  - **CMD Command**: `ping`

- **ipconfig**: Display TCP/IP network configuration information.
  - **PowerShell Command**: `Get-NetIPAddress`
  - **CMD Command**: `ipconfig`

- **netstat**: Display active network connections, listening ports, and routing tables.
  - **PowerShell Command**: `Get-NetTCPConnection`
  - **CMD Command**: `netstat`

- **tracert**: Trace the route taken by packets across an IP network to a specified destination.
  - **PowerShell Command**: N/A
  - **CMD Command**: `tracert`

- **nslookup**: Query DNS for information about domain names and IP addresses.
  - **PowerShell Command**: N/A
  - **CMD Command**: `nslookup`

- **net**: Network commands for managing network resources (e.g., users, shares).
  - **PowerShell Command**: N/A
  - **CMD Command**: `net`

## Security Tools

- **Windows Defender**: Built-in antivirus and antimalware software.
  - **PowerShell Command**: `Start-MpScan`
  - **CMD Command**: `start msascui`

- **BitLocker**: Encrypts disk drives to protect data in case of theft or unauthorized access.
  - **PowerShell Command**: `Enable-BitLocker`
  - **CMD Command**: `manage-bde`

- **Windows Firewall**: Manages inbound and outbound network traffic based on predefined security rules.
  - **PowerShell Command**: `New-NetFirewallRule`
  - **CMD Command**: `firewall.cpl`

