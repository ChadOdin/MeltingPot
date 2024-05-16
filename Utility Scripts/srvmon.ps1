$cpuThreshold = 80
$memoryThreshold = 90
$diskThreshold = 80

function Send-EmailAlert {
    param(
        [string]$subject,
        [string]$body
    )

    $smtpServer = "exchange-server"
    $from = "first.last@domain"
    $to = "distrogroup@domain"
    $hostname = $env:COMPUTERNAME
    
    $msg = New-Object Net.Mail.MailMessage($from, $to)
    $msg.Subject = "$hostname - $subject"
    $msg.Body = $body
    
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer)
    $smtp.Send($msg)
}

function Check-CPUUsage {
    $cpuUsage = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    if ($cpuUsage -ge $cpuThreshold) {
        Send-EmailAlert -subject "High CPU Usage Alert" -body "CPU usage is at $cpuUsage%."
    }
}

function Check-MemoryUsage {
    $memoryUsage = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
    $totalMemory = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $memoryPercentage = ($totalMemory - $memoryUsage) / $totalMemory * 100
    if ($memoryPercentage -ge $memoryThreshold) {
        Send-EmailAlert -subject "High Memory Usage Alert" -body "Memory usage is at $memoryPercentage%."
    }
}

function Check-DiskSpace {
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object -ExpandProperty FreeSpace
    $diskPercentage = $disk / (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object -ExpandProperty Size) * 100
    if ($diskPercentage -ge $diskThreshold) {
        Send-EmailAlert -subject "Low Disk Space Alert" -body "Disk space is at $diskPercentage%."
    }
}

while ($true) {
    Check-CPUUsage
    Check-MemoryUsage
    Check-DiskSpace
    Start-Sleep -Seconds 300
}