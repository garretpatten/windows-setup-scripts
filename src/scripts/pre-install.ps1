# Allow script execution
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Update system
winget upgrade -h --all
wsl "sudo apt upgrade -y && sudo apt update-y && sudo apt autoremove -y"
