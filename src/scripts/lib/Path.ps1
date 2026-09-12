#Requires -Version 7
# Refresh process PATH after winget/installer changes and expose dirs to GitHub Actions.

function Get-PathEntries {
    param([string]$Value)
    if (-not $Value) { return @() }
    $Value -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

function Test-PathListContains {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$Candidate
    )
    foreach ($existing in $List) {
        if ($existing -and $Candidate -and ($existing.Equals($Candidate, [StringComparison]::OrdinalIgnoreCase))) {
            return $true
        }
    }
    return $false
}

function Expand-PathEnvRefs {
    # Installers like nvm-windows append literal %VAR% references to PATH as
    # REG_EXPAND_SZ; .NET cannot expand them unless the vars are in-process.
    param([string]$Entry)
    if (-not $Entry -or ($Entry -notmatch '%')) { return $Entry }
    return [regex]::Replace($Entry, '%([^%]+)%', {
        param($match)
        $name = $match.Groups[1].Value
        $value = [Environment]::GetEnvironmentVariable($name, 'Machine')
        if (-not $value) { $value = [Environment]::GetEnvironmentVariable($name, 'User') }
        if ($value) { $value } else { $match.Value }
    })
}

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $entries = [System.Collections.Generic.List[string]]::new()
    foreach ($part in @(Get-PathEntries $machine) + @(Get-PathEntries $user)) {
        $part = Expand-PathEnvRefs $part
        if (-not (Test-PathListContains -List $entries -Candidate $part)) {
            $entries.Add($part) | Out-Null
        }
    }

    $programFilesX86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
    # Portable winget shims and common tool roots (may exist before PATH is registered).
    $extras = @(
        (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links')
        (Join-Path $env:LOCALAPPDATA 'Programs\oh-my-posh\bin')
        (Join-Path $HOME '.cargo\bin')
        (Join-Path $env:APPDATA 'nvm')
        (Join-Path $env:LOCALAPPDATA 'nvm')
        (Join-Path $env:ProgramFiles 'Neovim\bin')
        (Join-Path $env:LOCALAPPDATA 'Programs\Ollama')
    )
    # pip --user script dirs are never added to PATH by pip itself.
    $pythonUserScripts = Get-ChildItem -Path (Join-Path $env:APPDATA 'Python') -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'Scripts' } |
        Where-Object { Test-Path -LiteralPath $_ }
    $extras += @($pythonUserScripts)
    if ($programFilesX86) {
        $extras += (Join-Path $programFilesX86 'Nmap')
    }
    foreach ($dir in $extras) {
        if ($dir -and (Test-Path -LiteralPath $dir) -and -not (Test-PathListContains -List $entries -Candidate $dir)) {
            $entries.Insert(0, $dir)
        }
    }

    $env:Path = ($entries -join ';')
}

function Export-PathForGitHubActions {
    if (-not $env:GITHUB_PATH) { return }
    if (-not (Test-Path -LiteralPath $env:GITHUB_PATH)) { return }

    Update-SessionPath
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $dirs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($part in @(Get-PathEntries $user)) {
        $part = Expand-PathEnvRefs $part
        if ($part) { [void]$dirs.Add($part) }
    }

    $programFilesX86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
    $known = @(
        (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links')
        (Join-Path $env:LOCALAPPDATA 'Programs\oh-my-posh\bin')
        (Join-Path $HOME '.cargo\bin')
        (Join-Path $env:APPDATA 'nvm')
        (Join-Path $env:LOCALAPPDATA 'nvm')
        (Join-Path $env:ProgramFiles 'Neovim\bin')
        (Join-Path $env:LOCALAPPDATA 'Programs\Ollama')
    )
    $pythonUserScripts = Get-ChildItem -Path (Join-Path $env:APPDATA 'Python') -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'Scripts' } |
        Where-Object { Test-Path -LiteralPath $_ }
    $known += @($pythonUserScripts)
    if ($programFilesX86) {
        $known += (Join-Path $programFilesX86 'Nmap')
    }
    foreach ($part in $known) {
        if ($part -and (Test-Path -LiteralPath $part)) { [void]$dirs.Add($part) }
    }

    foreach ($dir in $dirs) {
        Add-Content -LiteralPath $env:GITHUB_PATH -Value $dir
    }
}
