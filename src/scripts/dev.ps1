# PowerShell: Vim config
$powershellPath="$pwd"
$wslPath = $powershellPath -replace 'C:\\', '/mnt/c/'
$wslPath = $wslPath -replace '\\', '/'
wsl cp "$wslPath/src/config-files/vim/.vimrc ~/.vimrc"

# Install VS Code
function Is-VSCodeInstalled {
    $vscodePaths = @(
        "${env:ProgramFiles}\Microsoft VS Code\Code.exe",
        "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe",
        "${env:LocalAppData}\Programs\Microsoft VS Code\Code.exe"
    )

    foreach ($path in $vscodePaths) {
        if (Test-Path $path) {
            return $true
        }
    }

    return $false
}

# Check if VS Code is installed
if (Is-VSCodeInstalled) {
    Write-Host "VS Code is already installed."
} else {
    # Install VS Code using winget
    winget install --id Microsoft.VisualStudioCode -e --source winget
}

# Git config
wsl "git config --global credential.helper cache"
wsl "git config --global user.email 'garret.patten@proton.me'"
wsl "git config --global user.name 'Garret Patten'"
wsl "git config --global pull.rebase false"

# GitHub CLI
wsl "if [[ ! -f /usr/local/bin/gh ]]; then sudo apt install gh -y; fi"

# Soucegraph CLI
wsl "if [[ ! -f /usr/local/bin/src-cli ]]; then sudo apt install src-cli -y; fi"

# Semgrep CLI
wsl "if [[ ! -f ~/.local/bin/semgrep ]]; then python3 -m pip install semgrep; fi"

# Install Postman
winget install -e --id Postman.Postman --source winget
