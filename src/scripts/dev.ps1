# Configure Vim
$powershellPath="$pwd"
$wslPath = $powershellPath -replace 'C:\\', '/mnt/c/'
$wslPath = $wslPath -replace '\\', '/'
wsl cp "$wslPath/src/config-files/vim/.vimrc ~/.vimrc"

# Install and configure VS Code
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

if (Is-VSCodeInstalled) {
    Write-Host "VS Code is already installed."
} else {
    winget install --id Microsoft.VisualStudioCode -e --source winget
    Copy-Item ..\config-files\vs-code\settings.json $env:USERPROFILE\AppData\Roaming\Code\User\settings.json
}

# Configure Git
wsl "git config --global credential.helper cache"
wsl "git config --global user.email 'garret.patten@proton.me'"
wsl "git config --global user.name 'Garret Patten'"
wsl "git config --global pull.rebase false"

# Install GitHub cli
wsl "if [[ ! -f /usr/local/bin/gh ]]; then sudo apt install gh -y; fi"

# Install Node.js, npm, and npm packages
# TODO: May need to add nodejs repository
wsl "sudo apt install nodejs -y"
wsl "sudo npm install -g neovim"

# Install Ruby and gem
wsl "sudo apt install ruby-rubygems -y"
wsl "gem install neovim"

# Install Sourcegraph cli
wsl "if [[ ! -f /usr/local/bin/src-cli ]]; then sudo apt install src-cli -y; fi"

# Install Semgrep cli
wsl "if [[ ! -f ~/.local/bin/semgrep ]]; then python3 -m pip install semgrep; fi"

# Install Postman
winget install -e --id Postman.Postman --source winget
