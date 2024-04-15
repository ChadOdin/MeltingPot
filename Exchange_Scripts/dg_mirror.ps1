# Prompt for the source and target distribution group names
$sourceGroupName = Read-Host "Enter the source distribution group name"
$targetGroupName = Read-Host "Enter the target distribution group name"

# Try to get the list of members from the source distribution group
try {
    $members = Get-DistributionGroupMember -Identity $sourceGroupName -ErrorAction Stop | Select-Object -ExpandProperty PrimarySmtpAddress

    # Add each member to the target distribution group
    foreach ($member in $members) {
        try {
            Add-DistributionGroupMember -Identity $targetGroupName -Member $member -ErrorAction Stop
            Write-Host "Member $member added to the target distribution group successfully."
        } catch {
            Write-Host "Failed to add member $member to the target distribution group: $_"
        }
    }

    Write-Host "Members mirrored from the source distribution group to the target distribution group successfully."
} catch {
    Write-Host "Failed to retrieve members from the source distribution group: $_"
}
