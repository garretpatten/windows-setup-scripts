#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

$folders = @("$HOME\Code", "$HOME\Tools", "$HOME\Security", "$HOME\Media", "$HOME\tmp")
$folders | ForEach-Object { Ensure-Dir $_ }

