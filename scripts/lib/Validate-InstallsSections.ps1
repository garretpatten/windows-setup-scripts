#Requires -Version 7
# Shared install validation sections. Expect Validate-Common.ps1 already loaded.

function Assert-Preflight {
    Write-Section 'Preflight'
    Test-VersionCmd 'git' { git --version }
    Test-VersionCmd 'curl' { curl --version }
}

function Assert-CliPackages {
    Write-Section 'Packages'
    Test-CommandOnPath 'bat' 'bat'
    Test-CommandOnPath 'eza' 'eza'
    Test-CommandOnPath 'fd' 'fd'
    Test-VersionCmd 'git' { git --version }
    Test-CommandOnPath 'jq' 'jq'
    Test-CommandOnPath 'fzf' 'fzf'
    Test-CommandOnPath 'zoxide' 'zoxide'
    Test-CommandOnPath 'tldr' 'tldr'
    Test-CommandOnPath 'tree-sitter' 'tree-sitter'
    Test-CommandOnPath 'lazygit' 'lazygit'
    Test-CommandOnPath 'lazydocker' 'lazydocker'
    Test-CommandOnPath 'rg' 'rg'
    Test-CommandOnPath 'vim' 'vim'
    Test-CommandOnPath 'yazi' 'yazi'
    Test-CommandOnPath 'btop' 'btop'
    Test-CommandOnPath 'fastfetch' 'fastfetch'
    Test-CommandOnPath 'gh' 'gh'
    Test-CommandOnPath 'shellcheck' 'shellcheck'
}

function Assert-Media {
    Write-Section 'Media'
    Test-WingetId 'vlc' 'VideoLAN.VLC'
    Test-CommandOnPath 'ffmpeg' 'ffmpeg'
}

function Assert-Productivity {
    Write-Section 'Productivity'
    Test-WingetId 'libreoffice' 'TheDocumentFoundation.LibreOffice'
    Test-WingetId 'keepassxc' 'KeePassXCTeam.KeePassXC'
    Test-WingetId 'flameshot' 'Flameshot.Flameshot'
    Test-WingetId 'notion' 'Notion.Notion'
}

function Assert-StoreApps {
    Write-Section 'Store / extra apps'
    Test-WingetId 'zoom' 'Zoom.Zoom'
    Test-WingetId 'zaproxy' 'ZAP.ZAP'
}

function Assert-DesktopApps {
    Write-Section 'Desktop apps'
    Test-WingetId 'etcher' 'Balena.Etcher'
    Test-WingetId 'chrome' 'Google.Chrome'
}

function Assert-Browsers {
    Write-Section 'Browsers'
    Test-WingetId 'brave' 'Brave.Brave'
    Test-WingetId 'google-chrome' 'Google.Chrome'
}

function Assert-Nvm {
    Write-Section 'nvm'
    $nvm = Join-Path $env:APPDATA 'nvm'
    if (Test-Path $nvm) {
        Test-PathExists 'nvm' $nvm
    } elseif (Get-Command nvm -ErrorAction SilentlyContinue) {
        Write-Pass 'nvm' 'nvm on PATH'
    } else {
        Write-Fail 'nvm' "expected $nvm or nvm on PATH"
    }
}

function Assert-Dev {
    Write-Section 'Dev'
    Test-CommandOnPath 'node' 'node'
    Test-CommandOnPath 'npm' 'npm'
    Test-CommandOnPath 'python' 'python'
    Test-CommandOnPath 'go' 'go'
    Test-CommandOnPath 'rustc' 'rustc'
    Test-CommandOnPath 'java' 'java'
    Test-CommandOnPath 'ruby' 'ruby'
    if (Get-Command gem -ErrorAction SilentlyContinue) {
        $sg = gem list solargraph -i 2>$null
        if ($LASTEXITCODE -eq 0 -or "$sg" -match 'true') {
            Write-Pass 'solargraph-gem' 'gem: solargraph'
        } else {
            Write-Fail 'solargraph-gem' 'gem install --user-install solargraph'
        }
    } else {
        Write-Fail 'solargraph-gem' 'gem not on PATH'
    }

    if (Get-Command docker -ErrorAction SilentlyContinue) {
        Test-VersionCmd 'docker' { docker --version }
    } elseif ($env:GITHUB_ACTIONS -eq 'true') {
        Write-Pass 'docker' 'optional in CI (Docker Desktop)'
    } else {
        Write-Fail 'docker' 'docker not on PATH'
    }

    Test-CommandOnPath 'nvim' 'nvim'
    Test-CommandOnPath 'gh' 'gh'
    Test-CommandOnPath 'shellcheck' 'shellcheck'
    Test-CommandOnPath 'semgrep' 'semgrep'

    if (Get-Command vue -ErrorAction SilentlyContinue) {
        Write-Pass 'vue-cli' ((vue --version 2>$null | Select-Object -First 1))
    } else {
        Write-Fail 'vue-cli' 'npm global @vue/cli'
    }

    if ((Get-Command agent -ErrorAction SilentlyContinue) -or (Get-Command cursor-agent -ErrorAction SilentlyContinue)) {
        Write-Pass 'cursor-agent' 'installed'
    } else {
        Write-Fail 'cursor-agent' 'agent / cursor-agent CLI'
    }

    Test-CommandOnPath 'ollama' 'ollama'
}

function Assert-DevDesktop {
    Write-Section 'Dev (desktop)'
    Test-WingetId 'bruno' 'Bruno.Bruno'
}

function Assert-SecurityCli {
    Write-Section 'Security'
    Test-CommandOnPath 'nmap' 'nmap'
    Test-CommandOnPath 'exiftool' 'exiftool'
    Test-WingetId 'openvpn' 'OpenVPNTechnologies.OpenVPNConnect'
    Test-PathExists 'hacking-payloads' (Join-Path $HOME 'Hacking/PayloadsAllTheThings')
    Test-PathExists 'hacking-seclists' (Join-Path $HOME 'Hacking/SecLists')
}

function Assert-SecurityDesktop {
    Write-Section 'Security (desktop)'
    Test-WingetId 'signal' 'OpenWhisperSystems.Signal'
    Test-WingetId 'proton-pass' 'Proton.ProtonPass'
    Test-WingetId 'proton-vpn' 'Proton.ProtonVPN'
}

function Assert-PassCli {
    Write-Section 'pass-cli'
    if (Get-Command pass-cli -ErrorAction SilentlyContinue) {
        Test-CommandOnPath 'pass-cli' 'pass-cli'
    } else {
        # Windows release artifact may lag Linux; treat as best-effort.
        Write-Pass 'pass-cli' 'optional if Windows binary unavailable upstream'
    }
}

function Assert-Shell {
    Write-Section 'Shell'
    Test-WingetId 'windows-terminal' 'Microsoft.WindowsTerminal'
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        Test-VersionCmd 'oh-my-posh' { oh-my-posh --version }
    } else {
        Write-Fail 'oh-my-posh' 'oh-my-posh on PATH'
    }
    $font = Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts/MesloLGMNerdFont-Regular.ttf'
    if (Test-Path $font) {
        Test-PathExists 'meslo-nerd-font' $font
    } else {
        # Font file name can vary across Meslo variants.
        $any = Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts') -Filter 'Meslo*Nerd*' -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($any) { Write-Pass 'meslo-nerd-font' $any.FullName }
        else { Write-Fail 'meslo-nerd-font' 'Meslo Nerd Font not installed' }
    }
}
