#!/bin/bash

source_dir="1_FilesFromSciebo"
destination_dir="2_MergedFromSciebo/FilesFromSciebo"
mkdir -p "$destination_dir"

find "$source_dir" -type f -exec cp {} "$destination_dir" \;
echo "All files have been moved to $destination_dir"
