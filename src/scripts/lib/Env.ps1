#Requires -Version 7
# Exports used by orchestrators and leaf scripts (dot-sourced once per run).

$ScriptsDir = Split-Path -Parent $PSScriptRoot
$ProjectRoot = (Resolve-Path (Join-Path $ScriptsDir '../..')).Path
$TempDir = Join-Path $env:TEMP ("windows-setup-{0}" -f $PID)
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

$env:PROJECT_ROOT = $ProjectRoot
$env:TEMP_DIR = $TempDir

Set-Variable -Name ProjectRoot -Scope Global -Value $ProjectRoot -Force
Set-Variable -Name TempDir -Scope Global -Value $TempDir -Force
Set-Variable -Name ScriptsDir -Scope Global -Value $ScriptsDir -Force
