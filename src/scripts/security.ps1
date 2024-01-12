# TODO: Setup hardware keys

# TODO: Ensure Windows firewall is installed

# Install 1Password
winget install -e --id AgileBits.1Password

# Install Proton VPN
winget install -e --id ProtonTechnologies.ProtonVPN

# TODO: Ensure Windows Anti Virus is configured

# Install nmap
wsl "if [[ -f '/usr/bin/nmap' ]]; then echo 'nmap is already installed.'; else sudo apt install nmap -y; fi"
