#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../../lib/Run.ps1')

Invoke-SetupScript (Join-Path $Dir 'winget-maintain.ps1')
Invoke-SetupScript (Join-Path $Dir 'essentials.ps1')
Invoke-SetupScript (Join-Path $Dir 'timezone.ps1')
