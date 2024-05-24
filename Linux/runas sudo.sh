#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with superuser privileges. Running with sudo..."
    sudo "$0" "$@"
    exit $?
fi