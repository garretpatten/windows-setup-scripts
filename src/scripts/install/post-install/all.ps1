#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../../lib/Run.ps1')

Invoke-SetupScript (Join-Path $Dir 'winget-maintain.ps1')
Invoke-SetupScript (Join-Path $Dir 'docker-service.ps1')
Invoke-SetupScript (Join-Path $Dir 'tldr-cache.ps1')
Invoke-SetupScript (Join-Path $Dir 'completion-banner.ps1')
