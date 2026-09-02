#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'chatgpt','notion','protondrive','zoom','flameshot','keepassxc','libreoffice','etcher' | ForEach-Object { Install-Pkg $_ }

