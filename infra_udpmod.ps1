# List of IP addresses with ports and packet types
$ipsWithPorts = @(
    @{ IP = "127.0.0.1:443"; PacketType = "TCP" },
    @{ IP = "8.8.8.8:80"; PacketType = "TCP" },
    @{ IP = "1.1.1.1:53"; PacketType = "TCP" },
    @{ IP = "1.0.0.1:80"; PacketType = "TCP" },
    @{ IP = "8.8.4.4:53"; PacketType = "TCP" },
    @{ IP = "192.168.1.1:9001"; PacketType = "UDP" },  # Example UDP IP and port
    # Add more entries as needed
)

# List of hostnames formatted as "HOSTNAME:IP"
$hostnameMapping = @(
    "LocalHost:127.0.0.1",
    "Google:8.8.8.8",
    "Cloudflare:1.1.1.1",
    "Cloudflare2nd:1.0.0.1",
    "Google2nd:8.8.4.4",
    "UDPIP:1.1.1.2:9001"
)

# Function to send UDP packets
function Send-UDPPacket {
    param (
        [string]$ip,
        [int]$port,
        [string]$data
    )

    try {
        $udpClient = New-Object System.Net.Sockets.UdpClient
        $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Parse($ip), $port)

        $bytes = [System.Text.Encoding]::ASCII.GetBytes($data)
        $udpClient.Send($bytes, $bytes.Length, $endpoint)

        $result = $true
    } catch {
        $result = $false
    } finally {
        $udpClient.Close()
    }

    $result
}

# Function to test TCP port connection
function Test-PortConnection {
    param (
        [string]$ip,
        [int]$port
    )

    try {
        $socket = New-Object System.Net.Sockets.TcpClient
        $async = $socket.BeginConnect($ip, $port, $null, $null)

        # Wait for the connection to complete (timeout of 1 minute to avoid tripping dos alarm)
        $wait = $async.AsyncWaitHandle.WaitOne(60000, $false)

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

# Function to get status with both TCP and UDP functionality
function Get-Status {
    param (
        [string]$ip,
        [string]$PacketType
    )

    $ipParts = $ip -split ":"
    $ipAddress = $ipParts[0]
    $port = if ($ipParts.Length -gt 1) { [int]$ipParts[1] } else { $null }

    $hostname = $hostnameMapping | Where-Object { $_ -like "*:$ipAddress" } | ForEach-Object { ($_ -split ":")[0] }

    try {
        if ($port -ne $null) {
            $portTestResult = Test-PortConnection -ip $ipAddress -port $port

            # Check if the port is in the printer port range (9000-12001) for UDP
            $isPrinterPort = ($PacketType -eq "UDP" -and $port -ge 9000 -and $port -le 12001)

            if ($isPrinterPort) {
                # Define UDP parameters
                $udpPort = $port
                $udpData = "Printer UDP Packet"

                # Send UDP packet
                $udpResult = Send-UDPPacket -ip $ipAddress -port $udpPort -data $udpData
            }
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

# Function to print formatted table with a dynamic header
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

# Function to log results to a file
function Log-ToFile {
    param (
        [string]$filePath,
        [array]$Results
    )

    $Results | ForEach-Object {
        $logEntry = "$($_.Timestamp): $($_.Hostname) - $($_.IP) - $($_.Port) - $($_.Status) - $($_.ResponseTime)"
        Add-Content -Path $filePath
        -Value $logEntry
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
    $previousResults = $ipsWithPorts | ForEach-Object {
        $ip = $_.IP
        $packetType = $_.PacketType
        Get-Status -ip $ip -PacketType $packetType
    }

    # Print the formatted table with dynamic header based on IP-specific packet type
    Print-FormattedTable -Results $previousResults

    # Log the results to the initial log file
    Log-ToFile -filePath $logFilePath -Results $previousResults

    # Sleep for 1 minute - Change to your preferred timing
    Start-Sleep -Seconds 60
}

