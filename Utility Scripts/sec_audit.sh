#!/bin/bash

check_open_ports() {
    sudo netstat -tuln
}

list_outdated_packages() {
    sudo apt update &>/dev/null
    outdated_packages=$(apt list --upgradable 2>/dev/null)
    echo "$outdated_packages"
}

main() {
    echo "Starting security audit..."

    check_open_ports

    echo ""

    list_outdated_packages

    echo "Security audit completed."
}

main