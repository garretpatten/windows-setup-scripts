#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../lib/Env.ps1')
. (Join-Path $Dir '../lib/Dotfiles-Install.ps1')

Link-DotfilesXdgConfigDirs
Install-DotfilesFromManifest (Join-Path $Dir 'dotfiles.manifest')
