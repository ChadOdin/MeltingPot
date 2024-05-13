function Check-Update {
    param(
        [switch]$Update
    )

    $repoUrl = "https://github.com/ChadOdin/MeltingPot.git"
    $branch = "main"
    $scriptName = $MyInvocation.MyCommand.Name
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $deprecatedDir = "$scriptDir\_.Deprecated"

    # Extract the local script version
    $scriptContent = Get-Content $MyInvocation.MyCommand.Path -Raw
    $versionRegex = [regex]::new('\bver\s+(\d+\.\d+\.\d+)\b')
    $currentVersionMatch = $versionRegex.Match($scriptContent)
    if ($currentVersionMatch.Success) {
        $currentVersion = $currentVersionMatch.Groups[1].Value
    } else {
        Write-Host "Error: Unable to determine current version."
        return
    }

    $regex = [regex]::new('\$Classification\s*=\s*["\']([^"\']+)["\']')
    $classification = $regex.Match($scriptContent).Groups[1].Value
    $repoDir = "$scriptDir\$classification"

    if ($Update) {
        try {
            # Check if the local script version matches the latest version in the repository
            $latestCommit = (git log -n 1 --pretty=format:%H --abbrev-commit)

            if ((Get-Content "$repoDir\latest_commit.txt" -ErrorAction SilentlyContinue) -eq $latestCommit) {
                Write-Host "You are already using the latest version ($currentVersion) of the script."
                return
            }

            if (-not (Test-Path $repoDir)) {
                Write-Host "Cloning repository $repoUrl to $repoDir"
                git clone $repoUrl $repoDir -Progress | Out-Null
                Log-Event -Message "Cloned repository $repoUrl to $repoDir" -Category "Update" -Level "Information"
            } else {
                Write-Host "Pulling latest changes from $repoUrl"
                cd $repoDir
                git checkout $branch
                git pull origin $branch -Progress | Out-Null
                cd ..
                Log-Event -Message "Pulled latest changes from $repoUrl" -Category "Update" -Level "Information"
            }

            $latestCommit = (git log -n 1 --pretty=format:%H --abbrev-commit)

            if ((Get-Content "$repoDir\latest_commit.txt" -ErrorAction SilentlyContinue) -ne $latestCommit) {
                Write-Host "A new update is available. Cloning the latest version from $repoUrl..."
                git clone $repoUrl $repoDir -Progress | Out-Null
                Log-Event -Message "Cloned the latest version from $repoUrl to $repoDir" -Category "Update" -Level "Information"
                Write-Host "Restarting the script with the latest version..."
                Start-Process -FilePath "$repoDir\$scriptName"
                exit
            } else {
                Write-Host "You are using the latest version ($currentVersion) of the script."
            }

            # Move older scripts to _.Deprecated directory
            if (Test-Path $deprecatedDir -PathType Container) {
                Write-Host "Moving older scripts to _.Deprecated directory"
                Get-ChildItem $scriptDir | Where-Object {($_.Name -ne "_") -and ($_.Name -ne "_.Deprecated")} | Move-Item -Destination $deprecatedDir -ErrorAction Stop
            } else {
                New-Item -Path $deprecatedDir -ItemType Directory -ErrorAction Stop
                Write-Host "Moving older scripts to _.Deprecated directory"
                Get-ChildItem $scriptDir | Where-Object {($_.Name -ne "_") -and ($_.Name -ne "_.Deprecated")} | Move-Item -Destination $deprecatedDir -ErrorAction Stop
            }
        }
        catch {
            Log-Event -Message "Error occurred: $_" -Category "Error" -Level "Error"
            Write-Host "Error: $_"
        }
    }
    else {
        Write-Host "You are using the version ($currentVersion) of the script."
    }
}

# Example usage:
Check-Update -Update