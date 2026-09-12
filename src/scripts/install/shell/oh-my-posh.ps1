#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) { exit 0 }
Install-WingetPackage -Id 'JanDeDobbeleer.OhMyPosh'
