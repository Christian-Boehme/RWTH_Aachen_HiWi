#!/usr/bin/env python3

import os
import sys
import pandas as pd

# How to run this script?
# python3 PP_WU.py ExampleFolder
# => creates file "Molefraction.txt" = gnuplot input

files = []
filename = sys.argv[1] + '/Molefraction.txt'
path = sys.argv[1] + '/' + '/output'
initial = True
with open(filename, 'w') as out:
    for f in os.listdir(path):
        if f.startswith('X1_'):
            files.append(f)
    files = sorted(files)
    #print('FILES ARE: ', files)
    for f in files:
        #print(f)
        temp = float(f.split('.')[0].split('to')[1])
        df = pd.read_csv(path + '/' + f, sep=r'\s+',
                         skiprows=[0], low_memory=False)
        row = df.shape[0] - 1
        if row == 0:
            sys.exit()
        if initial:
            initial = False
            # write header line to file
            header = list(df.columns)
            header.insert(0, 'Temp[K]')
            # max length of element in header line
            mlen = max(len(x) for x in header)
            if mlen >= 13:
                mlen = 15
            for col in header:
                out.write('{:<11}   '.format(col))
            out.write('HEADER\n')
        # write to file
        # replace values < 0 with 0
        df[df < 0] = 0
        out.write('{:.5E}   '.format(temp))
        for col in range(df.shape[1] - 1):
            out.write('{:.5E}   '.format(df.iat[row, col]))
        out.write('{:.5E}\n'.format(df.iat[row, df.shape[1] - 1]))
