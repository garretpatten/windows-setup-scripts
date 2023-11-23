wsl

# Install taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	echo "Taskwarrior is already installed."
else
	sudo apt install taskwarrior -y
fi

# Taskwarrior config
cat "$(pwd)/src/config-files/taskwarrior/taskrcUpdates.txt" >> ~/.taskrc

# Add directory for custom themes
if [[ -d "~/.task/themes/" ]]; then
	echo "Taskwarrior themes directory already exists."
else
	mkdir ~/.task/themes/
fi

### TODO: Update this from copying an artifact to pulling themes from GitHub ###
# Add custom themes to directory
cp -r "$(pwd)/src/config-files/taskwarrior/themes/" ~/.task/themes/

# TODO: Set dark blue theme

exit

# TODO: Update filepaths
# Install Simplenote, Notino, Todoist
apps=("Automattic.Simplenote" "Doist.Todoist" "Notion.Notion")
for app in ${apps[@]}; do
	if [[ -d "/var/lib/flatpak/app/$apps" ]]; then
		echo "$apps is already installed."
	elif [[ -d "~/.local/share/flatpak/app/$flatpakApp" ]]; then
		echo "$apps is already installed."
	else
		winget install -e --id "$app" -y
	fi
done
