#!/bin/bash

# Add non-automated tasks to Taskwarrior
if [[ -f "/usr/bin/task" ]]; then
	# High Priority Tasks
	task add Take a snapshot of system project:setup priority:H
	task add Export GitHub PAT with 1Password project:dev priority:H
 	task add Pin apps to taskbar project:setup priority:H

  	task 3 annotate \
   	1Password, Bard PWA, Chat GPT PWA, File Explorer, Microsoft Edge, \
   	Notion, PowerShell Proton VPN, Signal, Simplenote, Spotify, Steam, \
    	Terminal, Todoist, VS Code

	# Medium Priority Tasks
	task add Sign into and sync Brave project:setup priority:M
	task add Sign into Firefox project:setup priority:M
	task add Customize look and feel of Windows environment

	# Low Priority Tasks
	task add Install Burp Suite project:setup priority:L
	task add Download files from Proton Drive project:setup priority:L
else
	echo "Taskwarrior is not installed. Please install Taskwarrior and re-run the addTasks script."
fi
