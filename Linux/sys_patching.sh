#!/bin/bash

# Email notification settings
EMAIL_TO="first.last@domain"
EMAIL_SUBJECT="System Update Report"

perform_dry_run() {
    echo "Performing dry run..."
    sudo apt upgrade --dry-run > /tmp/system_update_dry_run.log
    # Check for errors in the dry run output
    if grep -q 'ERROR' /tmp/system_update_dry_run.log; then
        echo "Dry run completed with errors. No updates installed."
        return 1
    else
        echo "Dry run completed successfully."
        return 0
    fi
}

perform_system_update() {
    echo "Performing system update..."
    # Start time
    start_time=$(date +%s.%N)
    # Perform system update
    sudo apt upgrade -y >/tmp/system_update_install.log 2>&1
    # End time
    end_time=$(date +%s.%N)
    # Calculate install duration
    duration=$(echo "$end_time - $start_time" | bc)
    echo "System update completed in $duration seconds."
}

send_email_notification() {
    echo "Sending email notification..."
    cat /var/log/system_update.log | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO"
    echo "Email notification sent."
}

log_system_update() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): System update completed." >> /var/log/system_update.log
    echo "Install speeds:" >> /var/log/system_update.log
    grep '^[0-9]\+\.[0-9]\+kB' /tmp/system_update_install.log >> /var/log/system_update.log
}

main() {
    echo "Starting automated system update..."

    # Perform dry run
    perform_dry_run
    DRY_RUN_RESULT=$?

    if [ $DRY_RUN_RESULT -eq 0 ]; then
        # Perform system update
        perform_system_update

        # Send email notification
        send_email_notification

        # Log system update
        log_system_update

        echo "Automated system update completed."
    fi
}

main