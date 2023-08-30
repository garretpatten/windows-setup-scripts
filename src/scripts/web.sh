# Install Brave, DuckDuckGo, Firefox
apps=("Brave.Brave" "DuckDuckGo.DesktopBrowser" "Mozilla.Firefox")
for app in ${apps[@]}; do
	if [[ -d "/var/lib/flatpak/app/$apps" ]]; then
		echo "$apps is already installed."
	elif [[ -d "~/.local/share/flatpak/app/$flatpakApp" ]]; then
		echo "$apps is already installed."
	else
		winget install -e --id Automattic.Simplenote "$app" -y
	fi
done
