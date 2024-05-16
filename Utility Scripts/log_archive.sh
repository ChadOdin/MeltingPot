#!/bin/bash

# Directory containing syslog files
SYSLOG_DIR="/var/log"

# Number of days to keep files
DAYS_TO_KEEP=7

# Archive directory
ARCHIVE_DIR="/path/to/archive"

# Function to perform file cleanup
perform_file_cleanup() {
    echo "Performing file cleanup in $SYSLOG_DIR..."
    find "$SYSLOG_DIR" -type f -name "syslog*" -mtime +$DAYS_TO_KEEP | while read file; do
        # Extract the filename and directory
        filename=$(basename "$file")
        dirname=$(dirname "$file")
        # Create tar.gz archive for each batch of files
        tar czf "$ARCHIVE_DIR/$(date +%Y-%m-%d)-$filename.tar.gz" -C "$dirname" "$filename"
        # Remove the original file
        rm "$file"
    done
    echo "File cleanup completed."
}

# Main function
main() {
    echo "Starting file cleanup..."

    # Perform file cleanup
    perform_file_cleanup

    echo "File cleanup completed."
}

# Run the main function
main