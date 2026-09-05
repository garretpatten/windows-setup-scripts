#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../../lib/Run.ps1')

Invoke-SetupScript (Join-Path $Dir 'screenshots-directory.ps1')
Invoke-SetupScript (Join-Path $Dir 'windows-settings.ps1')
Invoke-SetupScript (Join-Path $Dir 'windows-update.ps1')
Invoke-SetupScript (Join-Path $Dir 'system-policy.ps1')
