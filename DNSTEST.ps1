# I've designed this to be scaleable with any amount of IP's and colour coding to display if a service goes down.
# In the future i'll be looking to implement a log system where it keeps the tables and isolated down nodes or experiences any extreme latency
# For now this is the finished script. Useful for sussing DNS issues or monitoring internal & external services accordingly.

$ips = "127.0.0.1", "8.8.8.8", "1.1.1.1", "1.0.0.1", "8.8.4.4", "0.0.0.0"  # Replace with your list of IPs

function Get-DnsStatus {
    param (
        [string]$ip
    )

    try {
        $pingResult = Test-Connection -ComputerName $ip -Count 2 -ErrorAction Stop

        if ($pingResult.ResponseTime -eq $null) {
            $responseTime = "N/A"
        } else {
            $responseTime = $pingResult.ResponseTime
        }

        $result = [PSCustomObject]@{
            IP = $ip
            Status = "Online"
            ResponseTime = $responseTime
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        $result
    } catch {
        $result = [PSCustomObject]@{
            IP = $ip
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

    $formatString = "{0,-15} {1,-8} {2,-18} {3,-19}"

    # Clear the console
    Clear-Host

    # Move the cursor to the top-left position
    [Console]::SetCursorPosition(0, 0)

    Write-Host ($formatString -f "IP", "Status", "ResponseTime (ms)", "Timestamp")

    foreach ($result in $Results) {
        # Move the cursor to the next line
        [Console]::SetCursorPosition(0, [Console]::CursorTop + 1)

        # Format ResponseTime explicitly
        $responseTime = if ($result.ResponseTime -eq "N/A") { $result.ResponseTime } else { "$($result.ResponseTime) ms" }

        # Set color based on Status
        if ($result.Status -eq "Online") {
            Write-Host ($formatString -f $result.IP, ("Online"), $responseTime, $result.Timestamp) -ForegroundColor Green
        } else {
            Write-Host ($formatString -f $result.IP, ("Offline"), $responseTime, $result.Timestamp) -ForegroundColor Red
        }
    }
}

while ($true) {
    # Get the results only once
    $previousResults = $ips | ForEach-Object { Get-DnsStatus -ip $_ }

    # Print the formatted table
    Print-FormattedTable -Results $previousResults

    # Sleep for 3 seconds
    Start-Sleep -Seconds 3
}
