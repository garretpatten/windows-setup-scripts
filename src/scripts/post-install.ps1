# Update system
winget upgrade -h --all
wsl "sudo apt upgrade -y && sudo apt update -y && sudo apt autoremove -y"

# End message
Write-Output "\n\n\nCheers -- system setup is now complete!"
