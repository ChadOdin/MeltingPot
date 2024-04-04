# domain join script with endpoint (wazuh)

$domain = "Test.Domain"
$username = Read-Host "Enter UPN"
$password = Read-Host "Enter Password" -AsSecureString
$creds = New-Object System.Management.Automation.PSCredential($usernam, $password)

Add-computer -DomainName $domain -Credential $creds -Restart

# Wazuh endpoint installation script

$manangerIP = 172.30.100.88


Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.2.5-1.msi" -Outfile "C:\Temp\wazuh-agnet-4.2.5-1.msi"

Start-Process  -FilePath "msiexec.msi" -ArgumentList "/i C:\Temp\wazuh-agent-4.2.5-1.msi /qn MANAGER_IP=172.30.100.88" -Wait

Start-Service -Name "Wazuh"

Set-Service -Name "Wazuh" -StartupType Automatic
