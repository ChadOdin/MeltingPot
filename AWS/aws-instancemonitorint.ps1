Import-Module AWSPowerShell.NetCore

$region = "us-east-1"
Set-DefaultAWSRegion -Region $region

function New-CloudWatchAlarm {
    param (
        [string]$AlarmName,
        [string]$MetricName,
        [string]$Namespace,
        [string]$Statistic,
        [string]$ComparisonOperator,
        [double]$Threshold,
        [int]$Period,
        [int]$EvaluationPeriods,
        [string]$AlarmActions
    )

    try {
        Write-Host "Creating CloudWatch alarm: $AlarmName..."
        New-CWAlarm -AlarmName $AlarmName `
                    -MetricName $MetricName `
                    -Namespace $Namespace `
                    -Statistic $Statistic `
                    -ComparisonOperator $ComparisonOperator `
                    -Threshold $Threshold `
                    -Period $Period `
                    -EvaluationPeriods $EvaluationPeriods `
                    -AlarmActions $AlarmActions

        Write-Host "CloudWatch alarm $AlarmName created successfully."
    } catch {
        Write-Error "Error creating CloudWatch alarm $AlarmName: $_"
    }
}

function New-CloudWatchDashboard {
    param (
        [string]$DashboardName,
        [string]$DashboardBody
    )

    try {
        Write-Host "Creating CloudWatch dashboard: $DashboardName..."
        Write-CWDashboard -DashboardName $DashboardName -DashboardBody $DashboardBody

        Write-Host "CloudWatch dashboard $DashboardName created successfully."
    } catch {
        Write-Error "Error creating CloudWatch dashboard $DashboardName: $_"
    }
}

function New-SNSTopic {
    param (
        [string]$TopicName,
        [string]$Protocol,
        [string]$Endpoint
    )

    try {
        Write-Host "Creating SNS topic: $TopicName..."
        $topic = New-SNSTopic -Name $TopicName
        $topicArn = $topic.TopicArn

        Write-Host "Creating SNS subscription for topic $TopicName..."
        New-SNSSubscription -TopicArn $topicArn -Protocol $Protocol -Endpoint $Endpoint

        Write-Host "SNS topic $TopicName created and subscription added successfully."
    } catch {
        Write-Error "Error creating SNS topic $TopicName: $_"
    }
}

function Restart-EC2Instance {
    param (
        [string]$InstanceId
    )

    try {
        Write-Host "Restarting EC2 instance: $InstanceId..."
        Restart-EC2Instance -InstanceId $InstanceId

        Write-Host "EC2 instance $InstanceId restarted successfully."
    } catch {
        Write-Error "Error restarting EC2 instance $InstanceId: $_"
    }
}

function New-CloudWatchLog {
    param (
        [string]$LogGroupName,
        [string]$LogStreamName,
        [string]$LogMessage
    )

    try {
        Write-Host "Creating CloudWatch log group: $LogGroupName..."
        New-CWLLogGroup -LogGroupName $LogGroupName

        Write-Host "Creating CloudWatch log stream: $LogStreamName..."
        New-CWLLogStream -LogGroupName $LogGroupName -LogStreamName $LogStreamName

        Write-Host "Putting log event to CloudWatch log stream: $LogStreamName..."
        $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        Write-CWLLogEvent -LogGroupName $LogGroupName -LogStreamName $LogStreamName -Timestamp $timestamp -Message $LogMessage

        Write-Host "Log event added to CloudWatch log stream $LogStreamName successfully."
    } catch {
        Write-Error "Error creating CloudWatch log or adding log event: $_"
    }
}

$instanceId = "i-"
$alarmName = "HighCPUUtilization"
$snsTopicName = "MySNSTopic"
$email = ""
$dashboardName = "MyDashboard"
$logGroupName = "MyLogGroup"
$logStreamName = "MyLogStream"

$topic = New-SNSTopic -TopicName $snsTopicName -Protocol "email" -Endpoint $email
$snsTopicArn = $topic.TopicArn

New-CloudWatchAlarm -AlarmName $alarmName `
                    -MetricName "CPUUtilization" `
                    -Namespace "AWS/EC2" `
                    -Statistic "Average" `
                    -ComparisonOperator "GreaterThanThreshold" `
                    -Threshold 80 `
                    -Period 300 `
                    -EvaluationPeriods 2 `
                    -AlarmActions $snsTopicArn

$widget = @{
    "type" = "metric"
    "x" = 0
    "y" = 0
    "width" = 6
    "height" = 6
    "properties" = @{
        "metrics" = @(
            @("AWS/EC2", "CPUUtilization", "InstanceId", $instanceId)
        )
        "period" = 300
        "stat" = "Average"
        "region" = $region
        "title" = "EC2 CPU Utilization"
    }
}
$dashboardBody = @{
    "widgets" = @($widget)
} | ConvertTo-Json -Compress

New-CloudWatchDashboard -DashboardName $dashboardName -DashboardBody $dashboardBody

$logMessage = "Monitoring and alerting setup completed successfully."
New-CloudWatchLog -LogGroupName $logGroupName -LogStreamName $logStreamName -LogMessage $logMessage

Restart-EC2Instance -InstanceId $instanceId

Write-Host "Monitoring and alerting setup completed."