#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'brave','ddg','bruno' | ForEach-Object { Install-Pkg $_ }

