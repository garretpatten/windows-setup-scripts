#Requires -Version 7
$ErrorActionPreference = 'Continue'
# Privacy / telemetry lean settings (best-effort; no admin required for HKCU).
try {
    $privacy = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy'
    if (-not (Test-Path $privacy)) { New-Item -Path $privacy -Force | Out-Null }
    Set-ItemProperty -Path $privacy -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
} catch {
    Write-Warning "System policy tweaks skipped: $_"
}
