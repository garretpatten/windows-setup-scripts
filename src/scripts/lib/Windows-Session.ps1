#Requires -Version 7

# True when running an interactive desktop Windows session (not headless CI).
function Test-WindowsDesktopSession {
    if ($env:GITHUB_ACTIONS -eq 'true' -or $env:CI -eq 'true') { return $false }
    if ($env:SESSIONNAME -eq 'Console' -or $env:SESSIONNAME -like 'RDP*') { return $true }
    return [Environment]::UserInteractive
}
