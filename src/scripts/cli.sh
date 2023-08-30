# Install basic CLI tools for Powershell
powershellCliTools=("sharkdp.bat" "GitHub.cli" "nepnep.neofetch-win" "OpenVPNTechnologies.OpenVPN")
for powershellCliTool in ${powershellCliTools[@]}; do
	# TODO: Update filepath checks
	if [[ -d "/usr/bin/$powershellCliTool/" ]]; then
		echo "$powershellCliTool is already installed."
	elif [ -f "/usr/sbin/$powershellCliTool"]; then
		echo "$powershellCliTool is already installed."
	else
		winget install "$powershellCliTool"
	fi
done

winget install -e --id Python.Python.3.8

wsl

# Install basic CLI tools on Windows Subsystem for Linux
cliTools=("bat" "curl" "exa" "git" "https" "htop" "neofetch" "openvpn" "wget")
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
