#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
. (Join-Path $PSScriptRoot '../../lib/Path.ps1')

$nvmHome = Join-Path $env:APPDATA 'nvm'
if (-not (Test-Path -LiteralPath $nvmHome)) {
    Install-WingetPackage -Id 'CoreyButler.NVMforWindows'
}
Update-SessionPath

$nvmCmd = Get-Command nvm -ErrorAction SilentlyContinue
$nvmExe = Join-Path $nvmHome 'nvm.exe'
if (-not $nvmCmd -and (Test-Path -LiteralPath $nvmExe)) {
    $env:Path = "$nvmHome;$env:Path"
    $nvmCmd = Get-Command nvm -ErrorAction SilentlyContinue
}

# Ensure at least one Node is available via nvm when the manager installed cleanly.
if ($nvmCmd -or (Test-Path -LiteralPath $nvmExe)) {
    try {
        # nvm-windows accepts a version or "latest" (not the bash "lts" alias).
        if ($nvmCmd) {
            nvm install latest 2>$null
            nvm use latest 2>$null
        } else {
            & $nvmExe install latest 2>$null
            & $nvmExe use latest 2>$null
        }
    } catch {
        Write-Warning "nvm node install failed (continuing): $_"
    }
    Update-SessionPath
}
