#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = Split-Path -Parent $PSScriptRoot
. (Join-Path $Dir '../lib/Winget-Packages.ps1')

Install-WingetPackage -Id 'Git.Git'
Install-WingetPackage -Id 'Microsoft.PowerShell'
