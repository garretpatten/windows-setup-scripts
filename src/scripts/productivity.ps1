# Install and configure Taskwarrior
$shouldInstallTaskwarrior = "wsl test -f '/home/$(wsl whoami)/.taskrc' || echo 'true'"
if ($shouldInstallTaskwarrior -eq "true") {
    wsl "sudo apt install taskwarrior -y"

    $powershellPath="$pwd"
    $wslPath = $powershellPath -replace 'C:\\', '/mnt/c/'
    $wslPath = $wslPath -replace '\\', '/'
    wsl cat "$wslPath/src/config-files/taskwarrior/.taskrc-additions" ~/.taskrc

    wsl mkdir ~/.task/themes/
    wsl cp -r "wslPath/src/config-files/taskwarrior/themes/" ~/.task/themes/

    # TODO: Set dark blue theme

    # TODO: Figure out backslashes or ticks are correct
    # Add tasks
    # High Priority Tasks
    task add "Take a snapshot of system project:setup priority:H"
    task add "Export GitHub PAT with 1Password project:dev priority:H"
    task add "Pin apps to taskbar project:setup priority:H"

    wsl task 3 annotate \
    "1Password, Bard PWA,, Brave Chat GPT PWA, File Explorer, Notion, \
    Oracle VirtualBox, Proton Calendar PWA, Proton Mail PWA, Proton VPN PWA \
    Settings, Signal, Simplenote, Spotify, Steam, Steam, Terminal, Terminal, \
    Todoist, Ubisoft Connect, VS Code, Windows PowerShell"
    # Medium Priority Tasks
    wsl task add "Sign into and sync Brave project:setup priority:M"
    wsl task add "Sign into Firefox project:setup priority:M"
    wsl task add "Customize look and feel of Windows environment"
    # Low Priority Tasks
    wsl task add "Install Burp Suite project:setup priority:L"
    wsl task add "Download files from Proton Drive project:setup priority:L"
}

# Install Simplenote
winget install -e --id Automattic.Simplenote --source winget

# Install Notion
winget install -e --id Notion.Notion --source winget

# Install Todoist
winget install -e --id Doist.Todoist --source winget
