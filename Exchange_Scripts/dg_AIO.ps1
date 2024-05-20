function Remove-SingleUserFromGroup {
    $upn = Read-Host "Enter user's UPN"
    $group = Read-Host "Enter distribution group name"

    try {
        Remove-DistributionGroupMember -Identity $group -Member $upn -Confirm:$false -ErrorAction Stop
        Write-Host "User $upn removed from distribution group $group successfully"
    } catch {
        Write-Host "Error occurred while removing user from distribution group: $_"
    }
}

function Remove-UsersFromCsvFromGroup {
    $filePath = Read-Host "Enter file path"

    if (-not (Test-Path $filePath)) {
        Write-Host "File not found at $filePath"
        return
    }

    $users = Import-Csv $filePath

    foreach ($user in $users) {
        $upn = $user.UPN
        $group = Read-Host "Enter distribution group name"

        try {
            Remove-DistributionGroupMember -Identity $group -Member $upn -Confirm:$false -ErrorAction Stop
            Write-Host "User with UPN $upn removed from distribution group $group"
        } catch {
            Write-Host "Error occurred while removing user with UPN $upn from distribution group: $_"
        }
    }
}

function Manage-Users {
    Write-Host "Welcome to User Management Menu"
    $choice = Read-Host "Do you want to add (1) or remove (2) users from a distribution group?"

    switch ($choice) {
        "1" { 
            $folderPath = Read-Host "Enter folder path to scan for CSV files (Documents/Downloads)"
            if ($folderPath -eq "Documents") {
                $documentsPath = [Environment]::GetFolderPath("MyDocuments")
                Write-Host "Scanning Documents folder for CSV files..."
                Get-CSVFiles -folderPath $documentsPath
            } elseif ($folderPath -eq "Downloads") {
                $downloadsPath = [Environment]::GetFolderPath("MyDocuments")
                Write-Host "Scanning Downloads folder for CSV files..."
                Get-CSVFiles -folderPath $downloadsPath
            } else {
                Write-Host "Invalid folder path"
                return
            }
            Add-UsersFromCsvToGroup
        }
        "2" { 
            $folderPath = Read-Host "Enter folder path to scan for CSV files (Documents/Downloads)"
            if ($folderPath -eq "Documents") {
                $documentsPath = [Environment]::GetFolderPath("MyDocuments")
                Write-Host "Scanning Documents folder for CSV files..."
                Get-CSVFiles -folderPath $documentsPath
            } elseif ($folderPath -eq "Downloads") {
                $downloadsPath = [Environment]::GetFolderPath("MyDocuments")
                Write-Host "Scanning Downloads folder for CSV files..."
                Get-CSVFiles -folderPath $downloadsPath
            } else {
                Write-Host "Invalid folder path"
                return
            }
            Remove-UsersFromCsvFromGroup
        }
        default { Write-Host "Invalid choice" }
    }
}

Manage-Users