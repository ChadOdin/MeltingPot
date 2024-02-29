$ipsWithPorts = @("127.0.0.1:443", "8.8.8.8:80", "1.1.1.1:53", "1.0.0.1:80", "8.8.4.4:53")
$ipsWithoutPorts = @("0.0.0.0")  # Replace with your list of IPs without ports

# List of hostnames formatted as "HOSTNAME:IP"
$hostnameMapping = @(
    "LocalHost:127.0.0.1",
    "Google:8.8.8.8",
    "Cloudflare:1.1.1.1",
    "Cloudflare2nd:1.0.0.1",
    "Google2nd:8.8.4.4"
    "Dud-IP:0.0.0.0"
)

function Test-PortConnection {
    param (
        [string]$ip,
        [int]$port
    )

    try {
        $socket = New-Object System.Net.Sockets.TcpClient
        $async = $socket.BeginConnect($ip, $port, $null, $null)

        # Wait for the connection to complete (timeout of 1 second)
        $wait = $async.AsyncWaitHandle.WaitOne(1000, $false)

        if ($wait -and !$socket.Connected) {
            # Connection failed
            $result = $false
        } else {
            # Connection succeeded
            $result = $true
        }
    } finally {
        if ($socket.Connected) {
            $socket.Close()
        }
    }

    $result
}

function Get-Status {
    param (
        [string]$ip
    )

    $ipParts = $ip -split ":"
    $ipAddress = $ipParts[0]
    $port = if ($ipParts.Length -gt 1) { [int]$ipParts[1] } else { $null }

    $hostname = $hostnameMapping | Where-Object { $_ -like "*:$ipAddress" } | ForEach-Object { ($_ -split ":")[0] }

    try {
        if ($port -ne $null) {
            $portTestResult = Test-PortConnection -ip $ipAddress -port $port
        } else {
            $portTestResult = $null
        }

        $icmpResult = Test-Connection -ComputerName $ipAddress -Count 2 -ErrorAction Stop

        $status = switch ($icmpResult.ResponseTime) {
            $null { "Offline" }
            default { "Online" }
        }

        $result = [PSCustomObject]@{
            Hostname = $hostname
            IP = $ipAddress
            Port = $port
            Status = if ($portTestResult -eq $null) { $status } else { if ($portTestResult) { $status } else { "Offline" } }
            ResponseTime = if ($null -eq $icmpResult.ResponseTime) { "N/A" } else { ($icmpResult.ResponseTime | Measure-Object -Average).Average }
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        $result
    } catch {
        $result = [PSCustomObject]@{
            Hostname = $hostname
            IP = $ipAddress
            Port = $port
            Status = "Offline"
            ResponseTime = "N/A"
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        $result
    }
}

# Function to print formatted table
function Print-FormattedTable {
    param (
        [array]$Results
    )

    $formatString = "{0,-15} {1,-15} {2,-8} {3,-18} {4,-19} {5,-5}"

    try {
        # Clear the console
        Clear-Host

        Write-Host ($formatString -f "Hostname", "IP", "Port", "Status", "ResponseTime (ms)", "Timestamp")

        foreach ($result in $Results) {
            # Format ResponseTime explicitly
            $responseTime = if ($result.ResponseTime -eq "N/A") { $result.ResponseTime } else { "$($result.ResponseTime) ms" }

            # Set color based on Status
            if ($result.Status -eq "Online") {
                Write-Host ($formatString -f $result.Hostname, $result.IP, $result.Port, "Online", $responseTime, "$($result.Timestamp)") -ForegroundColor Green
            } else {
                Write-Host ($formatString -f $result.Hostname, $result.IP, $result.Port, "Offline", $responseTime, "$($result.Timestamp)    !!!DOWN!!!") -ForegroundColor Red
            }
        }
    } catch [System.IO.IOException] {
        $null  # Ignore IOException and do nothing
    }
}

# Logging function
function Log-ToFile {
    param (
        [string]$filePath,
        [array]$Results
    )

    $Results | ForEach-Object {
        $logEntry = "$($_.Timestamp): $($_.Hostname) - $($_.IP) - $($_.Port) - $($_.Status) - $($_.ResponseTime)"
        Add-Content -Path $filePath -Value $logEntry
    }
}

# Log file path
$logFolderPath = Join-Path $env:USERPROFILE "DnsLogs"
$logFilePath = Join-Path $logFolderPath "Log.log"

# Check if the initial log file exists
$initialLogFileExists = Test-Path $logFilePath

# Create the initial log file if it doesn't exist
if (-not $initialLogFileExists) {
    # Create the log folder if it doesn't exist
    if (-not (Test-Path -Path $logFolderPath -PathType Container)) {
        New-Item -Path $logFolderPath -ItemType Directory
    }

    # Create the initial log file
    New-Item -Path $logFilePath -ItemType File
}

while ($true) {
    # Get the results only once
    $previousResults = $ipsWithPorts + $ipsWithoutPorts | ForEach-Object { Get-Status -ip $_ }

    # Print the formatted table
    Print-FormattedTable -Results $previousResults

    # Log the results to the initial log file
    Log-ToFile -filePath $logFilePath -Results $previousResults

    # Sleep for 3 seconds
    Start-Sleep -Seconds 3
}
