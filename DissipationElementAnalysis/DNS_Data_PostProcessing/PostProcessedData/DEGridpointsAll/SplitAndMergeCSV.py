#!/usr/bin/env python3

import os
import sys
import math
import pandas as pd

def split_csv_by_rows(input_csv, output_dir, max_rows=500):
    os.makedirs(output_dir, exist_ok=True)
    df = pd.read_csv(input_csv)
    total_rows = df.shape[0]
    num_files = math.ceil(total_rows / max_rows)

    for i in range(num_files):
        start_row = i * max_rows
        end_row = start_row + max_rows
        chunk = df.iloc[start_row:end_row]
        chunk.to_csv(f"{output_dir}/rows_part_{i+1}.csv", index=False)
        print(f"Saved: rows_part_{i+1}.csv with rows {start_row+1} to {min(end_row, total_rows)}")

def merge_row_chunks(input_dir, output_csv):
    files = sorted([f for f in os.listdir(input_dir) if f.startswith("DEGridpointsAll_") and f.endswith(".csv")])
    files = sorted(files, key=lambda x: int(x.split('_')[-1].split('.')[0]))
    print(files)
    dfs = [pd.read_csv(os.path.join(input_dir, f)) for f in files]
    merged_df = pd.concat(dfs, axis=0)
    merged_df.to_csv(output_csv, index=False)
    print(f"Merged back to: {output_csv}")

# Example usage
input_csv = sys.argv[1]
split_dir = sys.argv[2]
merged_csv = sys.argv[3]

#split_csv_by_rows(input_csv, split_dir)
merge_row_chunks(split_dir, merged_csv)
