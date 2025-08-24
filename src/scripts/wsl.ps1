#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

Install-Pkg 'wsl'
Install-Pkg 'ubuntu2404'
Write-Info "For tmux/zsh inside WSL: sudo apt update && sudo apt install -y zsh tmux"

