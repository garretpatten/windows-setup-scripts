#Requires -Version 7
$ErrorActionPreference = 'Continue'
# Best-effort: ensure Windows Update service is present (mirrors unattended-upgrades intent).
try {
    $svc = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
    if ($svc -and $svc.StartType -eq 'Disabled') {
        Set-Service -Name wuauserv -StartupType Manual -ErrorAction SilentlyContinue
    }
} catch {
    Write-Warning "Windows Update tweak skipped: $_"
}
