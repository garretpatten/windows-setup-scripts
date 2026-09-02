#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# Core toolchain
'node','go','python312','gh','neovim','docker','srccli','semgrep','shellcheck','nvm','cursor','rustup','ollama','ruby' |
  ForEach-Object { Install-Pkg $_ }

# VS Code
Install-Winget -Id 'Microsoft.VisualStudioCode'

# Neovim: packer bootstrap
$packerPath = Join-Path $HOME "AppData\Local\nvim-data\site\pack\packer\start\packer.nvim"
if (-not (Test-Path $packerPath)) {
  git clone --depth 1 https://github.com/wbthomason/packer.nvim $packerPath 2>$null | Out-Null
}

# Shared Git pre-commit hook path (hooks live in the dotfiles config/githooks symlink)
$githooksDir = Join-Path $HOME ".config\githooks"
$githooksUnix = $githooksDir -replace '\\', '/'
if (-not (git config --global core.hooksPath 2>$null)) {
  git config --global core.hooksPath $githooksUnix
}
git config --global credential.helper manager

# Git baseline if missing
if (-not (Test-Path (Join-Path $HOME ".gitconfig"))) {
  git config --global http.postBuffer 157286400
  git config --global pack.window 1
  git config --global user.email "garret.patten@proton.me"
  git config --global user.name "Garret Patten"
  git config --global pull.rebase false
  git config --global init.defaultBranch main
}

# Node-based tooling (matches ubuntu-setup-scripts language-servers.sh and vue-cli.sh)
if (Test-Cmd node) {
  npm i -g @vue/cli
  npm i -g bash-language-server pyright typescript-language-server yaml-language-server
}

# Ruby gems
if (Test-Cmd gem) {
  gem install --user-install solargraph
}

# Language servers available via winget
Install-Winget -Id 'LuaLS.lua-language-server'
