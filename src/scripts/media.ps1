#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'spotify','vlc','ffmpeg' | ForEach-Object { Install-Pkg $_ }

