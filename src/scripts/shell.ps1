#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# Terminal + prompt
'terminal','ohmyposh' | ForEach-Object { Install-Pkg $_ }

# Fonts: install manually; winget coverage is inconsistent. Skipped by design.

