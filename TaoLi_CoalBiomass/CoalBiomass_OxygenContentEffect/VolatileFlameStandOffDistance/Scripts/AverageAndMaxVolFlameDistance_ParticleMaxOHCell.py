#!/usr/bin/env python3

import sys
import pandas as pd

df = pd.read_csv(sys.argv[1], sep='\t')
df.columns = df.columns.str.replace(' ', '')
tign = float(sys.argv[2])
y = df['rfrp'].to_list()
start = 0
end = -1
for i in range(len(y)):
    if df['time'][i] > tign / 1000:
        start = i
        break

#for i in range(len(y)):
#    if y[i] < 0:
#        end = i
#        break
#
y_flame = y[start:end]
y_flame_avg = sum(y_flame) / len(y_flame)
#
print('Average:     {:.3f}'.format(y_flame_avg))
#print('Max (Range): {:.3f}'.format(max(y_flame)))
print('Max (Total): {:.3f}'.format(max(y_flame)))
