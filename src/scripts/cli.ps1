#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

$cli = @('git','ripgrep','fd','bat','eza','jq','wget','curl','fastfetch','vim')
$cli | ForEach-Object { Install-Pkg $_ }

