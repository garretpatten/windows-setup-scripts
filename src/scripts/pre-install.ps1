# Allow script execution
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Update system
winget upgrade -h --all
