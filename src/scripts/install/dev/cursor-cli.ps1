#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (Get-Command agent -ErrorAction SilentlyContinue) { exit 0 }
if (Get-Command cursor-agent -ErrorAction SilentlyContinue) { exit 0 }
try {
    irm 'https://cursor.com/install?win=true' | iex
} catch {
    Write-Warning "Cursor Agent CLI install failed: $_"
}
