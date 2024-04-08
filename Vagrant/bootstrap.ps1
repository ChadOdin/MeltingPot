# check if restart is pending
 if (Test-PendingRestart) {
    write-host "Restarting computer. `nPlease wait...."
    Restart-Computer -Wait
}

Write-Host "Initial Setup Starting. `nPlease Wait...."

# Declaring services to check
$adDsFeatureInstalled = Get-WindowsFeature -Name AD-Domain-Services | Where-Object { $_.Installed }
$dnsFeatureInstalled = Get-WindowsFeature -Name DNS | Where-Object { $_.Installed }
$rdpFeatureInstalled = Get-WindowsFeature -Name RDS-RDS-Role-infrastructure | Where-Object { $_.Installed }
$DhcpFeatureInstalled = Get-WindowsFeature -Name DHCPServer | Where-Object { $_.Installed }

# Do checks for various Services
if (-not $adDsFeatureInstalled) {
    Write-Host "AD DS Feature not installed! `nInstalling...."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
}

if (-not $dnsFeatureInstalled) {
    Write-Host "AD DS Feature not running! `nStarting Service...."
    Start-Service -Name DNS
}

if (-not $DhcpFeatureInstalled) {
    Write-Host "DHCP Server not running! `nInstalling Service...."
    Install-WindowsFeature DHCPServer
}

if (-not $rdpFeatureInstalled) {
    Write-Host "RDP Feature Not Installed! `nInstalling...."
    Install-WindowsFeature -Name RDS-RDS-Role-infrastructure -IncludeManagementTools
}

# Check AD DS Service
$adDsServiceRunning = Get-Service -Name NTDS | Where-Object { $_.Status -eq 'Running' }

if (-not $adDsServiceRunning) {
    Write-Host "AD DS Service not running! `nStarting Service...."
    Start-Service -Name NTDS
}

# Enabling RDP to VM and changing Firewall Rules
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

New-FirewallRule -Name "Remote Desktop" -DisplayName "Remote Desktop" -Protocol TCP -LocalPort 3389 -Action Allow

Restart-Service -Name TermService -Force

# Promt User Input for Domain Config
$domainName = Read-Host "Enter Desired Domain Name:"
$netBiosName = Read-Host "Enter Desired NetBIOS Domain Name"

# Start Domain Config
Install-ADDSForest -DomainName $domainName -DominNetbiosName $netBiosName -ForestMode "WinThreshold" -DomainMode "WinThreshold" -InstallDns:$true -NoRebootOnCompletion:$false -LogPath 'C:\%SystemRoot\NTDS' 
