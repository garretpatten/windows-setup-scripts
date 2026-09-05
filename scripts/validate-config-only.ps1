#Requires -Version 7
# Verify config outcomes after standalone run-config.ps1.
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')

. (Join-Path $PSScriptRoot 'lib/Validate-Common.ps1')
. (Join-Path $PSScriptRoot 'lib/Validate-ConfigSections.ps1')

Assert-ConfigDotfiles
Assert-ConfigHome

Write-Section 'System'
Assert-ConfigSystemCore
# Firewall skipped in config-only: often needs elevation / install-time tools.

Complete-Validation 'Config-only validation'
