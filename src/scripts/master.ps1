#Requires -Version 7
param(
  [switch]$SkipCLI,
  [switch]$SkipDev,
  [switch]$SkipWeb,
  [switch]$SkipMedia,
  [switch]$SkipProductivity,
  [switch]$SkipSecurity,
  [switch]$SkipShell,
  [switch]$WithWSL
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Run($name) {
  $path = Join-Path $root $name
  Write-Host "`n=== $name ==="
  & pwsh $path
  if ($LASTEXITCODE) { throw "Step failed: $name" }
}

if (-not $SkipCLI)          { Run 'cli.ps1' }
if (-not $SkipDev)          { Run 'dev.ps1' }
if (-not $SkipWeb)          { Run 'web.ps1' }
if (-not $SkipMedia)        { Run 'media.ps1' }
if (-not $SkipProductivity) { Run 'productivity.ps1' }
if (-not $SkipSecurity)     { Run 'security.ps1' }
if (-not $SkipShell)        { Run 'shell.ps1' }
if ($WithWSL)               { Run 'wsl.ps1' }

Run 'organizeHome.ps1'

