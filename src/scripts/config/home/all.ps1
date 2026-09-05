#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../../lib/Run.ps1')
Invoke-SetupScript (Join-Path $Dir 'organize-home.ps1')
