# Postman
winget install -e --id Postman.Postman --source winget

# Oracle VirtualBox
winget install -e --id=Oracle.VirtualBox --source winget

# VS Code
winget install --id Microsoft.VisualStudioCode -e --source winget
Copy-Item ..\dotfiles\vs-code\settings.json $env:USERPROFILE\AppData\Roaming\Code\User\settings.json
