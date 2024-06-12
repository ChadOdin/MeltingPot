Write-Host "Network Troublshooting Script."
Write-Host "V1.2" -ForegroundColor Green


# Function to perform network troubleshooting
function Test-Network {
    # Get network adapters
    $Adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

    # Array to store network configuration issues
    $ConfigurationIssues = @()

    # Check network configuration for each adapter
    foreach ($Adapter in $Adapters) {
        # Get IP configuration for the adapter
        $IpConfig = Get-NetIPAddress -InterfaceIndex $Adapter.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
        $Route = Get-NetRoute -InterfaceIndex $Adapter.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue

        # Check if IPv4 address is assigned
        if (!$IpConfig) {
            $ConfigurationIssues += "IPv4 Address not assigned on $($Adapter.Name)"
        }

        # Check if default gateway is configured
        $DefaultGateway = ($Route | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" }).NextHop
        if (!$DefaultGateway) {
            $ConfigurationIssues += "No default gateway configured on $($Adapter.Name)"
        }
    }

    # Output network configuration issues
    if ($ConfigurationIssues) {
        Write-Host "Network Configuration Issues:" -ForegroundColor Red
        $ConfigurationIssues | ForEach-Object { Write-Host "- $_" }
        Start-Sleep 5
    } else {
        Write-Host "No network configuration issues found." -ForegroundColor Green
    }

    # Test DNS server connections
    $DnsServers = "1.1.1.1", "8.8.8.8", "8.8.4.4"
    Write-Host "Testing DNS server connections..." -ForegroundColor Blue
    start-sleep 2
    foreach ($DnsServer in $DnsServers) {
        Test-DnsServer $DnsServer
    }
}

# Function to test connection to a DNS server
function Test-DnsServer {
    param (
        [string]$DnsServer
    )

    if (Test-Connection -ComputerName $DnsServer -Count 1 -Quiet) {
        Write-Host "Connection to DNS Server ${DnsServer}: Successful" -ForegroundColor Green
        start-sleep 2
    } else {
        Write-Host "Connection to DNS Server ${DnsServer}: Failed" -ForegroundColor Red
        start-sleep 2
    }
}


# Perform network troubleshooting
Test-Network
