#!/bin/bash

# Add needed directories
directoriesToCreate=("Repositories")
for directoryToCreate in ${directoriesToCreate[@]}; do
	if [[ -d "~/$directoryToCreate/" ]]; then
		echo "~/$directoryToCreate is already created."
	else
		mkdir "~/$directoryToCreate"
	fi
done
