#Requires -Version 7
# Lint changed PowerShell files vs origin/master (mirrors ShellCheck helper).
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

git fetch origin main master 2>$null | Out-Null
if (git show-ref --verify --quiet refs/remotes/origin/master) {
    $base = 'origin/master'
} elseif (git show-ref --verify --quiet refs/remotes/origin/main) {
    $base = 'origin/main'
} else {
    $base = 'HEAD~1'
}

$changed = git diff --name-only --diff-filter=ACMR "$base...HEAD" |
    Where-Object { $_ -match '\.ps1$' -and (Test-Path $_) }

if (-not $changed) {
    Write-Host "No changed PowerShell files to check (base: $base)"
    exit 0
}

if (-not (Get-Module -ListAvailable PSScriptAnalyzer)) {
    Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -SkipPublisherCheck
}

Write-Host "PSScriptAnalyzer ($($changed.Count) files, base: $base)"
$issues = @()
foreach ($file in $changed) {
    $issues += Invoke-ScriptAnalyzer -Path $file -Severity Warning, Error
}
if ($issues) {
    $issues | Format-Table -AutoSize
    exit 1
}
Write-Host 'PSScriptAnalyzer passed.'
