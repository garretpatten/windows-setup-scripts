#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
# Ghostty may not always be in winget; best-effort.
try {
    Install-WingetPackage -Id 'Ghostty.Ghostty'
} catch {
    Write-Warning "Ghostty install skipped: $_"
}
