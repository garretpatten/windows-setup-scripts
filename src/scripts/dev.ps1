#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# Core toolchain
'node','python312','gh','neovim','docker','srccli','semgrep','shellcheck','nvm' |
  ForEach-Object { Install-Pkg $_ }

# VS Code
Install-Winget -Id 'Microsoft.VisualStudioCode'

# VS Code settings
$repoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
$vsCodeSettingsSrc = Join-Path $repoRoot "src/dotfiles/vs-code/settings.json"
$vsCodeSettingsDst = Join-Path $env:APPDATA "Code\User\settings.json"
Copy-IfMissing $vsCodeSettingsSrc $vsCodeSettingsDst

# Neovim: packer bootstrap
$packerPath = Join-Path $HOME "AppData\Local\nvim-data\site\pack\packer\start\packer.nvim"
if (-not (Test-Path $packerPath)) {
  git clone --depth 1 https://github.com/wbthomason/packer.nvim $packerPath 2>$null | Out-Null
}

# Shared Git pre-commit hook
$githooksDir = Join-Path $HOME ".config\githooks"
$preCommitSrc = Join-Path $repoRoot "src\dotfiles\config\githooks\pre-commit"
$preCommitPs1Src = Join-Path $repoRoot "src\dotfiles\config\githooks\pre-commit.ps1"
$preCommitDst = Join-Path $githooksDir "pre-commit"
$preCommitPs1Dst = Join-Path $githooksDir "pre-commit.ps1"
Ensure-Dir $githooksDir
Copy-IfMissing $preCommitSrc $preCommitDst
Copy-IfMissing $preCommitPs1Src $preCommitPs1Dst

git config --global core.hooksPath 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  $githooksUnix = $githooksDir -replace '\\', '/'
  git config --global core.hooksPath $githooksUnix
}

# Git baseline if missing
if (-not (Test-Path (Join-Path $HOME ".gitconfig"))) {
  git config --global credential.helper manager
  git config --global http.postBuffer 157286400
  git config --global pack.window 1
  git config --global pull.rebase false
}

# Language servers for opencode
Install-Winget -Id 'LuaLS.lua-language-server'
if (Test-Cmd node) {
  npm i -g @angular/cli
  npm i -g tree-sitter-cli
  npm i -g bash-language-server pyright typescript-language-server yaml-language-server
}

