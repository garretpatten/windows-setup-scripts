#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (-not (Get-Command tldr -ErrorAction SilentlyContinue)) { exit 0 }
try { tldr --update } catch { Write-Warning "tldr --update failed: $_" }
