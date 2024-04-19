# Read the CSV file
$data = Import-Csv -Path "C:\users\169598\Downloads\CHDistroCreegan-CSV.csv"

# Define the domain
$domain = "placesforpeople.co.uk"

# Initialize an array to store the results
$output = @()

# Iterate through each row of the CSV
foreach ($entry in $data) {
    # Extract first and last names
    $firstName = $entry."First Name"
    $lastName = $entry."Last Name"
    
    # Construct the email address
    $email = "$firstName.$lastName@$domain"
    
    # Create a new object with the email address
    $result = New-Object PSObject -Property @{
        Email = $email
    }
    
    # Add the result to the output array
    $output += $result
}

# Export the results to a new CSV file
$output | Export-Csv -Path "C:\users\169598\Downloads\Output.csv" -NoTypeInformation
