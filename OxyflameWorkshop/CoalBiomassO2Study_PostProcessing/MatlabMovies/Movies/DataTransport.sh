#!/bin/bash


# Check for input argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_folder>"
    exit 1
fi

# Input and output paths
SOURCE_DIR="$1"
DEST_DIR="${SOURCE_DIR%/}_filtered_copy"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# Create the destination directory
mkdir -p "$DEST_DIR"

# Function to copy the specified files
copy_files() {
    local src_dir="$1"
    local dest_dir="$2"

    # Create the destination subdirectory
    mkdir -p "$dest_dir"

    # Get a list of all .png files in the current directory
    png_files=("$src_dir"/*.png)
    total_pngs=${#png_files[@]}

    # If there are no PNG files, skip to non-PNG file copying
    if (( total_pngs > 0 )); then
        # Copy the first PNG file
        cp "${png_files[0]}" "$dest_dir/"

        # Copy every 50th PNG file, starting from the 50th element
        for (( i = 9; i < total_pngs; i += 10 )); do
            cp "${png_files[i]}" "$dest_dir/"
        done

        # Copy the last PNG file if it's not the same as the first or already copied
        if (( total_pngs > 1 )); then
            cp "${png_files[-1]}" "$dest_dir/"
        fi
    fi

    # Copy all non-PNG files in the current directory
    for item in "$src_dir"/*; do
        if [ -d "$item" ]; then
            # If item is a directory, recursively call the function
            copy_files "$item" "$dest_dir/$(basename "$item")"
        elif [ -f "$item" ] && [[ "$item" != *.png ]]; then
            # Copy non-PNG files
            if [ -f "$item" ] && [[ "$item" != *.avi ]]; then
                cp "$item" "$dest_dir/"
            fi
        fi
    done
}

# Start the copying process
copy_files "$SOURCE_DIR" "$DEST_DIR"

echo "Copying complete. New directory created at: $DEST_DIR"
