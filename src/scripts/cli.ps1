#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

$cli = @('git','ripgrep','fd','bat','eza','jq','wget','curl','fastfetch','vim','btop','fzf','zoxide','tree_sitter','make','shellcheck','lazygit','lazydocker','yazi')
$cli | ForEach-Object { Install-Pkg $_ }

