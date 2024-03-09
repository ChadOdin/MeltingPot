# Define list of IPs with ports formatted as "IP:Port" or "IP:Port:PacketType"
$ipsWithPorts = @("127.0.0.1:443", "8.8.8.8:80", "1.1.1.1:53", "1.0.0.1:80", "8.8.4.4:53", "192.168.1.1:9001:UDP")

# List of hostnames formatted as "HOSTNAME:IP"
$hostnameMapping = @(
    "LocalHost:127.0.0.1",
    "Google:8.8.8.8",
    "Cloudflare:1.1.1.1",
    "Cloudflare2nd:1.0.0.1",
    "Google2nd:8.8.4.4",
    "UDPIP:192.168.1.1"
)

# Function to test TCP port connection using .NET classes
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

# Function to send UDP packet using .NET classes
function Send-UDPPacket {
    param (
        [string]$ip,
        [int]$port,
        [string]$data
    )

    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect($ip, $port)

    $sendBytes = [System.Text.Encoding]::ASCII.GetBytes($data)
    $udpClient.Send($sendBytes, $sendBytes.Length)
}

# Function to get status with both TCP and UDP functionality
function Get-Status {
    param (
        [string]$ip
    )

    $ipParts = $ip -split ":"
    $ipAddress = $ipParts[0]
    $port = if ($ipParts.Length -gt 1) { [int]$ipParts[1] } else { $null }
    
    $hostname = $hostnameMapping | Where-Object { $_ -like "*:$ipAddress" } | ForEach-Object { ($_ -split ":")[0] }
    $isUDP = $ip -like "*:UDP"

    try {
        if ($isUDP) {
            # Define UDP parameters
            $udpPort = $port
            $udpData = "Printer UDP Packet"

            # Send UDP packet
            $udpResult = Send-UDPPacket -ip $ipAddress -port $udpPort -data $udpData
        }

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
            PacketType = if ($isUDP) { "UDP" } else { "TCP" }
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
            PacketType = if ($isUDP) { "UDP" } else { "TCP" }
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

    $formatString = "{0,-15} {1,-15} {2,-8} {3,-12} {4,-18} {5,-19} {6,-5}"

    try {
        # Clear the console
        Clear-Host

        Write-Host ($formatString -f "Hostname", "IP", "Port", "PacketType", "Status", "ResponseTime (ms)", "Timestamp")

        foreach ($result in $Results) {
            # Format ResponseTime explicitly
            $responseTime = if ($result.ResponseTime -eq "N/A") { $result.ResponseTime } else { "$($result.ResponseTime) ms" }

            # Set color based on Status
            if ($result.Status -eq "Online") {
                Write-Host ($formatString -f $result.Hostname, $result.IP, $result.Port, $result.PacketType, "Online", $responseTime, "$($result.Timestamp)") -ForegroundColor Green
            } else {
                Write-Host ($formatString -f $result.Hostname, $result.IP, $result.Port, $result.PacketType, "Offline", $responseTime, "$($result.Timestamp)    !!!DOWN!!!") -ForegroundColor Red
            }
        }
    } catch [System.IO.IOException] {
        $null  # Ignore IOException and do nothing
    }
}

# Main loop
while ($true) {
    # Get the results only once
    $previousResults = $ipsWithPorts | ForEach-
    $ipsWithPorts | ForEach-Object { Get-Status -ip $_ }

    # Print the formatted table
    Print-FormattedTable -Results $previousResults

    # Log the results to the initial log file
    Log-ToFile -filePath $logFilePath -Results $previousResults

    # Sleep for 3 seconds - Change to your preferred timing
    Start-Sleep -Seconds 3
}

