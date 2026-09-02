#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# CLI
'exiftool','nmap','onepassword_cli','openvpn' | ForEach-Object { Install-Pkg $_ }

# GUI
'onepassword','burp','zap','protonvpn','protonpass','signal' | ForEach-Object { Install-Pkg $_ }

