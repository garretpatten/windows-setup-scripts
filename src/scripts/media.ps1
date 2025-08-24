#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'spotify','vlc' | ForEach-Object { Install-Pkg $_ }

