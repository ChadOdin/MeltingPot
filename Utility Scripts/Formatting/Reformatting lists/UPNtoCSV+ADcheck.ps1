$inputFileName = Read-Host "Enter the name of the input file containing the list of users (including extension)"
$inputFilePath = [Environment]::GetFolderPath("Downloads") + "\" + $inputFileName
$outputFilePath = [Environment]::GetFolderPath("Downloads") + "\outfile.csv"

$userList = Get-Content "$inputFilePath"

$formattedUsers = foreach ($user in $userList) {
    [PSCustomObject]@{
        UPN = $user
    }
}

$formattedUsers | Export-Csv -Path "$outputFilePath" -NoTypeInformation -Force
Write-Host "CSV file created at $outputFilePath"

Import-Module ActiveDirectory

$csvPath = [Environment]::GetFolderPath("Downloads") + "\outfile.csv"

$upns = Import-Csv -Path "$csvPath"

foreach ($upn in $upns) {
    $username = $upn.UPN
    $user = Get-ADUser -Filter {UserPrincipalName -eq $username} -Properties Enabled

    if ($user) {
        if ($user.Enabled -eq $false -or $user.SamAccountName -like "dis_*") {
            Write-Host "$username - User exists but is disabled or has 'dis_' in the username" -ForegroundColor Yellow
        }
        else {
            Write-Host "$username - User exists and is enabled" -ForegroundColor Green
        }
    }
    else {
        Write-Host "$username - User does not exist" -ForegroundColor Red
    }
}