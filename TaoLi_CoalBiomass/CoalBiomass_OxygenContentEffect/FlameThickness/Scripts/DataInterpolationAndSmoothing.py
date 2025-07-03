#!usr/nbin/env python3

import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d

# read data
df = pd.read_csv(sys.argv[1], sep='\t')
df.columns = df.columns.str.replace(' ', '')
tign = float(sys.argv[2])

# extract data
col = df.columns
x = df[col[0]].to_list()

for i in range(1, len(col)):
    y = df[col[i]].to_list()

    # neglect > 50 values
    y = [0 if i > 50 else i for i in y]

    # interpolation
    interp_func = interp1d(x, y, kind='nearest') #nearest')

    x_new = np.linspace(min(x), max(x), 200)
    y_new = interp_func(x_new)

    #
    coefficients = np.polyfit(x_new, y_new, 15)
    polynomial = np.poly1d(coefficients)
    fitted_y_data = polynomial(x_new)

    # set data to one
    if i == 1:
        df_fit = pd.DataFrame(list(zip(x_new, fitted_y_data)), columns=[col[0], col[i]])
    else:
        df_fit[col[i]] = fitted_y_data

for i in range(df_fit.shape[0]):
    for j in range(1, df_fit.shape[1]):
        if df_fit.iat[i, 0] * 1000 < tign:
            df_fit.iat[i, j] = 0
        elif df_fit.iat[i, j] < 0:
            df_fit.iat[i, j] = 0

printy = df['tmid_flame'].to_list()
start = 0
end = -1
for i in range(len(y)):
    if df['time'][i] > tign / 1000:
        start = i
        break
y_flame = printy[start:end]
y_flame_avg = sum(y_flame) / len(y_flame)

#
print('Average:   {:.3f}'.format(y_flame_avg))
#print('Max (Range): {:.3f}'.format(max(y_flame)))
print('Max (Total): {:.3f}'.format(max(printy[start:])))

# plot
plt.plot(x, y, 'o', label='Original data')
plt.plot(x_new, y_new, '-', label='Cubic interpolation')
plt.plot(x_new, df_fit['tmid_flame'], 'x', label='fitted data')
plt.legend(loc='best')
plt.tight_layout()
plt.savefig('SmoothedData_tmid.png')
#plt.show()

# df to csv
df_fit.to_csv('SmoothedData.txt', sep='\t', float_format='%12.6E', index=False)
