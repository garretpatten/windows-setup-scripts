#Requires -Version 7
$ErrorActionPreference = 'Continue'
# Ensure a profile exists that can load Oh My Posh when available.
$profilePath = $PROFILE.CurrentUserAllHosts
if (-not $profilePath) { $profilePath = $PROFILE }
$parent = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Force -Path $parent | Out-Null
if (Test-Path -LiteralPath $profilePath) { exit 0 }

@'
# Managed by windows-setup-scripts — extend freely.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh | Invoke-Expression
}
'@ | Set-Content -LiteralPath $profilePath -Encoding utf8
