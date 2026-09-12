#Requires -Version 7
# Verify tools after run-install.ps1 cli.
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')

. (Join-Path $PSScriptRoot 'lib/Validate-Common.ps1')
. (Join-Path $PSScriptRoot 'lib/Validate-InstallsSections.ps1')

Assert-Preflight
Assert-CliPackages
Assert-Nvm
Assert-Dev
Assert-SecurityCli
Assert-PassCli
Assert-Shell

Complete-Validation 'CLI install validation'
