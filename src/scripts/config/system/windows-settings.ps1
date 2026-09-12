#Requires -Version 7
$ErrorActionPreference = 'Continue'
. (Join-Path $PSScriptRoot '../../lib/Windows-Session.ps1')
if (-not (Test-WindowsDesktopSession)) {
    Write-Host '[INFO] Skipping Windows UI settings (no desktop session / CI).'
    exit 0
}

# Dark mode + night light best-effort (mirrors GNOME dark + night-light prefs).
try {
    $personalize = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    if (-not (Test-Path $personalize)) { New-Item -Path $personalize -Force | Out-Null }
    Set-ItemProperty -Path $personalize -Name 'AppsUseLightTheme' -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $personalize -Name 'SystemUsesLightTheme' -Value 0 -Type DWord -Force
} catch {
    Write-Warning "Dark mode set failed: $_"
}

try {
    $explorer = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    if (-not (Test-Path $explorer)) { New-Item -Path $explorer -Force | Out-Null }
    Set-ItemProperty -Path $explorer -Name 'Hidden' -Value 1 -Type DWord -Force
} catch {
    Write-Warning "Explorer hidden files set failed: $_"
}
