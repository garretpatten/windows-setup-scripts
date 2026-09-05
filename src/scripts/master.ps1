#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir 'lib/Env.ps1')
. (Join-Path $Dir 'lib/Run.ps1')
. (Join-Path $Dir 'lib/Git-Submodules.ps1')

Ensure-SubmodulesSynced -Root $env:PROJECT_ROOT

Invoke-SetupScript (Join-Path $Dir 'install/preflight/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'config/system/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'config/home/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'install/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'config/dev/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'config/security/all.ps1')
Invoke-SetupScript (Join-Path $Dir 'config/shell/all.ps1')
