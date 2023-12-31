#!/bin/bash

# PowerShell: Vim config
cat "$(pwd)/src/config-files/vim/vimrc.txt" >> ~/.vimrc

 # Install VS Code
 # TODO: Update filepath check
if [[ -f "/usr/bin/code" ]]; then
	echo "VS Code is already installed."
else
	winget -e --id Microsoft.VisualStudioCode
fi

wsl

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config --global pull.rebase false

apps=("gh" "src-cli")
for app in ${apps[@]}; do
	if [[ -f "/usr/local/bin/$app" ]]; then
		echo "$app is already installed."
	else
		sudo apt install "$app" -y
	fi
done

if [[ -f "~/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep

# Install Postman
flatpak install flathub org.getpostman.Postman -y

exit
