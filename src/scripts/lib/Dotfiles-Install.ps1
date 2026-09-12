#Requires -Version 7

function Expand-HomePath {
    param([Parameter(Mandatory)][string]$Path)
    if ($Path -eq '~') { return $HOME }
    if ($Path.StartsWith('~/') -or $Path.StartsWith('~\')) {
        return (Join-Path $HOME $Path.Substring(2))
    }
    return $Path
}

function Copy-DotfileFile {
    param(
        [Parameter(Mandatory)][string]$RelSrc,
        [Parameter(Mandatory)][string]$Dest
    )
    $destPath = Expand-HomePath $Dest
    if (Test-Path -LiteralPath $destPath) { return }
    $src = Join-Path $env:PROJECT_ROOT "src/dotfiles/$RelSrc"
    if (-not (Test-Path -LiteralPath $src)) { return }
    $parent = Split-Path -Parent $destPath
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -LiteralPath $src -Destination $destPath
}

# Prefer LocalAppData for tool configs; Roaming for a few GUI apps.
$script:XdgConfigScope = @{
    alacritty = 'Roaming'
    yazi      = 'Roaming'
    pip       = 'Roaming'
    lazygit   = 'Roaming'
    ghostty   = 'Roaming'
    opencode  = 'Roaming'
    uv        = 'Roaming'
    zsh       = 'Local'
    nvim      = 'Local'
    tmux      = 'Local'
    fastfetch = 'Local'
    kitty     = 'Local'
    githooks  = 'Local'
    ohmyposh  = 'Local'
    zellij    = 'Local'
    btop      = 'Local'
}

function Get-XdgConfigPath {
    param([Parameter(Mandatory)][string]$Name)
    $scope = if ($script:XdgConfigScope.ContainsKey($Name)) { $script:XdgConfigScope[$Name] } else { 'Local' }
    $base = if ($scope -eq 'Roaming') { $env:APPDATA } else { $env:LOCALAPPDATA }
    return Join-Path $base $Name
}

function Link-DotfilesXdgConfigDirs {
    $configDir = Join-Path $env:PROJECT_ROOT 'src/dotfiles/config'
    if (-not (Test-Path -LiteralPath $configDir)) { return }

    Get-ChildItem -LiteralPath $configDir -Directory | ForEach-Object {
        $name = $_.Name
        $srcAbs = $_.FullName
        $target = Get-XdgConfigPath $name

        if ((Test-Path -LiteralPath $target) -and -not ((Get-Item -LiteralPath $target).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            $bak = "$target.dotfiles-bak-$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Warning "$target exists; moving to $bak"
            Move-Item -LiteralPath $target -Destination $bak -Force
        }

        $existing = Get-Item -LiteralPath $target -ErrorAction SilentlyContinue
        if ($existing -and ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            if ($existing.Target -contains $srcAbs -or $existing.LinkTarget -eq $srcAbs) { return }
        }

        $parent = Split-Path -Parent $target
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        try {
            New-Item -ItemType SymbolicLink -Path $target -Target $srcAbs -Force -ErrorAction Stop | Out-Null
            Write-Host "[INFO] Linked config -> $target"
        } catch {
            Copy-Item -Recurse -Force $srcAbs $target
            Write-Host "[INFO] Copied config -> $target (symlink failed: $_)"
        }
    }
}

function Install-DotfilesFromManifest {
    param([Parameter(Mandatory)][string]$Manifest)
    if (-not (Test-Path -LiteralPath $Manifest)) { return }
    Get-Content -LiteralPath $Manifest | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith('#')) { return }
        $parts = $line -split '\s+', 3
        if ($parts.Count -lt 3) { return }
        if ($parts[0] -eq 'file') {
            Copy-DotfileFile -RelSrc $parts[1] -Dest $parts[2]
        }
    }
}
