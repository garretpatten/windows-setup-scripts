# Begin: System Updates
winget upgrade -h --all
wsl
sudo apt upgrade -y && sudo apt update -y && sudo apt autoremove -y
exit

# TODO: cd to the root of the project

# Organize Directories
sh "$(pwd)/src/scripts/organizeHome.sh"

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
sh "$(pwd)/src/scripts/web.sh"

# Development Setup
sh "$(pwd)/src/scripts/dev.sh"

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
