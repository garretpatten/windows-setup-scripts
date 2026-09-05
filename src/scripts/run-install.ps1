#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir 'lib/Env.ps1')
. (Join-Path $Dir 'lib/Run.ps1')

$Mode = if ($args.Count -ge 1) { $args[0] } else { 'all' }
$Mode = $Mode.TrimStart('-')

Invoke-SetupScript (Join-Path $Dir 'install/preflight/all.ps1')

switch ($Mode) {
    'cli' {
        Invoke-SetupScript (Join-Path $Dir 'install/cli.ps1')
    }
    { $_ -in @('all', 'installs') } {
        Invoke-SetupScript (Join-Path $Dir 'install/all.ps1')
    }
    default {
        Write-Error "Usage: $($MyInvocation.MyCommand.Name) {cli|all}"
        exit 1
    }
}
