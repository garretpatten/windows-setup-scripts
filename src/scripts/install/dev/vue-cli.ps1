#Requires -Version 7
$ErrorActionPreference = 'Continue'
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { exit 0 }
try {
    npm install -g @vue/cli --loglevel=error --no-update-notifier
} catch {
    Write-Warning "vue-cli install failed: $_"
}
