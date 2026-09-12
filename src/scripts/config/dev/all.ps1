#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../../lib/Env.ps1')
. (Join-Path $Dir '../../lib/Run.ps1')

Invoke-SetupScript (Join-Path $Dir '../dotfiles.ps1')
Invoke-SetupScript (Join-Path $Dir 'gitconfig.ps1')
