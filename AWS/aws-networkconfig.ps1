Import-Module AWSPowerShell.NetCore

$region = "us-west-2"

function Create-VPC {
    param (
        [string]$VpcName,
        [string]$CidrBlock
    )

    $vpc = New-VPC -CidrBlock $CidrBlock -Region $region -VpcName $VpcName
    $vpcId = $vpc.VpcId
    return $vpcId
}

function Create-Subnet {
    param (
        [string]$SubnetName,
        [string]$CidrBlock,
        [string]$VpcId
    )

    $subnet = New-Subnet -CidrBlock $CidrBlock -VpcId $VpcId -Region $region -SubnetName $SubnetName
    $subnetId = $subnet.SubnetId
    return $subnetId
}

function Create-InternetGateway {
    param (
        [string]$VpcId
    )

    $igw = New-InternetGateway -Region $region
    $igwId = $igw.InternetGatewayId
    Register-InternetGateway -InternetGatewayId $igwId -VpcId $VpcId -Region $region
}

function Create-RouteTable {
    param (
        [string]$RouteTableName,
        [string]$VpcId,
        [string]$SubnetId
    )

    $rt = New-RouteTable -Region $region -VpcId $VpcId -RouteTableName $RouteTableName
    $rtId = $rt.RouteTableId
    Associate-RouteTable -RouteTableId $rtId -SubnetId $SubnetId -Region $region
}

function Create-SecurityGroup {
    param (
        [string]$SecurityGroupName,
        [string]$Description,
        [string]$VpcId
    )

    $sg = New-SecurityGroup -GroupName $SecurityGroupName -Description $Description -VpcId $VpcId -Region $region
    $sgId = $sg.GroupId

    Authorize-SecurityGroupIngress -GroupId $sgId -IpProtocol tcp -FromPort 22 -ToPort 22 -CidrIp "0.0.0.0/0"
    Authorize-SecurityGroupIngress -GroupId $sgId -IpProtocol tcp -FromPort 80 -ToPort 80 -CidrIp "0.0.0.0/0"
}

$vpcId = Create-VPC -VpcName "MyVPC" -CidrBlock "10.0.0.0/16"

$subnet1Id = Create-Subnet -SubnetName "PublicSubnet1" -CidrBlock "10.0.1.0/24" -VpcId $vpcId
$subnet2Id = Create-Subnet -SubnetName "PrivateSubnet1" -CidrBlock "10.0.2.0/24" -VpcId $vpcId

Create-InternetGateway -VpcId $vpcId

Create-RouteTable -RouteTableName "PublicRouteTable" -VpcId $vpcId -SubnetId $subnet1Id
Create-RouteTable -RouteTableName "PrivateRouteTable" -VpcId $vpcId -SubnetId $subnet2Id

Create-SecurityGroup -SecurityGroupName "WebServerSG" -Description "Security Group for Web Servers" -VpcId $vpcId

Write-Host "Network configuration setup completed."