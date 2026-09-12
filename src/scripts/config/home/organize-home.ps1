#Requires -Version 7
$ErrorActionPreference = 'Continue'
@(
    (Join-Path $HOME 'Hacking')
    (Join-Path $HOME 'Projects/opensource')
    (Join-Path $HOME 'Projects/personal')
) | ForEach-Object {
    New-Item -ItemType Directory -Force -Path $_ | Out-Null
}
