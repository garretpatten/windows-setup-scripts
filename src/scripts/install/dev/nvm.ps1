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

$nvmExe = if ($nvmHome) { Join-Path $nvmHome 'nvm.exe' } else { $null }
$nvmCmd = Get-Command nvm -ErrorAction SilentlyContinue
if (-not $nvmCmd -and $nvmExe -and (Test-Path -LiteralPath $nvmExe)) {
    $env:Path = "$nvmHome;$env:Path"
    $nvmCmd = Get-Command nvm -ErrorAction SilentlyContinue
}

# Only let nvm provision Node when nothing else provides it: `nvm use` replaces
# the nodejs symlink, which would clobber an existing Node installation.
if ($nvmCmd -and -not (Get-Command node -ErrorAction SilentlyContinue)) {
    try {
        # nvm-windows accepts a version or "latest" (not the bash "lts" alias).
        nvm install latest
        nvm use latest
        Update-SessionPath
        if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
            Write-Warning 'nvm installed but node is still not on PATH (continuing)'
        }
    } catch {
        Write-Warning "nvm node install failed (continuing): $_"
    }
}
