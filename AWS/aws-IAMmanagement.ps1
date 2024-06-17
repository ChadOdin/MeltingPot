Import-Module AWSPowerShell.NetCore

$region = "us-west-2"

function Create-IAMUser {
    param (
        [string]$UserName,
        [string]$FullName
    )

    Write-Host "Enter password for IAM user '$UserName':"
    $securePassword = Read-Host -AsSecureString
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

    New-IAMUser -UserName $UserName -Password $plainPassword -Region $region -UserFullName $FullName

    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
}

function Create-IAMRole {
    param (
        [string]$RoleName,
        [string]$TrustPolicy
    )

    New-IAMRole -RoleName $RoleName -AssumeRolePolicyDocument $TrustPolicy -Region $region
}

function Attach-IAMRolePolicy {
    param (
        [string]$RoleName,
        [string]$PolicyArn
    )

    Attach-IAMRolePolicy -RoleName $RoleName -PolicyArn $PolicyArn -Region $region
}

function List-IAMUsers {
    Get-IAMUser -Region $region
}

function Delete-IAMUser {
    param (
        [string]$UserName
    )

    Remove-IAMUser -UserName $UserName -Region $region
}

Create-IAMUser -UserName "newuser" -FullName "New User"

$trustPolicy = @"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
"@
Create-IAMRole -RoleName "MyEC2Role" -TrustPolicy $trustPolicy

Attach-IAMRolePolicy -RoleName "MyEC2Role" -PolicyArn "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

List-IAMUsers

#Delete-IAMUser -UserName "newuser"

Write-Host "IAM tasks completed."