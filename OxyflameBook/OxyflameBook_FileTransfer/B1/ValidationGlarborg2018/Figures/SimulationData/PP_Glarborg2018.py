#!/usr/bin/env python3

import os
import sys
import shutil
import pandas as pd

# How to run the script?
# python3 PP_Glarborf2018.py ExampleFolder

def rename_header(f, new_header):
    df = pd.read_csv(f, sep='\t')
    if df.columns[0] == '0':
        for i in range(len(new_header)):
            df.columns.values[i] = new_header[i]
        df.to_csv(f, sep='\t', float_format='%.5E', index=False)
    df = df.fillna(0)
    df.to_csv(f + '.txt', sep='\t', float_format='%.5E', index=False)
    
# file path
path = sys.argv[1]
if not path.endswith('/'):
    path = path + '/'

# read all files
files = []
for f in os.listdir(path):
    if not f.endswith('.txt'):
        files.append(path + f)

# create output folder
outdir = path + 'Unmodified/'
if not os.path.exists(outdir):
    os.makedirs(outdir)

sfiles = sorted(files)
for f in sfiles:
    if f == path + 'PlotNOxOut_JSR_1':
        rename_header(f, ['T[K]_0', 'X-NO_0'])
    elif f == path + 'PlotN2O_JSR_1':
        rename_header(f, ['T[K]_0', 'X-NO_0'])
    elif f == path + 'PlotN2O_JSR_2':
        rename_header(f, ['T[K]_0', 'X-N2O_0'])
    elif f == path + 'CHPlotLam1':
        rename_header(f, ['x[cm]_0', 'X-CH_0', 'x[cm]_1', 'X-CH_1', 'x[cm]_2', 'X-CH_2'])
    elif f == path + 'CHPlotLam2':
        rename_header(f, ['x[cm]_0', 'X-NO_0', 'x[cm]_1', 'X-NO_1', 'x[cm]_2', 'X-NO_2'])
        df = pd.read_csv(path + 'CHPlotLam2', sep='\t')
        x = df['x[cm]_2'].to_list()
        y = df['X-NO_2'].to_list()
        res = pd.DataFrame(list(zip(x, y)), columns=['x[cm]_2', 'X-NO_2'])
        res = res[df['x[cm]_2'].notna()]
        res.to_csv(path + 'CHPlotLam' + '_NORich.txt', sep='\t', float_format='%.6E', index=False)
    elif f == path + 'PlotThermalDeNOx_JSR':
        rename_header(f, ['[K]_0', 'X-NO_0'])
    else:
        rename_header(f, [])

    # move unmodified files to subfolder
    shutil.move(os.path.join(f), outdir)
