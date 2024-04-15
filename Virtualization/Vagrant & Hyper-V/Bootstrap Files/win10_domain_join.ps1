# domain join script with endpoint (wazuh)

$domain = Read-Host "Enter Domain Name (After DC is created)"
$username = Read-Host "Enter UPN"
$password = Read-Host "Enter Password" -AsSecureString
$creds = New-Object System.Management.Automation.PSCredential($username, $password)

Add-computer -DomainName $domain -Credential $creds -Restart

# Wazuh endpoint installation script

$managerIP = "172.30.100.88"


Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.2.5-1.msi" -Outfile "C:\Temp\wazuh-agnet-4.2.5-1.msi"

Start-Process  -FilePath "msiexec.msi" -ArgumentList "/i C:\Temp\wazuh-agent-4.2.5-1.msi /qn MANAGER_IP=$managerIP" -Wait

Start-Service -Name "Wazuh"

Set-Service -Name "Wazuh" -StartupType Automatic
