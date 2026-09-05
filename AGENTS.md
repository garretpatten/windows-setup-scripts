# Agent instructions

Windows 11 provisioning scripts under `src/scripts/`: Omarchy-style per-app
install/config scripts, orchestrated by `master.ps1`, `run-install.ps1`, and
`run-config.ps1`. `run-install.ps1` accepts `cli` (CLI-only) or `all` (CLI +
desktop); npm shortcuts are `npm run install:cli`, `npm run install:all`,
`npm run config`, and `npm run all`. The `src/dotfiles` submodule is maintained
separately. **Never edit, commit, or bump `src/dotfiles` from this repo** unless
the user explicitly asks. Consume it read-only via `Link-DotfilesXdgConfigDirs`
in `config/dotfiles.ps1` (symlinks each `src/dotfiles/config/<app>/` under
`%LOCALAPPDATA%` / `%APPDATA%`) and targeted file copies. `run-config.ps1` and
`master.ps1` initialize/update submodules before running config.

## Dotfiles submodule

`src/dotfiles/` is a **Git submodule** pinned to a commit of
[garretpatten/dotfiles](https://github.com/garretpatten/dotfiles).
Never edit files inside `src/dotfiles/` directly in this repository.

If a dotfiles change is needed:

1. Make the change in the `dotfiles` repository and push it.
2. In this repository, update the submodule:
   `cd src/dotfiles && git pull origin master && cd ../..`
3. Commit the submodule pointer change:
   `git add src/dotfiles && git commit -m "Bump dotfiles submodule"`

## Before you finish

**Do not consider PowerShell or workflow work complete until PSScriptAnalyzer
passes the same way local CI helpers expect.**

From the repository root:

```powershell
pwsh ./scripts/check-pssa.ps1
```

That runs PSScriptAnalyzer on **changed** `*.ps1` files vs `origin/master`.

To lint all setup scripts locally:

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
Invoke-ScriptAnalyzer -Path src/scripts -Recurse -Severity Warning,Error
```

### PowerShell conventions

- Leaf scripts under `install/` and `config/` should be plain commands; avoid
  heavy wrapper functions when a direct winget/call works.
- Orchestrators (`master.ps1`, `*/all.ps1`) dot-source `lib/Env.ps1`, `lib/Run.ps1`,
  and any other `lib/*.ps1` they need.
- Prefer `try` / `catch` with continue warnings over aborting the whole run.
- Best-effort provisioning: leaf failures should not stop the orchestrator
  (`Invoke-SetupScript` catches and continues).

### Other CI linters

`.github/workflows/quality-checks.yaml` runs Prettier, markdownlint, and yamllint on
pull requests (ShellCheck disabled — this repo is PowerShell). Prettier and
markdownlint are installed via `npm ci`; yamllint is a Python tool. Run the
relevant tools when you touch those file types:

```bash
npm ci
npx prettier --check .
npx markdownlint --ignore node_modules '**/*.md'
yamllint .
```

### Test workflow

`.github/workflows/test-runner.yaml` runs four jobs on `windows-latest`:

- `test-cli`: `run-install.ps1 cli` → `scripts/validate-installs-cli.ps1`
- `test-config`: `run-config.ps1` → `scripts/validate-config-only.ps1`
- `test-full`: `run-install.ps1 all` → `scripts/validate-installs.ps1`
- `test-master`: `master.ps1` → `scripts/validate.ps1` (full installs + config)

Windows UI settings scripts no-op without an interactive desktop session / in CI.
Docker Desktop checks are soft in CI when Docker is unavailable.

## Layout

| Path                                                        | Role                                                    |
| ----------------------------------------------------------- | ------------------------------------------------------- |
| `src/scripts/lib/Env.ps1`                                   | `PROJECT_ROOT`, `TEMP_DIR`                              |
| `src/scripts/lib/Run.ps1`                                   | `Invoke-SetupScript` helper                             |
| `src/scripts/lib/Windows-Session.ps1`                       | Skip UI config when not on a desktop session            |
| `src/scripts/lib/Git-Submodules.ps1`                        | Initialize/update submodules before config              |
| `src/scripts/install/all.ps1`                               | Full install orchestrator (`--cli` for CLI-only)        |
| `src/scripts/install/cli.ps1`                               | Wrapper that runs `install/all.ps1 --cli`               |
| `src/scripts/install/packages/*.packages`                   | Winget package ID lists (one per line)                  |
| `src/scripts/install/packages/third-party-cli.packages`     | Docker Desktop / Node.js for CLI install                |
| `src/scripts/install/packages/third-party-desktop.packages` | Brave / Bruno / Signal for full install                 |
| `src/scripts/install/apps/pass-cli.ps1`                     | Proton Pass CLI binary install                          |
| `src/scripts/lib/Winget-Packages.ps1`                       | `Install-WingetPackagesFromFile` helper                 |
| `src/scripts/install/`                                      | `packages/`, `apps/`, `dev/`, `shell/`, `post-install/` |
| `src/scripts/config/<category>/`                            | Dotfiles / Windows / firewall config + `all.ps1`        |
| `scripts/lib/Validate-InstallsSections.ps1`                 | Shared install validation sections                      |
| `scripts/lib/Validate-ConfigSections.ps1`                   | Shared config validation sections                       |
| `scripts/validate-installs-cli.ps1`                         | Validate CLI-only install outcomes                      |
| `scripts/validate-installs.ps1`                             | Validate full install outcomes                          |
| `scripts/validate-config-only.ps1`                          | Validate config-only outcomes                           |
| `scripts/validate-config.ps1`                               | Validate config after full install/master               |

## Commits

Only commit when the user asks. Do not commit secrets.
