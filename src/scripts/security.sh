#!/bin/bash

# TODO: Setup hardware keys

# TODO: Ensure Windows firewall is installed
## TODO: Install 1Password

# TODO: Install Proton VPN

# TODO: Ensure Windows Anti Virus is configured

# Install nmap
if [[ -f "/usr/bin/nmap" ]]; then
    echo "nmap is already installed."
else
    sudo apt install nmap -y
fi
