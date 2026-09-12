#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
if (Test-Path (Join-Path $HOME '.cargo/env')) { exit 0 }
if (Get-Command rustup -ErrorAction SilentlyContinue) { exit 0 }
Install-WingetPackage -Id 'Rustlang.Rustup'
