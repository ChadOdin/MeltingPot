#!/bin/bash

# Function to perform system update
perform_system_update() {
    echo "Performing system update..."
    sudo apt update
    sudo apt list --upgradable
    sudo apt upgrade -y
    sudo apt autoremove --purge -y
    echo "System update completed."
}

# Main function
main() {
    echo "Starting automated system update..."

    # Perform system update
    perform_system_update

    echo "Automated system update completed."
}

# Run the main function
main