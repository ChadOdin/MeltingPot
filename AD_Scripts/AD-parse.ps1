Write-Host "[!] Warning: Test script. DO NOT RUN TO PROD. [!]" -ForegroundColor Red

# Import the necessary module
Import-Module ImportExcel

# Prompt user for the path to the Excel file
$excelFilePath = Read-Host -Prompt "Enter the path to the Excel file"

# Read the Excel sheet into a PowerShell object
$excelData = Import-Excel -Path $excelFilePath

# Initialize an array to store discrepancies
$discrepancies = @()

# Loop through each row in the Excel sheet
foreach ($row in $excelData) {
    $originalUserName = $row.UserName
    $userName = $originalUserName -replace '\s', '.' # Replace whitespace with '.'

    # Append domain and email suffix (for simulation purposes)
    $userEmail = "$userName@domain.co.uk"

    # Simulate AD query (replace with actual AD querying code in production)
    $adUser = $row | Select-Object -Property Email, Department

    if ($adUser) {
        # Check if the data matches
        $isEmailMatch = $adUser.Email -eq $row.Email
        $isDepartmentMatch = $adUser.Department -eq $row.Department

        if (-not $isEmailMatch -or -not $isDepartmentMatch) {
            # Store discrepancies
            $discrepancies += [PSCustomObject]@{
                UserName = $originalUserName
                EmailDiscrepancy = $row.Email -ne $adUser.Email
                DepartmentDiscrepancy = $row.Department -ne $adUser.Department
            }
        }
    } else {
        Write-Host "User $originalUserName not found (simulation)."
    }

    # Clear variables after each iteration
    Clear-Variable -Name originalUserName, userName, user, isEmailMatch, isDepartmentMatch -ErrorAction SilentlyContinue
}

# Display discrepancies
if ($discrepancies.Count -gt 0) {
    Write-Host "Discrepancies found:"
    $discrepancies | Format-Table -AutoSize
} else {
    Write-Host "No discrepancies found."
}
