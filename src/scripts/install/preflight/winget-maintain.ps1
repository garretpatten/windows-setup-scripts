#Requires -Version 7
$ErrorActionPreference = 'Continue'
try {
    winget source update --accept-source-agreements 2>$null
} catch {
    Write-Warning "winget source update failed (continuing): $_"
}
