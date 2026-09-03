#Requires -Version 7
. "$PSScriptRoot/utils.ps1"
'brave','chrome','ddg','bruno' | ForEach-Object { Install-Pkg $_ }

