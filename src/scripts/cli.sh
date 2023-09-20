wsl

cd

# Install CLI tools on Windows Subsystem for Linux
cliTools=("bat" "curl" "exa" "git" "htop" "neofetch" "openvpn" "poppler-utils" "wget")
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool/" ]]; then
		echo "$cliTool is already installed."
	elif [ -f "/usr/sbin/$cliTool"]; then
		echo "$cliTool is already installed."
	else
		sudo apt install "$cliTool" -y
	fi
done

exit
