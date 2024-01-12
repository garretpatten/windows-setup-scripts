# Install zsh
wsl "if [[ ! -f "/usr/bin/zsh" ]]; then sudo apt install zsh -y; fi"

# Change default user shells to zsh
wsl chsh -s $(which zsh)
wsl sudo chsh -s $(which zsh)

# Install oh my zsh and configure shell
$shouldInstallOhMyZsh = "wsl test -d '/home/$(wsl whoami)/.oh-my-zsh' || echo 'true'"
if ($shouldInstallOhMyZsh -eq "true") {
    wsl sh -c "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh `
    && cd ~/.oh-my-zsh/custom/plugins `
    && git clone https://github.com/zsh-users/zsh-autosuggestions.git `
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git"

    $powershellPath="$pwd"
    $wslPath = $powershellPath -replace 'C:\\', '/mnt/c/'
    $wslPath = $wslPath -replace '\\', '/'
    wsl cp "$wslPath/src/config-files/zsh/.zshrc ~/.zshrc"
}
