#Requires -Version 7
# Verify config after master / install+config.
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')

. (Join-Path $PSScriptRoot 'lib/Validate-Common.ps1')
. (Join-Path $PSScriptRoot 'lib/Validate-ConfigSections.ps1')

Assert-ConfigDotfiles
Assert-ConfigHome
Assert-ConfigGit
Assert-ConfigSystem

Complete-Validation 'Config validation'
