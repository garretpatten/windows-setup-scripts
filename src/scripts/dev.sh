#!/bin/bash

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI && Sourcegraph CLI
winget install -e --id GitHub.cli

# TODO: Install Semgrep
winget install -e --id Python.Python.3.8

# TODO: Update filepath check
if [[ -f "~/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep
 fi

 # Install VS Code
 # TODO: Update filepath check
if [[ -f "/usr/bin/code" ]]; then
	echo "VS Code is already installed."
else		
	winget -e --id Microsoft.VisualStudioCode
fi

# Switch to Windows Subsystem for Linux
wsl

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install GitHub CLI && Sourcegraph CLI
winget install -e --id GitHub.cli

apps=("gh" "src-cli")
for app in ${apps[@]}; do
	if [[ -f "/usr/local/bin/$app" ]]; then
		echo "$app is already installed."
	else
		apt install "$app" -y
	fi
done

if [[ -f "~/.local/bin/semgrep" ]]; then
	echo "Semgrep is already installed."
else
	python3 -m pip install semgrep

# Install Postman
flatpak install flathub org.getpostman.Postman -y

# Switch to Powershell
exit
