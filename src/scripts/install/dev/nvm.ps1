#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Winget-Packages.ps1')
. (Join-Path $PSScriptRoot '../../lib/Path.ps1')

# NVM for Windows 1.2.x installs under %LOCALAPPDATA%\nvm; older versions used %APPDATA%\nvm.
$candidateHomes = @(
    $env:NVM_HOME,
    (Join-Path $env:LOCALAPPDATA 'nvm'),
    (Join-Path $env:APPDATA 'nvm')
) | Where-Object { $_ }
$nvmHome = $candidateHomes | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if (-not $nvmHome) {
    Install-WingetPackage -Id 'CoreyButler.NVMforWindows'
    Update-SessionPath
    $nvmHome = $candidateHomes | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}
if (-not $nvmHome) {
    Write-Warning 'nvm home not found after install (continuing)'
    return
}

if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    $env:Path = "$nvmHome;$env:Path"
}

# Only let nvm provision Node when nothing else provides it: nvm manages its own
# NVM_SYMLINK location and would otherwise shadow an existing Node install.
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    try {
        # nvm-windows accepts a version or "latest" (not the bash "lts" alias).
        nvm install latest
        nvm use latest
        Update-SessionPath
    } catch {
        Write-Warning "nvm node install failed (continuing): $_"
    }
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    # Fallback: plain Node LTS via winget (--force repairs broken ARP entries).
    Write-Warning 'node still missing after nvm; installing Node LTS via winget'
    Install-WingetPackage -Id 'OpenJS.NodeJS.LTS' -Force
    Update-SessionPath
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Warning 'node is still not on PATH after nvm and Node LTS fallback'
}
