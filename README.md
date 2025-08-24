# Windows Setup Scripts

Automated Windows 11 environment bootstrap using PowerShell and `winget`.

These scripts install CLI tools, developer runtimes, security software, productivity apps, and create a consistent folder structure. They are designed for repeatable workstation setup on fresh Windows systems.

---

## Requirements

- **Windows 11** with latest updates  
- **PowerShell 7+** (install via [Microsoft Store](https://apps.microsoft.com/detail/9MZ1SNWT0N5D) or `winget install -e --id Microsoft.PowerShell`)  
- **winget** package manager (ships with Windows 11)

Optional:

- **WSL** (for Linux tooling, zsh, tmux, etc.) — `wsl --install`  
- **npm** (for Angular CLI, tree-sitter-cli) — comes with Node.js install

---

## Usage

Clone the repo and initialize submodules for `dotfiles`:

```powershell
git clone https://github.com/<your-username>/windows-setup-scripts.git
cd windows-setup-scripts
git submodule update --init --recursive
```

Run the master script:

```powershell
cd src/scripts
pwsh ./master.ps1
```

By default, `master.ps1` runs all category scripts. Use flags to skip:

```powershell
pwsh ./master.ps1 -SkipMedia -SkipProductivity
```

Run with `-WithWSL` to also install WSL + Ubuntu.

## Script Categories

- `cli.ps1` — Core CLI tools (git, ripgrep, fd, bat, jq, etc.)
- `dev.ps1` — Developer runtimes (node, python, gh, neovim, docker, src-cli, semgrep) and IDEs (VS Code, Postman). Configures VS Code settings and Neovim packer.
- `web.ps1` — Browsers (brave, duckduckgo)
- `media.ps1` — Media apps (spotify, vlc)
- `productivity.ps1` — Productivity apps (chatgpt, notion, protondrive, zoom)
- `security.ps1` — Security/networking (1Password, 1Password CLI, nmap, openvpn, burp, zap, protonvpn, signal, exiftool)
- `shell.ps1` — Windows Terminal, Oh My Posh, fonts (manual for Nerd Fonts)
- `wsl.ps1` — Installs WSL + Ubuntu 24.04, suggests installing zsh and tmux inside
- `organizeHome.ps1` — Creates standard folders (Code, Tools, Security, Media, tmp)

## Notes

- Fonts: Fonts: Nerd Fonts (Meslo, Hack) are not reliably distributed via winget. Install manually from [Nerd Fonts releases](https://www.nerdfonts.com/).
- Tree-sitter CLI and Angular CLI are installed via npm globally.
- ShellCheck is available via winget but most advanced shell tooling is better run inside WSL.
- Some GUI apps (ChatGPT, Spotify) come from the Microsoft Store; the scripts handle this with `-s msstore`.

## Example One-Shot Setup

```powershell
pwsh ./master.ps1 -WithWSL
```

This installs everything, plus WSL and Ubuntu, then organizes your home folders.

## Uninstall/Cleanup

Uninstall apps via `winget uninstall --id <PackageId>` or Windows Settings > Apps.
Remove created folders manually if not needed.

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

*For questions, bug reports, or feature requests, please open an issue on this repository or contact the maintainer directly.*

## License

This project is licensed under the [MIT License](./LICENSE).
