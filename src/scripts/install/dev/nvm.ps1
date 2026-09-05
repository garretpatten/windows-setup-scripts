#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
if (Test-Path (Join-Path $env:APPDATA 'nvm')) { exit 0 }
Install-WingetPackage -Id 'CoreyButler.NVMforWindows'
