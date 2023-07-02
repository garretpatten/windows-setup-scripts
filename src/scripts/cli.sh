cliTools=("bat" "curl" "exa" "git" "https" "htop" "neofetch" "openvpn" "wget")
for cliTool in ${cliTools[@]}; do
	# TODO: Update filepath checks
	if [[ -d "/usr/bin/$cliTool/" ]]; then
		echo "$cliTool is already installed."
	elif [ -f "/usr/sbin/$cliTool"]; then
		echo "$cliTool is already installed."
	else
		winget install "$cliTool"
	fi
done

winget install -e --id Python.Python.3.8

# Switch to Windows Subsystem for Linux
wsl

# Install basic CLI tools on Windows Subsystem for Linux
for cliTool in ${cliTools[@]}; do
	if [[ -d "/usr/bin/$cliTool/" ]]; then
		echo "$cliTool is already installed."
	elif [ -f "/usr/sbin/$cliTool"]; then
		echo "$cliTool is already installed."
	else
		sudo apt install "$cliTool" -y
	fi
done

# Switch to Powershell
exit
