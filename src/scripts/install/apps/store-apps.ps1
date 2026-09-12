#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
$file = Join-Path $PSScriptRoot '../store-apps.txt'
Install-WingetPackagesFromFile -PackagesFile $file
