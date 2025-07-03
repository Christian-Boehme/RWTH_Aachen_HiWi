#!/usr/bin/env python3

import os
import sys
import pandas as pd

# How to run this script?
# python3 PP_Alzueta.py ExampleFolder
# output files can be used as input (gnuplot)

# Consider the following sets from Alzueta et al.
sets = {'Set_1': 200,
        'Set_2': 204,
        'Set_3': 206,
        'Set_4': 204,
        'Set_5': 200,
        'Set_6': 205,
        'Set_7': 205,
        'Set_8': 206}

#
for i in sets.keys():
    files = []
    filename = sys.argv[1] + '/Results_' + i
    path = sys.argv[1] + '/' + i + '/output'
    head = False
    with open(filename, 'w') as out:
        for f in os.listdir(path):
            if f.startswith('X1_'):
                files.append(f)
        files = sorted(files)
        for f in files:
            temp = float(f.split('.')[0].split('to')[1])
            res_time = float(sets[i]) / temp * 1000  # [ms]
            df = pd.read_csv(path + '/' + f, sep=r'\s+',
                             skiprows=[0], low_memory=False)
            row = 0
            for idx in range(df.shape[0] - 1):
                if df['t[ms]'][idx] <= res_time <= df['t[ms]'][idx + 1]:
                    row = idx  # (df['t[ms]'][idx])
                    break
            if row == 0:
                row = df.shape[0] - 1
            if head is False:
                head = True
                # lowest temperature - write header line to file
                header = list(df.columns)
                # max length of element in header line
                mlen = max(len(x) for x in header)
                if mlen >= 13:
                    mlen = 15
                for col in header:
                    out.write('{:<11}   '.format(col))
                out.write('\n')
            # replace values < 0 with 0
            df[df < 0] = 0
            for col in range(df.shape[1] - 1):
                out.write('{:.5E}   '.format(df.iat[row, col]))
            out.write('{:.5E}\n'.format(df.iat[row, df.shape[1] - 1]))
