# Read the CSV file
$data = Import-Csv -Path "input.csv"

# Define the domain
$domain = "domainhere"

# Initialize an array to store the results
$output = @()

# Iterate through each row of the CSV
foreach ($entry in $data) {
    # Extract the display name
    $displayName = $entry."UPN"
    
    # Replace spaces with dots in the display name
    $displayName = $displayName -replace '\s+', '.'
    
    # Split the display name into first and last names
    $nameParts = $displayName -split '\.', 3
    $firstName = $nameParts[0]
    if ($nameParts.Count -gt 1) {
        $lastName = $nameParts[1]
    } else {
        $lastName = ""
    }

    # Ensure the first name is not empty
    if (-not [string]::IsNullOrWhiteSpace($firstName)) {
        # Construct the email address
        $email = "$firstName.$lastName@$domain"
        # Remove dot after last name
        $email = $email -replace '\.+$', ''
        
        Write-Host "Constructed email: $email"
        
        # Add the email address to the output array
        $outputEntry = [PSCustomObject]@{
            "Email" = $email
        }
        $output += $outputEntry
    }
    else {
        Write-Host "Skipping entry due to empty or whitespace first name."
    }
}

# Export the results to a new CSV file
$output | Export-Csv -Path "Output.csv" -NoTypeInformation
