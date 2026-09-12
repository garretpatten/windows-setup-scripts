#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir 'lib/Env.ps1')
. (Join-Path $Dir 'lib/Run.ps1')
. (Join-Path $Dir 'lib/Git-Submodules.ps1')

Ensure-SubmodulesSynced -Root $env:PROJECT_ROOT
Invoke-SetupScript (Join-Path $Dir 'config/all.ps1')
