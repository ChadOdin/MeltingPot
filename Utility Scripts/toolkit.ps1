function Read-ExchangeFile {
    param (
        [string]$exchangeFilePath
    )

    if (Test-Path $exchangeFilePath) {
        Get-Content $exchangeFilePath
    } else {
        Write-Host "Exchange file not found."
    }
}

function Show-Menu {
    param (
        [string]$currentDirectory,
        [string]$currentPath = ""
    )

    Clear-Host
    Write-Host "====================================="
    Write-Host " PowerShell Toolkit Menu"
    Write-Host "====================================="

    $global:menuOptions = @{} 
    $index = 1

    function Add-MenuOption {
        param (
            [string]$displayName,
            [string]$fullPath
        )

        Write-Host "$index. $displayName"
        $menuOptions.Add($index, $fullPath)
        $index++
    }

    $directories = Get-ChildItem -Path $currentDirectory -Directory
    foreach ($dir in $directories) {
        Add-MenuOption -displayName $dir.Name -fullPath $dir.FullName
    }

    $files = Get-ChildItem -Path $currentDirectory -File | Where-Object {$_.Extension -eq ".ps1"}
    foreach ($file in $files) {
        Add-MenuOption -displayName $file.Name -fullPath $file.FullName
    }

    Write-Host "$index. Exit"
    $menuOptions.Add($index, "Exit")
}

function Process-Selection {
    param (
        [string]$selection
    )

    if ($selection -eq "Exit") {
        Write-Host "Exiting..."
        exit
    } elseif (Test-Path -Path $selection -PathType Container) {
        Show-Menu -currentDirectory $selection
    } elseif (Test-Path -Path $selection -PathType Leaf) {
        $extension = (Get-Item $selection).Extension.ToLower()

        if ($extension -eq ".ps1") {
            Write-Host "Running $selection..."
            & $selection
            Pause
        } else {
            Write-Host "Unsupported file type"
            Pause
        }
    } else {
        Write-Host "Invalid selection"
        Pause
    }
}

$rootDirectory = "C:\Path\To\Your\Scripts"  
$currentDirectory = $rootDirectory

while ($true) {
    Show-Menu -currentDirectory $currentDirectory
    $choice = Read-Host "Enter your choice (1-$($menuOptions.Count))"

    if ($menuOptions.ContainsKey($choice)) {
        Process-Selection -selection $menuOptions[$choice]
    } else {
        Write-Host "Invalid choice, please enter a number between 1 and $($menuOptions.Count)."
        Pause
    }
}