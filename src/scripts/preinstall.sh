#!/bin/bash

# Allow Script Execution
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# System Updates
winget upgrade -h --all
wsl
sudo apt upgrade -y && sudo apt update-y && sudo apt autoremove -y
exit
