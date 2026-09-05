#Requires -Version 7
# Shared config validation sections. Expect Validate-Common.ps1 already loaded.

function Assert-ConfigDotfiles {
    Write-Section 'Dotfiles'
    Test-PathExists 'dotfiles-nvim' (Join-Path $env:LOCALAPPDATA 'nvim')
    Test-PathExists 'dotfiles-fastfetch' (Join-Path $env:LOCALAPPDATA 'fastfetch')
    Test-PathExists 'dotfiles-btop' (Join-Path $env:LOCALAPPDATA 'btop')
    Test-PathExists 'dotfiles-zellij' (Join-Path $env:LOCALAPPDATA 'zellij')
    Test-PathExists 'dotfiles-tmux' (Join-Path $env:LOCALAPPDATA 'tmux')
    Test-PathExists 'dotfiles-zsh' (Join-Path $env:LOCALAPPDATA 'zsh')
}

function Assert-ConfigHome {
    Write-Section 'Home layout'
    Test-PathExists 'screenshots-dir' (Join-Path $HOME 'Pictures/Screenshots')
    Test-PathExists 'projects-personal' (Join-Path $HOME 'Projects/personal')
    Test-PathExists 'hacking-dir' (Join-Path $HOME 'Hacking')
}

function Assert-ConfigGit {
    Write-Section 'Git'
    $helper = git config --global --get credential.helper 2>$null
    if ("$helper" -match 'manager') {
        Write-Pass 'git-credential-helper' $helper
    } else {
        Write-Fail 'git-credential-helper' 'expected credential.helper manager'
    }
}

function Assert-ConfigSystemCore {
    Test-PathExists 'screenshots-dir' (Join-Path $HOME 'Pictures/Screenshots')
}

function Assert-ConfigFirewall {
    try {
        $rule = Get-NetFirewallRule -DisplayName 'LocalSend UDP 53317' -ErrorAction SilentlyContinue
        if ($rule) {
            Write-Pass 'firewall-localsend' 'LocalSend UDP 53317'
        } elseif ($env:GITHUB_ACTIONS -eq 'true') {
            Write-Pass 'firewall-localsend' 'skipped in CI without elevation'
        } else {
            Write-Fail 'firewall-localsend' 'LocalSend UDP 53317 rule missing'
        }
    } catch {
        if ($env:GITHUB_ACTIONS -eq 'true') {
            Write-Pass 'firewall-localsend' 'skipped in CI'
        } else {
            Write-Fail 'firewall-localsend' $_.Exception.Message
        }
    }
}

function Assert-ConfigSystem {
    Write-Section 'System'
    Assert-ConfigFirewall
    Assert-ConfigSystemCore
}
