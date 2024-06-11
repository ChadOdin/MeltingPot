# Import the necessary modules
Import-Module ImportExcel
Import-Module ActiveDirectory

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

    # Append domain and email suffix
    $userEmail = "$userName@domain.co.uk"
    
    # Query AD for the user(s)
    $adUsers = Get-ADUser -Filter {SamAccountName -eq $userEmail} -Property EmailAddress, Department

    if ($adUsers) {
        if ($adUsers.Count -eq 1) {
            $adUser = $adUsers[0] # If only one user found, use it
        } else {
            Write-Warning "Multiple users found in Active Directory for email address: $userEmail"
            Write-Warning "Users found:"
            $adUsers | ForEach-Object {
                $_.Name
            }
            continue
        }
        
        # Check if the data matches
        $isEmailMatch = $adUser.EmailAddress -eq $row.Email
        $isDepartmentMatch = $adUser.Department -eq $row.Department

        if (-not $isEmailMatch -or -not $isDepartmentMatch) {
            # Store discrepancies
            $discrepancies += [PSCustomObject]@{
                UserName = $originalUserName
                EmailDiscrepancy = $row.Email -ne $adUser.EmailAddress
                DepartmentDiscrepancy = $row.Department -ne $adUser.Department
            }
        }
    } else {
        Write-Host "User $originalUserName not found in Active Directory."
    }

    # Clear variables after each iteration
    Clear-Variable -Name originalUserName, userName, userEmail, adUsers, adUser, isEmailMatch, isDepartmentMatch -ErrorAction SilentlyContinue
}

# Display discrepancies and raise error if any
if ($discrepancies.Count -gt 0) {
    Write-Host "Discrepancies found:"
    $discrepancies | Format-Table -AutoSize
    $errorMessage = "Discrepancies found in user data. Check the console output for details."
    throw $errorMessage
} else {
    Write-Host "Finished parsing file.`nNo discrepancies found."
}
