# Windows setup scripts

Provisioning for a personal Windows 11 desktop: install scripts under
`src/scripts/install/`, dotfiles and system config under `src/scripts/config/`,
orchestrated by `master.ps1`. Mirrors the layout and app set of
[ubuntu-setup-scripts](https://github.com/garretpatten/ubuntu-setup-scripts).

```bash
npm run all             # install + config
npm run install:cli     # CLI-only install
npm run install:all     # full install (CLI + desktop)
npm run config          # config only (ensures submodules are up to date)
```

Direct PowerShell equivalents (from `src/scripts/`):

```powershell
pwsh ./master.ps1
pwsh ./run-install.ps1 cli
pwsh ./run-install.ps1 all
pwsh ./run-config.ps1
```

CI runs four jobs on `windows-latest`:

- `test-cli`: `run-install.ps1 cli` → `validate-installs-cli.ps1`
- `test-config`: `run-config.ps1` → `validate-config-only.ps1`
- `test-full`: `run-install.ps1 all` → `validate-installs.ps1`
- `test-master`: `master.ps1` → `validate.ps1` (full installs + config)

Each validation script confirms the expected binaries/packages and config outcomes
for that run mode.

## Package manager preference

Each app uses one install path:

1. **winget** when the package is available (preferred)
2. **Microsoft Store via winget** when that is the published channel
3. **Upstream binary / installer** only when neither applies (pass-cli, some fonts)

## Install layout

| Path                          | Role                                                                  |
| ----------------------------- | --------------------------------------------------------------------- |
| `install/preflight/`          | winget source update, essentials (Git, PowerShell), timezone          |
| `install/all.ps1`             | Full install orchestrator (`--cli` for CLI-only mode)                 |
| `install/cli.ps1`             | Thin wrapper that runs `install/all.ps1 --cli`                        |
| `install/packages/*.packages` | One winget package ID per line; installed by `install/all.ps1`        |
| `install/store-apps.txt`      | Extra desktop apps (Zoom, ZAP) installed by `install/apps/store-apps` |
| `install/apps/`               | App-specific installers (Chrome, Etcher, Proton, pass-cli, clones)    |
| `install/dev/`                | nvm, LSP stacks, rustup, gems, npm tools, Cursor Agent, Ollama        |
| `install/shell/`              | Ghostty (best-effort), Meslo font, Oh My Posh                         |
| `install/post-install/`       | cleanup, Docker service, tldr cache, completion banner                |

### Validation scripts (`scripts/`)

| Script                      | Use with                                    |
| --------------------------- | ------------------------------------------- |
| `validate-installs-cli.ps1` | After `run-install.ps1 cli`                 |
| `validate-installs.ps1`     | After `run-install.ps1 all` or `master.ps1` |
| `validate-config-only.ps1`  | After `run-config.ps1`                      |
| `validate-config.ps1`       | After `master.ps1` or full install + config |
| `validate.ps1`              | After `master.ps1` (installs + config)      |

### Package lists (`install/packages/`)

| File                           | Contents                                                          |
| ------------------------------ | ----------------------------------------------------------------- |
| `base.packages`                | CLI and security tools (bat, fzf, gh, jq, ripgrep, tldr, nmap, …) |
| `shell.packages`               | Windows Terminal, Oh My Posh                                      |
| `media.packages`               | VLC, FFmpeg                                                       |
| `desktop.packages`             | Reserved (no GNOME equivalents)                                   |
| `productivity.packages`        | LibreOffice, KeePassXC, Flameshot                                 |
| `lsp.packages`                 | Go, Ruby, OpenJDK, Lua language server                            |
| `lsp-optional.packages`        | Optional language runtimes                                        |
| `dev.packages`                 | Neovim, Python                                                    |
| `third-party-cli.packages`     | Docker Desktop, Node.js LTS                                       |
| `third-party-desktop.packages` | Brave, Bruno, Signal                                              |

### Apps (`install/apps/`)

Brave, Chrome, Signal, Proton VPN/Pass, Bruno, Zoom, Etcher, OWASP ZAP,
Hacking git clones — each script handles its own winget ID or binary when lists
are not enough.

### Development (`install/dev/`)

Node.js, nvm, Docker Desktop, rustup, Solargraph gem, Semgrep, Vue CLI, Cursor
Agent CLI, Ollama, language servers.

### Preflight & post-install

- winget source update, Git/PowerShell essentials, timezone (Eastern when UTC)
- Docker service start attempt; firewall rules in `config/security/` (LocalSend)

## Explicitly not installed

These are **not** provisioned by this repo (remove from old notes if you still
expect them):

| Removed / never included                    | Notes                                                         |
| ------------------------------------------- | ------------------------------------------------------------- |
| **Postman**                                 | Replaced by **Bruno**                                         |
| **Sourcegraph CLI (`sg`)**                  | Removed; use Bruno or other tooling                           |
| **Spotify**                                 | Not provisioned; install manually if needed                   |
| Full IDE bundles (VS Code, JetBrains, etc.) | Dotfiles may reference extensions; install editors separately |
| 1Password, Bitwarden, etc.                  | Use Proton Pass / KeePassXC paths above                       |
| DuckDuckGo Desktop, Notion, ChatGPT Store   | Not in the Ubuntu mirror set                                  |

## Configuration (`src/scripts/config/`)

Symlinks and settings from `src/dotfiles` (submodule, read-only): `config/dotfiles.ps1`
symlinks each `config/<app>/` tree under `%LOCALAPPDATA%` or `%APPDATA%`; copies for
shell home files and VS Code settings. Covers Neovim, btop, fastfetch, terminals,
Git Credential Manager, Windows UI prefs (skipped in CI without a desktop session),
firewall rules (LocalSend), home directory layout.

See [AGENTS.md](AGENTS.md) for contributor conventions, PSScriptAnalyzer, and CI details.
