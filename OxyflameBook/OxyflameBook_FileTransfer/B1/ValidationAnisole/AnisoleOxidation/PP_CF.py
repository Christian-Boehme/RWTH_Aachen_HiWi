#!/usr/bin/env python3

import re
import sys
import csv

# How to use this script?
# python3 PP_CF.py <your_filename>.kg
# => creates a .csv -> can be used for plotting

filename_input = sys.argv[1]
filename_output = sys.argv[1][0:len(sys.argv[1])-3] + '.csv'
data = []

with open(filename_input, 'r') as in_file:
    buf1 = in_file.readlines()

with open(filename_output, 'w') as out_file:
    for line in buf1:
        data.append(line.strip().split('\t'))
    writer = csv.writer(out_file)
    writer.writerows(data)


with open(filename_output, 'r') as in_file:
    buf2 = in_file.readlines()

with open(filename_output, 'w') as out_file:
    for line in buf2:
        if '*' in line:
            if '[' in line:
                line = re.sub(r' \[(.*?)\]', '', line)
                line = line.replace(',,', '\t')
                line = line.replace('Y-', 'Y_')
                line = line.replace('X-', 'X_')
                out_file.write(line)
        if '*' not in line:
            if 'temp' not in line:
                out_file.write(line)
            if '[' in line:
                line = re.sub(r' \[(.*?)\]', '', line)
                line = line.replace('Y-', 'Y_')
                line = line.replace('X-', 'X_')
                out_file.write(line)

with open(filename_output, 'r') as in_file:
    buf3 = in_file.readlines()

with open(filename_output, 'w') as out_file:
    for line in buf3:
        line = line.replace(',', '\t')
        out_file.write(line)
