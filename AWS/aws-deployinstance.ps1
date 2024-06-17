# Import the necessary module
Import-Module AWSPowerShell.NetCore

# Set variables for the instance configuration
$instanceType = "t2.micro" # change according to documentation
$goldImageId = "ami-0abcd1234efgh5678"  # gold image AMI ID, only a placeholder
$keyName = "YourKeyPairName" # replace with your key
$securityGroupId = "sg-0a1b2c3d4e5f6g7h8"  # change as needed, this is a placeholder
$vpcId = "vpc-0a1b2c3d4e5f6g7h8"  # change as needed, this is a placeholder
$securityGroupName = "MySecurityGroup"

function Get-OrCreateSecurityGroup {
    param (
        [string]$groupName,
        [string]$description,
        [string]$vpcId
    )
    
    $existingGroup = Get-EC2SecurityGroup -GroupNames $groupName -ErrorAction SilentlyContinue
    
    if ($existingGroup) {
        Write-Host "Security group '$groupName' already exists."
        return $existingGroup.GroupId
    } else {

        $securityGroup = New-EC2SecurityGroup -GroupName $groupName -Description $description -VpcId $vpcId

        # allow traffic on port 22 and port 80
        $ipPermissions = @(
            @{ IpProtocol="tcp"; FromPort=22; ToPort=22; IpRanges="0.0.0.0/0" },
            @{ IpProtocol="tcp"; FromPort=80; ToPort=80; IpRanges="0.0.0.0/0" }
        )

        Grant-EC2SecurityGroupIngress -GroupId $securityGroup.GroupId -IpPermissions $ipPermissions

        Write-Host "Created security group '$groupName'."
        return $securityGroup.GroupId
    }
}

# deploy EC2 using gold image
function Deploy-Instance {
    param (
        [string]$instanceType,
        [string]$imageId,
        [string]$keyName,
        [string]$securityGroupId
    )

    $instance = New-EC2Instance -ImageId $imageId -InstanceType $instanceType -KeyName $keyName -SecurityGroupId $securityGroupId -MinCount 1 -MaxCount 1

    return $instance.Instances[0]
}

function Wait-ForInstance {
    param (
        [string]$instanceId,
        [int]$timeoutMinutes = 10
    )

    $startTime = Get-Date
    $timeout = $startTime.AddMinutes($timeoutMinutes)

    do {
        $status = (Get-EC2InstanceStatus -InstanceId $instanceId).InstanceState.Name
        Write-Host "Instance $instanceId status: $status"

        if ($status -eq "running") {
            Write-Host "Instance $instanceId is now running."
            return $true
        }

        Start-Sleep -Seconds 30
    } while ((Get-Date) -lt $timeout)

    Write-Host "Instance $instanceId did not reach 'running' state within the timeout period."
    return $false
}

$securityGroupId = Get-OrCreateSecurityGroup -groupName $securityGroupName -description "My security group description" -vpcId $vpcId

$instance = Deploy-Instance -instanceType $instanceType -imageId $goldImageId -keyName $keyName -securityGroupId $securityGroupId

$instanceId = $instance.InstanceId
$instanceRunning = Wait-ForInstance -instanceId $instanceId -timeoutMinutes 10

# verify's if instance is running after 10 minutes
if ($instanceRunning) {
    Write-Host "Instance $instanceId is successfully deployed and running."
    Get-EC2Instance -InstanceId $instanceId
} else {
    Write-Host "Failed to verify that instance $instanceId is running."
}
