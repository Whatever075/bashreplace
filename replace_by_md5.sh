#!/bin/bash

# Function to calculate the MD5 checksum of a file
calculate_md5() {
    md5sum "$1" | awk '{print $1}'
}

# Check if the number of arguments provided is correct
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <directory> <md5_checksum> <replacement_file>"
    exit 1
fi

# Assign arguments to variables
directory="$1"
md5_checksum="$2"
replacement_file="$3"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory $directory does not exist."
    exit 1
fi

# Find files with the specified MD5 checksum and replace them
find "$directory" -type f -exec bash -c '
    for file; do
        if [ "$(calculate_md5 "$file")" = '"$md5_checksum"' ]; then
            echo "Replacing $file with $replacement_file"
            mv "$replacement_file" "$file"
        fi
    done
' bash {} +
