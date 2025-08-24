#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'brave','ddg' | ForEach-Object { Install-Pkg $_ }

