#Requires -Version 7
. "$PSScriptRoot/utils.ps1"

# Symlink XDG-style config dirs from src/dotfiles/config/<app>/ to the
# equivalent Windows config location (LocalAppData or AppData).
$configRoot = Join-Path $Global:DotfilesRoot 'config'
if (Test-Path $configRoot) {
  Get-ChildItem -Path $configRoot -Directory | ForEach-Object {
    Install-DotfilesConfigDir $_.Name
  }
}

# Home file copies (mirror ubuntu-setup-scripts dotfiles.manifest and dotfiles-zshrc.sh)
Install-DotfilesHomeFile '.vimrc'
Install-DotfilesHomeFile '.bashrc'
Install-DotfilesHomeFile '.zshrc'
Install-DotfilesHomeFile '.tmux.conf'

# VS Code: copy rather than symlink because the editor manages the file
$vsCodeSettingsSrc = Join-Path $Global:DotfilesRoot 'vs-code\settings.json'
$vsCodeSettingsDst = Join-Path $env:APPDATA 'Code\User\settings.json'
Copy-IfMissing $vsCodeSettingsSrc $vsCodeSettingsDst
