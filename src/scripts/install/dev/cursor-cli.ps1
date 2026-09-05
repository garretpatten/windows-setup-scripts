#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (Get-Command agent -ErrorAction SilentlyContinue) { exit 0 }
if (Get-Command cursor-agent -ErrorAction SilentlyContinue) { exit 0 }

# Official Cursor Windows installer is a remote script (same pattern as Linux curl|bash).
try {
    $installScript = Invoke-RestMethod -Uri 'https://cursor.com/install?win=true'
    $tempScript = Join-Path $env:TEMP_DIR 'cursor-install.ps1'
    if (-not $env:TEMP_DIR) {
        $tempScript = Join-Path $env:TEMP 'cursor-install.ps1'
    }
    Set-Content -LiteralPath $tempScript -Value $installScript -Encoding utf8
    & $tempScript
} catch {
    Write-Warning "Cursor Agent CLI install failed: $_"
}
