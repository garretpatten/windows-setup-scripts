#Requires -Version 7

function Ensure-TempDir {
    if (-not $env:TEMP_DIR) {
        $env:TEMP_DIR = Join-Path $env:TEMP ("windows-setup-{0}" -f $PID)
    }
    New-Item -ItemType Directory -Force -Path $env:TEMP_DIR | Out-Null
}

function Invoke-SetupScript {
    param(
        [Parameter(Mandatory)][string]$Script,
        [string[]]$ArgumentList = @()
    )

    if (-not $env:PROJECT_ROOT) {
        . (Join-Path $PSScriptRoot 'Env.ps1')
    }
    Ensure-TempDir

    if (-not (Test-Path -LiteralPath $Script)) {
        Write-Warning "Missing script: $Script"
        return
    }

    try {
        & $Script @ArgumentList
    } catch {
        Write-Warning "Script failed (continuing): $Script — $_"
    }
}
