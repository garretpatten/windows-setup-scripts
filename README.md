# Windows Setup Scripts
A repository of setup scripts for my personal windows environments

# Instructions

## Before Using
1. Carry out a full system update through System Settings.
2. Install and Configure Windows Subsystem for Linux (WSL): `wsl --install`
3. Ensure WSL is using Ubuntu as the default distribution.
4. Be prepared with 2 hardware keys (primary & backup).

## How to Use
Open a PowerShell Window running as Administrator, and:
```
# Clone repository
git clone https://github.com/garretpatten/windows-setup-scripts

# Checkout root of project
cd windows-setup-scripts

# Make scripts executable
sudo chmod +x src/scripts/

# Run master script
sh src/scripts/master.sh
```

# Installations

## CLI Tools
- 1password-cli, bat, brew, clamav, exa, gh, git, neofetch, protonvpn-cli, src-cli, taskwarrior, wget, zsh

## Applications
- 1Password, Balena Etcher, Brave Browser, Burp Suite, DuckDuckGo, Firefox, iTerm2, Notion, Postman, Proton VPN, Signal, Simplenote, Sourcegraph, Spotify, Steam, Thunderbird, Todoist, VLC, VS Code, Zoom

## Configurations
- Taskwarrior, Vim, Z shell

---

*Disclaimer: Code under active development*
