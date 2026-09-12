#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { exit 0 }
try {
    npm install -g bash-language-server pyright typescript-language-server yaml-language-server `
        --loglevel=error --no-update-notifier
} catch {
    Write-Warning "npm language servers failed: $_"
}
