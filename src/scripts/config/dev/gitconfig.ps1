#Requires -Version 7
$ErrorActionPreference = 'Continue'

# Git for Windows ships with Git Credential Manager.
try {
    git config --global credential.helper manager
} catch {
    Write-Warning "credential.helper set failed: $_"
}

try {
    $hooks = git config --global --get core.hooksPath 2>$null
    if (-not $hooks) {
        $hooksPath = Join-Path $env:LOCALAPPDATA 'githooks'
        git config --global core.hooksPath $hooksPath
    }
} catch {
    Write-Warning "hooksPath set failed: $_"
}

if (Test-Path (Join-Path $HOME '.gitconfig')) { exit 0 }

git config --global http.postBuffer 157286400
git config --global pack.window 1
git config --global user.email 'garret.patten@proton.me'
git config --global user.name 'Garret Patten'
git config --global pull.rebase false
git config --global init.defaultBranch main
