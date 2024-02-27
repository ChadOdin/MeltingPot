# Input file path containing the list of users
$inputFilePath = "C:\path\to\userlist.txt"

# Output CSV file path
$outputFilePath = "C:\path\to\output.csv"

# Read user list from the input file
$userList = Get-Content $inputFilePath

# Create an array to store the formatted user principal names (UPNs)
$formattedUsers = foreach ($user in $userList) {
    [PSCustomObject]@{
        UPN = $user
    }
}

# Export the formatted users to a CSV file
$formattedUsers | Export-Csv -Path $outputFilePath -NoTypeInformation -Force

Write-Host "CSV file created at $outputFilePath"
