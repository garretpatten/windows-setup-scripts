#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
if (Get-Command semgrep -ErrorAction SilentlyContinue) { exit 0 }
try {
    Install-WingetPackage -Id 'Semgrep.Semgrep'
} catch {
    try { pip3 install --user semgrep } catch { Write-Warning "semgrep install failed: $_" }
}
