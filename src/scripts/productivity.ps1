#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'chatgpt','notion','protondrive','zoom' | ForEach-Object { Install-Pkg $_ }

