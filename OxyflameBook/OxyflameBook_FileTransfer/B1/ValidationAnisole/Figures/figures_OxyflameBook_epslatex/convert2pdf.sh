#!/bin/bash

# Directory containing the EPS files (you can modify this to point to your directory)
DIRECTORY="."

# Loop through all .eps files in the directory
for eps_file in "$DIRECTORY"/*.eps; do
    # Check if the file exists (handles the case where no EPS files are found)
    if [ -f "$eps_file" ]; then
        # Check if the file name ends with "-inc.eps"
        if [[ "$eps_file" != *-inc.eps ]]; then
            # Generate the output PDF filename
            pdf_file="${eps_file%.eps}.pdf"

            # Convert EPS to PDF with ps2pdf and -dEPSCrop option
            ps2pdf -dEPSCrop "$eps_file" "$pdf_file"

            echo "Converted $eps_file to $pdf_file"
        else
            echo "Skipped $eps_file"
        fi
    else
        echo "No EPS files found in the directory."
        exit 1
    fi
done

