#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (-not (Get-Command gem -ErrorAction SilentlyContinue)) { exit 0 }
try { gem install --user-install solargraph } catch { Write-Warning "solargraph gem failed: $_" }
