#Requires -Version 7

function Ensure-SubmodulesSynced {
    param([string]$Root = $env:PROJECT_ROOT)

    if (-not $Root) {
        Write-Error 'PROJECT_ROOT is not set; cannot sync submodules.'
        return
    }
    if (-not (Test-Path -LiteralPath (Join-Path $Root '.git'))) {
        Write-Warning 'Not a git repository; skipping submodule sync.'
        return
    }

    Push-Location $Root
    try {
        $status = git submodule status 2>$null | Out-String
        if ($status -match '(?m)^-') {
            Write-Host '==> Initializing submodules...'
            git submodule update --init --recursive 2>$null
        } else {
            Write-Host '==> Updating submodules...'
            git submodule update --recursive 2>$null
        }
    } catch {
        Write-Warning "Submodule sync failed (continuing): $_"
    } finally {
        Pop-Location
    }
}
