#test ver of DNS test script I've already written, this one includes a rudimentary logging function

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
    try {
        [Console]::SetCursorPosition(0, 0)
    } catch [System.IO.IOException] {
        $null = $host.UI.RawUI.FlushInputBuffer()
        Start-Sleep -Milliseconds 50
        [Console]::SetCursorPosition(0, 0)
    }

    Write-Host ($formatString -f "IP", "Status", "ResponseTime (ms)", "Timestamp")

    foreach ($result in $Results) {
        # Move the cursor to the next line
        try {
            [Console]::SetCursorPosition(0, [Console]::CursorTop + 1)
        } catch [System.IO.IOException] {
            $null = $host.UI.RawUI.FlushInputBuffer()
            Start-Sleep -Milliseconds 50
            [Console]::SetCursorPosition(0, [Console]::CursorTop + 1)
        }

        # Format ResponseTime explicitly
        $responseTime = if ($result.ResponseTime -eq "N/A") { $result.ResponseTime } else { "$($result.ResponseTime) ms" }

        # Set color based on Status
        if ($result.Status -eq "Online") {
            Write-Host ($formatString -f $result.IP, ("Online"), $responseTime, "$($result.Timestamp) <--- UP") -ForegroundColor Green
        } else {
            Write-Host ($formatString -f "$($result.IP) <--- DOWN", ("Offline"), $responseTime, "$($result.Timestamp)") -ForegroundColor Red
        }
    }
}

# Logging function
function Log-ToFile {
    param (
        [string]$filePath,
        [array]$Results
    )

    $Results | ForEach-Object {
        $logEntry = "$($_.Timestamp): $($_.IP) - $($_.Status) - $($_.ResponseTime)"
        Add-Content -Path $filePath -Value $logEntry
    }
}

# Log file path
$logFilePath = "C:\Path\To\Your\Log\File.log"

while ($true) {
    # Get the results only once
    $previousResults = $ips | ForEach-Object { Get-DnsStatus -ip $_ }

    # Print the formatted table
    Print-FormattedTable -Results $previousResults

    # Log the results to a file
    Log-ToFile -filePath $logFilePath -Results $previousResults

    # Sleep for 3 seconds
    Start-Sleep -Seconds 3
}
