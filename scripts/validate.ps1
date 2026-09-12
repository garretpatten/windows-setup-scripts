#Requires -Version 7
# CI/local gate after master.ps1.
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')

$failures = 0
& (Join-Path $PSScriptRoot 'validate-installs.ps1'); if ($LASTEXITCODE -ne 0) { $failures++ }
& (Join-Path $PSScriptRoot 'validate-config.ps1'); if ($LASTEXITCODE -ne 0) { $failures++ }
exit $failures
