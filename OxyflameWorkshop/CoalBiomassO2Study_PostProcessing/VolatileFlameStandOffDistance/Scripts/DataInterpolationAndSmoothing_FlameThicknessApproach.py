#!usr/nbin/env python3

import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d

# read data
df = pd.read_csv(sys.argv[1], sep='\t')
tign = float(sys.argv[2])

# case
case = (sys.argv[1]).split('_')[1][:-4]
print(case)

# extract data
df.columns = df.columns.str.replace(' ', '')
col = df.columns

def smoothing(df, case, column):
    x = df[col[0]].to_list()
    y = df[column].to_list()

    # neglect > 50 values
    y = [0 if i > 50 else i for i in y]

    # interpolation
    interp_func = interp1d(x, y, kind='cubic') #nearest')

    x_new = np.linspace(min(x), max(x), 200)
    y_new = interp_func(x_new)

    #
    coefficients = np.polyfit(x_new, y_new, 15)
    polynomial = np.poly1d(coefficients)
    fitted_y_data = polynomial(x_new)

    # set data to one
    df_fit = pd.DataFrame(list(zip(x_new, fitted_y_data)), columns=[col[0], column])
    for i in range(df_fit.shape[0]):
        if df_fit.iat[i, 0] * 1000 < tign:
            df_fit.iat[i, 1] = 0 # or -1 if rf_minus_rp
        # rf_minus_rp ...
        #elif df_fit.iat[i, 1] < 0:
        #    df_fit.iat[i, 1] = -1

    # plot
    plt.plot(x, y, 'o', label='Original data')
    plt.plot(x_new, y_new, '-', label='Cubic interpolation')
    plt.plot(x_new, df_fit[column], 'x', label='fitted data')
    plt.xlabel('time [s]')
    plt.ylabel('Mid')
    plt.title('{0}'.format((os.getcwd()).split('/')[-1]))
    plt.legend(loc='best')
    plt.tight_layout()
    plt.savefig('SmoothedData_' + case + '_' + column + '.png')
    #plt.show()
    plt.close()

    # df to csv
    df_fit.to_csv('SmoothedData_' + case + '_' + column + '.txt', sep='\t', float_format='%12.6E', index=False)

# run
smoothing(df, case, 'Min')
smoothing(df, case, 'Mid')
smoothing(df, case, 'Max')

