#Requires -Version 7
$ErrorActionPreference = 'Continue'
$hacking = Join-Path $HOME 'Hacking'
New-Item -ItemType Directory -Force -Path $hacking | Out-Null

function Clone-IfMissing([string]$Url, [string]$Dest) {
    if (Test-Path -LiteralPath $Dest) { return }
    try {
        git clone --depth 1 --filter=blob:none $Url $Dest
    } catch {
        Write-Warning "Clone failed: $Url — $_"
    }
}

Clone-IfMissing 'https://github.com/swisskyrepo/PayloadsAllTheThings' (Join-Path $hacking 'PayloadsAllTheThings')
Clone-IfMissing 'https://github.com/danielmiessler/SecLists' (Join-Path $hacking 'SecLists')
