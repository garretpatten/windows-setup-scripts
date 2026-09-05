#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../lib/Env.ps1')
. (Join-Path $Dir '../lib/Run.ps1')

Invoke-SetupScript (Join-Path $Dir 'system/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'home/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'dev/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'security/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'shell/all.ps1')
