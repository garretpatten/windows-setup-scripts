# Install CLI tools on Windows Subsystem for Linux
wsl "if [[ ! -f '/usr/bin/batcat' ]]; then sudo apt install batcat; fi"
wsl "if [[ ! -f '/usr/bin/curl' ]]; then sudo apt install curl; fi"
wsl "if [[ ! -f '/usr/bin/exa' ]]; then sudo apt install exa; fi"
wsl "if [[ ! -f '/usr/bin/git' ]]; then sudo apt install git; fi"
wsl "if [[ ! -f '/usr/bin/htop' ]]; then sudo apt install htop; fi"
wsl "if [[ ! -f '/usr/bin/neofetch' ]]; then sudo apt install neofetch; fi"
wsl "if [[ ! -f '/usr/sbin/openvpn' ]]; then sudo apt install openvpn; fi"
wsl "if [[ ! -f '/usr/bin/wget' ]]; then sudo apt install wget; fi"

cliTools=("poppler-utils")
