Import-Module AWSPowerShell.NetCore

$region = "us-east-1"
Set-DefaultAWSRegion -Region $region

function Backup-EC2Instance {
    param (
        [string]$InstanceId
    )

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $amiName = "Backup-$timestamp"

    try {
        Write-Host "Creating AMI backup for instance $InstanceId..."
        $ami = New-EC2Image -InstanceId $InstanceId -Name $amiName -NoReboot

        Write-Host "AMI backup created with ID: $($ami.ImageId)"
    }
    catch {
        Write-Error "Error creating AMI backup for instance $InstanceId: $_"
    }
}

function Backup-EBSVolume {
    param (
        [string]$VolumeId
    )

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $description = "Backup-$timestamp"

    try {
        Write-Host "Creating snapshot backup for volume $VolumeId..."
        $snapshot = New-EC2Snapshot -VolumeId $VolumeId -Description $description

        Write-Host "Snapshot backup created with ID: $($snapshot.SnapshotId)"
    }
    catch {
        Write-Error "Error creating snapshot backup for volume $VolumeId: $_"
    }
}

function Restore-EC2Instance {
    param (
        [string]$InstanceId,
        [string]$ImageId
    )

    try {
        Write-Host "Restoring instance $InstanceId from AMI $ImageId..."
        Restore-EC2Instance -InstanceId $InstanceId -ImageId $ImageId
        Write-Host "Instance $InstanceId restored from AMI $ImageId"
    }
    catch {
        Write-Error "Error restoring instance $InstanceId from AMI $ImageId: $_"
    }
}

function Restore-EBSVolume {
    param (
        [string]$VolumeId,
        [string]$SnapshotId
    )

    try {
        Write-Host "Restoring volume $VolumeId from snapshot $SnapshotId..."
        Restore-EC2Snapshot -VolumeId $VolumeId -SnapshotId $SnapshotId
        Write-Host "Volume $VolumeId restored from snapshot $SnapshotId"
    }
    catch {
        Write-Error "Error restoring volume $VolumeId from snapshot $SnapshotId: $_"
    }
}


# EC2 instance
$exampleInstanceId = "i-"
Backup-EC2Instance -InstanceId $exampleInstanceId

# EBS volume
$exampleVolumeId = "vol-"
Backup-EBSVolume -VolumeId $exampleVolumeId

# EC2 instance from AMI
$restoreInstanceId = "i-"
$restoreImageId = "ami-"
Restore-EC2Instance -InstanceId $restoreInstanceId -ImageId $restoreImageId

# EBS volume from snapshot
$restoreVolumeId = "vol-"
$restoreSnapshotId = "snap-"
Restore-EBSVolume -VolumeId $restoreVolumeId -SnapshotId $restoreSnapshotId
