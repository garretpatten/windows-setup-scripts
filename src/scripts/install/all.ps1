#Requires -Version 7
$ErrorActionPreference = 'Continue'
$Dir = $PSScriptRoot
. (Join-Path $Dir '../lib/Env.ps1')
. (Join-Path $Dir '../lib/Run.ps1')
. (Join-Path $Dir '../lib/Winget-Packages.ps1')
. (Join-Path $Dir '../lib/Path.ps1')
. (Join-Path $Dir '../lib/Parallel.ps1')

$InstallMode = if ($args.Count -ge 1) { $args[0] } else { 'all' }
$InstallMode = $InstallMode.TrimStart('-')
function Test-IsDesktop { $InstallMode -ne 'cli' }

# Non-winget work that is safe to parallelize.
$ParallelScripts = @(
    'dev/cursor-cli.ps1'
    'dev/ruby-gems.ps1'
    'dev/language-servers.ps1'
    'shell/meslo-nerd-font.ps1'
    'apps/hacking-repos.ps1'
)

# Extra winget installs not covered by packages/*.packages (must stay sequential —
# winget does not support concurrent installs).
$WingetExtraScripts = @(
    'dev/nvm.ps1'
    'dev/rustup.ps1'
    'dev/ollama.ps1'
    'dev/semgrep.ps1'
    'shell/ghostty.ps1'
)

$DesktopScripts = @(
    'apps/chrome.ps1'
    'apps/etcher.ps1'
    'apps/proton-pass.ps1'
)

Write-Host '==> Installing base winget packages...'
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/base.packages')

Write-Host '==> Installing shell winget packages...'
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/shell.packages')

if (Test-IsDesktop) {
    Write-Host '==> Installing media winget packages...'
    Install-WingetPackagesFromFile (Join-Path $Dir 'packages/media.packages')

    Write-Host '==> Installing desktop winget packages...'
    Install-WingetPackagesFromFile (Join-Path $Dir 'packages/desktop.packages')

    Write-Host '==> Installing productivity winget packages...'
    Install-WingetPackagesFromFile (Join-Path $Dir 'packages/productivity.packages')

    Invoke-SetupScript (Join-Path $Dir 'apps/protonvpn.ps1')
}

Write-Host '==> Installing dev and language packages...'
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/lsp.packages')
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/dev.packages')
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/lsp-optional.packages') -Optional

Write-Host '==> Installing third-party packages...'
if (Test-IsDesktop) {
    Install-WingetPackagesFromFile (Join-Path $Dir 'packages/third-party-desktop.packages') -Optional
}
# Node.js LTS is required for npm global tools; Docker Desktop stays optional.
Install-WingetPackage -Id 'OpenJS.NodeJS.LTS'
Install-WingetPackagesFromFile (Join-Path $Dir 'packages/third-party-cli.packages') -Optional

Write-Host '==> Installing extra winget tools (sequential)...'
foreach ($rel in $WingetExtraScripts) {
    Invoke-SetupScript (Join-Path $Dir $rel)
}
Update-SessionPath

Write-Host '==> Initializing asynchronous downloads...'
$jobs = @()
foreach ($rel in $ParallelScripts) {
    $jobs += Start-SetupJobBestEffort (Join-Path $Dir $rel)
}
Wait-SetupJobsBestEffort -Label 'asynchronous tasks' -Jobs $jobs
Write-Host '==> Asynchronous tasks completed.'

# Vue CLI needs node/npm on PATH (after Node LTS / nvm).
Update-SessionPath
Invoke-SetupScript (Join-Path $Dir 'dev/vue-cli.ps1')

if (Test-IsDesktop) {
    Write-Host '==> Installing store / extra apps...'
    Invoke-SetupScript (Join-Path $Dir 'apps/store-apps.ps1')

    Write-Host '==> Installing desktop apps (sequential winget)...'
    foreach ($rel in $DesktopScripts) {
        Invoke-SetupScript (Join-Path $Dir $rel)
    }
}

Invoke-SetupScript (Join-Path $Dir 'apps/pass-cli.ps1')
Invoke-SetupScript (Join-Path $Dir 'post-install/all.ps1')

Update-SessionPath
Export-PathForGitHubActions
