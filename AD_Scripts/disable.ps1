function Generate-RandomPassword {
    $specialCharacters = '!@#$%^&*()_-+={}[]\|;:,.<>?'
    $password = ''
    $passwordLength = Get-Random -Minimum 32 -Maximum 64

    for ($i = 0; $i -lt $passwordLength; $i++) {
        $characterType = Get-Random -Minimum 1 -Maximum 4

        switch ($characterType) {
            1 { $password += [char](Get-Random -Minimum 65 -Maximum 91) }
            2 { $password += [char](Get-Random -Minimum 97 -Maximum 123) }
            3 { $password += [char](Get-Random -Minimum 48 -Maximum 58) }
            4 { $password += $specialCharacters[(Get-Random -Minimum 0 -Maximum $specialCharacters.Length)] }
        }
    }

    return $password
}

function Change-PasswordAndDisableAccount {
    param (
        [string]$netlogon
    )

    $newPassword = Generate-RandomPassword
    $secureNewPassword = ConvertTo-SecureString -String $newPassword -AsPlainText -Force

    try {
        Set-ADAccountPassword -Identity $netlogon -NewPassword $secureNewPassword -Reset -PassThru | Out-Null
        Disable-ADAccount -Identity $netlogon
        Write-Host "Password changed and account disabled for user with netlogon name $netlogon"
    } catch {
        Write-Host "Error occurred while changing password and disabling account for user with netlogon name $netlogon: $_"
    }
}

$netlogon = Read-Host "Enter netlogon name of the user"

Change-PasswordAndDisableAccount -netlogon $netlogon