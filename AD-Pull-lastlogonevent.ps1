# Specify the username
$username = "username"

# Get the user's AD properties
$user = Get-AdUser -Identity $username -Properties LastLogon, LastLoggedOnSamServer

# Convert last logon time to yyyy/mm/dd HH:mm:ss:ms format
$lastLogonTime = [System.DateTime]::FromFileTime($user.LastLogon).ToString("yyyy/MM/dd HH:mm:ss:ff")

# Get the last device logged into
$lastDevice = $user.LastLoggedOnSamServer

# Display results
Write-Host "Last Logon Time: $lastLogonTime"
Write-Host "Last Device Logged Into: $lastDevice"
