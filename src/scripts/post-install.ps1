# Update system
winget upgrade -h --all

printf "\n\n============================================================================\n\n"

Out-File "src/assets/wolf.txt"

printf "\n\n============================================================================\n\n"

# End message
Write-Output "\n\n\nCheers -- system setup is now complete!"
