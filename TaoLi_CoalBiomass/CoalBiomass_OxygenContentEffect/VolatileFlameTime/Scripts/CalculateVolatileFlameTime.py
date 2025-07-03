#!/usr/bin/env python3

import sys
import pandas as pd

# data
df = pd.read_csv(sys.argv[1], sep='\t', low_memory=False)
df.columns = df.columns.str.replace(' ', '')
tign = float(sys.argv[2])

# tvol = YCH=0.25*YOHmax - tign
tvol = 0
YCHmax = df['max_CH'].max()
YCHidxmax = df['max_CH'].idxmax()
for i in range(YCHidxmax, df.shape[0]):
    if df['max_CH'][i] <= 0.25 * YCHmax:
        tvol = float(df['time'][i]) * 1000 - tign # [ms]
        break
print('Volatile combustion time: {:.3f}ms'.format(tvol))

