# Ensure the execution policy allows script running
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Begin: System Updates
winget upgrade -h --all
wsl "sudo apt upgrade -y && sudo apt update -y && sudo apt autoremove -y"

# Organize Directories
.\organizeHome.ps1

# Security: YubiKeys, Firewall, VPN, Anti-Virus
sh "$(pwd)/src/scripts/security.sh"

# CLI Tooling
sh "$(pwd)/src/scripts/cli.sh"

# TODO: Rename or break up this script
# Flatpak Apps
sh "$(pwd)/src/scripts/flatpak.sh"

# Productivity: Taskwarrior, Todoist
sh "$(pwd)/src/scripts/productivity.sh"

# Web Apps
.\web.ps1

# Development Setup
.\dev.ps1

# Shell: Terminator, zsh, oh-my-zsh
sh "$(pwd)/src/scripts/shell.sh"

# Other: Thunderbird
sh "$(pwd)/src/scripts/misc.sh"

# Add Taskwarrior tasks
sh "$(pwd)/src/scripts/addTasks.sh"

# End: System Updates
winget upgrade -h --all
wsl
sudo apt upgrade -y && sudo apt update-y && sudo apt autoremove -y
exit

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
