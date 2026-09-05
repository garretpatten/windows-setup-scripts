#Requires -Version 7
$ErrorActionPreference = 'Continue'
$homeDot = Join-Path $env:PROJECT_ROOT 'src/dotfiles/home'
foreach ($name in @('.tmux.conf', '.zshrc', '.bashrc', '.vimrc')) {
    $src = Join-Path $homeDot $name
    $dst = Join-Path $HOME $name
    if ((Test-Path $src) -and -not (Test-Path $dst)) {
        Copy-Item $src $dst
    }
}
