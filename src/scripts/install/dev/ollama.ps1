#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
if (Get-Command ollama -ErrorAction SilentlyContinue) { exit 0 }
Install-WingetPackage -Id 'Ollama.Ollama'
