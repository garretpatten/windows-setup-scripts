#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Path.ps1')
if (Get-Command semgrep -ErrorAction SilentlyContinue) { exit 0 }
# Semgrep is not published on winget; pip is the documented Windows install path.
try {
    python -m pip install --user --upgrade semgrep
    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
        Write-Warning "semgrep pip install failed (exit $LASTEXITCODE)"
    }
} catch {
    Write-Warning "semgrep install failed: $_"
}
Update-SessionPath
