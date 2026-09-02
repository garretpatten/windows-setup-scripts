#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# Terminal + prompt
'terminal','ohmyposh' | ForEach-Object { Install-Pkg $_ }

# Ghostty, tmux, and zsh are not available natively on Windows; run them inside WSL if needed.
# Fonts: install manually; winget coverage is inconsistent. Skipped by design.

