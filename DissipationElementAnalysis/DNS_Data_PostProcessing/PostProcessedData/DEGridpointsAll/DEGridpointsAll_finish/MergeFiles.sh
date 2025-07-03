#!/bin/bash

read -p "Enter the base name of the original file (e.g., data.csv): " input_file

# Remove extension to get base name
base_name=$(basename "$input_file" .csv)

# Output filename
output_file="${base_name}_merged.csv"

# Get and write the header from the first split file
first_file=$(ls ${base_name}_splitted_*.csv | sort | head -n 1)
head -n 1 "$first_file" > "$output_file"

# Append all rows from each split file, skipping their headers
for file in $(ls ${base_name}_splitted_*.csv | sort); do
    tail -n +2 "$file" >> "$output_file"
    echo "Appended: $file"
done

echo "Merged into: $output_file"
