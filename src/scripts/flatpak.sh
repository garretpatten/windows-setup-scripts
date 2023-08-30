wsl

# Install Flatpak
if [[ -f "/usr/bin/flatpak" ]]; then
	echo "flatpak is already installed."
else
	sudo apt install flatpak -y
fi

# Add remote Flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Switch from WSL to Powershell
exit

# TODO: Install Signal Messenger
winget install -e --id OpenWhisperSystems.Signal

winget install -e --id Spotify.Spotify
