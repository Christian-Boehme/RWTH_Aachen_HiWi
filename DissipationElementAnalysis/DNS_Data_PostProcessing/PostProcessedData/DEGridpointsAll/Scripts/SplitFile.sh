#!/bin/bash

read -p "Enter the CSV file to split: " input_file
lines_per_file=500
output_suffix="_splitted_"

if [[ ! -f "$input_file" ]]; then
  echo "File '$input_file' not found!"
  exit 1
fi

# Extract filename without extension
base_name=$(basename "$input_file" .csv)

# Extract header
header=$(head -n 1 "$input_file")

# Total number of lines excluding header
total_lines=$(tail -n +2 "$input_file" | wc -l)

# Calculate number of chunks
chunks=$(( (total_lines + lines_per_file - 1) / lines_per_file ))

# Start splitting
tail -n +2 "$input_file" | split -l $lines_per_file - tmp_split_

# Rename and add header to each split file with numeric suffix
count=1
for file in tmp_split_*; do
    printf -v num "%02d" $count
    new_file="${base_name}${output_suffix}${num}.csv"

    echo "$header" > "$new_file"
    cat "$file" >> "$new_file"
    rm "$file"

    echo "Created $new_file"
    ((count++))
done

echo "Done! Created $((count-1)) files."
