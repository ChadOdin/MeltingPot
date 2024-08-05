function Get-LocalIPv4Addresses {
    $ipv4Addresses = ipconfig | Select-String "IPv4" | ForEach-Object {
        $_ -match ":\s*(\d{1,3}(?:\.\d{1,3}){3})" | Out-Null
        $matches[1]
    }
    return $ipv4Addresses
}

function Get-NetworkConnections {
    if (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue) {
        $tcpConnections = Get-NetTCPConnection | Select-Object @{Name='Protocol';Expression={'TCP'}}, LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
        $udpConnections = Get-NetUDPEndpoint | Select-Object @{Name='Protocol';Expression={'UDP'}}, LocalAddress, LocalPort, @{Name='RemoteAddress';Expression={'*'}}, @{Name='RemotePort';Expression={0}}, @{Name='State';Expression={'N/A'}}, OwningProcess

        $connections = $tcpConnections + $udpConnections
    } else {
        # Failover to netstat if new cmdlets fail
        $netstatOutput = netstat -ano | Select-String "TCP|UDP"
        $connections = foreach ($line in $netstatOutput) {
            $parts = $line -split '\s+'
            if ($parts[1] -match ':(\d+)$' -and $parts[2] -match ':(\d+)$') {
                [PSCustomObject]@{
                    Protocol = $parts[0]
                    LocalAddress = $parts[1] -replace ':\d+$', ''
                    LocalPort = [int]($parts[1] -split ':')[-1]
                    RemoteAddress = $parts[2] -replace ':\d+$', ''
                    RemotePort = [int]($parts[2] -split ':')[-1]
                    State = if ($parts[0] -eq 'TCP') { $parts[3] } else { 'N/A' }
                    OwningProcess = $parts[-1]
                }
            }
        }
    }
    return $connections
}

$localIPv4Addresses = Get-LocalIPv4Addresses

$connections = Get-NetworkConnections

$filteredConnections = $connections | Where-Object { $localIPv4Addresses -contains $_.LocalAddress }

$groupedPorts = $filteredConnections | Group-Object -Property LocalPort

$combinedPorts = foreach ($group in $groupedPorts) {
    $portNumber = $group.Name
    $inboundConnections = $group.Group | Where-Object { $_.RemotePort -eq $portNumber -and $_.LocalAddress -in $localIPv4Addresses }
    $outboundConnections = $group.Group | Where-Object { $_.LocalPort -eq $portNumber -and $_.LocalAddress -in $localIPv4Addresses }

    [PSCustomObject]@{
        Port = $portNumber
        Protocol = ($group.Group | Select-Object -First 1).Protocol
        LocalAddress = ($group.Group | Select-Object -First 1).LocalAddress
        RemoteAddress = ($group.Group | Select-Object -First 1).RemoteAddress
        State = ($group.Group | Select-Object -First 1).State
        OwningProcess = ($group.Group | Select-Object -First 1).OwningProcess
        Inbound = if ($inboundConnections) { 'Yes' } else { 'No' }
        Outbound = if ($outboundConnections) { 'Yes' } else { 'No' }
    }
}

$sortedCombinedPorts = $combinedPorts | Sort-Object -Property Port

$sortedCombinedPorts | Format-Table -Property Port, Protocol, LocalAddress, RemoteAddress, State, OwningProcess, Inbound, Outbound -AutoSize
