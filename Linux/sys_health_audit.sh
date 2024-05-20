#!/bin/bash

# Function to check file integrity
check_file_integrity() {
    sudo debsums -c
}

# Main function
main() {
    echo "Starting file integrity check..."
    check_file_integrity
    echo "File integrity check completed."
}

# Run the main function
main