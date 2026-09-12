#Requires -Version 7
$ErrorActionPreference = 'Continue'
$dir = Join-Path $HOME 'Pictures/Screenshots'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
