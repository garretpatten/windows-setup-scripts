#Requires -Version 7
. (Join-Path $PSScriptRoot 'Path.ps1')

function Test-WingetInstalled {
    param([Parameter(Mandatory)][string]$Id)
    $out = winget list -e --id $Id --accept-source-agreements 2>$null | Out-String
    return ($out -match [regex]::Escape($Id))
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)][string]$Id,
        [string]$Source = ''
    )
    if (Test-WingetInstalled -Id $Id) {
        Write-Host "[INFO] $Id already installed"
        Update-SessionPath
        return
    }
    $wingetArgs = @(
        'install', '-e', '--id', $Id,
        '--silent', '--disable-interactivity',
        '--accept-package-agreements', '--accept-source-agreements'
    )
    if ($Source) { $wingetArgs += @('-s', $Source) }
    Write-Host "[INFO] winget $($wingetArgs -join ' ')"
    try {
        winget @wingetArgs
        # 0 = ok; -1978335189 (0x8A15002B) = already installed
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
            Write-Warning "winget install failed for ${Id} (exit $LASTEXITCODE)"
        }
    } catch {
        Write-Warning "winget install failed for ${Id}: $_"
    }
    Update-SessionPath
}

function Get-PackagesFromFile {
    param([Parameter(Mandatory)][string]$PackagesFile)
    if (-not (Test-Path -LiteralPath $PackagesFile)) { return @() }
    Get-Content -LiteralPath $PackagesFile |
        Where-Object { $_ -and ($_ -notmatch '^\s*#') -and ($_ -notmatch '^\s*$') } |
        ForEach-Object { $_.Trim() }
}

function Install-WingetPackagesFromFile {
    param(
        [Parameter(Mandatory)][string]$PackagesFile,
        [switch]$Optional
    )
    $packages = Get-PackagesFromFile -PackagesFile $PackagesFile
    foreach ($entry in $packages) {
        $id = $entry
        $source = ''
        if ($entry -match '^([^|]+)\|(.+)$') {
            $id = $Matches[1].Trim()
            $source = $Matches[2].Trim()
        }
        try {
            Install-WingetPackage -Id $id -Source $source
        } catch {
            if ($Optional) {
                Write-Warning "Optional package skipped: $id"
            } else {
                Write-Warning "Package install failed (continuing): $id — $_"
            }
        }
    }
}

function Install-WingetPackagesFromFiles {
    param(
        [string[]]$PackagesFiles,
        [switch]$Optional
    )
    foreach ($file in $PackagesFiles) {
        Install-WingetPackagesFromFile -PackagesFile $file -Optional:$Optional
    }
}
