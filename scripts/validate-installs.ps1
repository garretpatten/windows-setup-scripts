#Requires -Version 7
# Verify tools after run-install.ps1 all / master.ps1.
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')

. (Join-Path $PSScriptRoot 'lib/Validate-Common.ps1')
. (Join-Path $PSScriptRoot 'lib/Validate-InstallsSections.ps1')

Assert-Preflight
Assert-CliPackages
Assert-Media
Assert-Productivity
Assert-StoreApps
Assert-DesktopApps
Assert-Browsers
Assert-Nvm
Assert-Dev
Assert-DevDesktop
Assert-SecurityCli
Assert-SecurityDesktop
Assert-PassCli
Assert-Shell

Complete-Validation 'Install validation'
