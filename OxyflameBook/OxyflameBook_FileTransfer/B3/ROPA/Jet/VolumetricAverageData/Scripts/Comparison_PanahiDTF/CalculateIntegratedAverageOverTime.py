#!/usr/bin/env python3

import sys
import pandas as pd
import matplotlib.pyplot as plt

# How to run this script?
# python3 CalculateIntegratedAverageOverTime.py VolAverageData_T1300K VolAverageData_T1400K VolAverageData_T1500K

# define font
font = {'size': 14}
plt.rcParams['font.family'] = 'serif'
plt.rcParams['font.serif'] = [
    'Times New Roman'] + plt.rcParams['font.serif']
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False, linewidth=1.0)

def IntegratedAverageCalculation(df):

    # allocate memory
    int_average = []
    time = df['time[ms]'].to_list()

    for i in range(2, df.shape[0]):
        tend = df['time[ms]'][i]
        int_av = 0
        for t in range(1, df.shape[0]):
            if df['time[ms]'][t] > tend:
                endt = t - 1
                #print('break here: ', df['time[ms]'][endt])
                break
            int_av += (df['VolX_NO'][t] + df['VolX_NO2'][t]) * \
                (df['time[ms]'][t] - df['time[ms]'][t - 1])
        int_average.append(int_av / df['time[ms]'][endt])
    
    df_ia = pd.DataFrame(data=list(zip(time, int_average)), columns=['time[ms]', 'IntAvgNOx'])

    return df_ia


# read volumetric average data
T1300K = pd.read_csv(sys.argv[1], sep=r'\s+', low_memory=False)
T1400K = pd.read_csv(sys.argv[2], sep=r'\s+', low_memory=False)
T1500K = pd.read_csv(sys.argv[3], sep=r'\s+', low_memory=False)

ia_T1300K = IntegratedAverageCalculation(T1300K)
ia_T1400K = IntegratedAverageCalculation(T1400K)
ia_T1500K = IntegratedAverageCalculation(T1500K)

factor = 60.13
# create figure
plt.plot(ia_T1300K['time[ms]'] * 1E+03, ia_T1300K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='blue', label='T=1300K')
plt.plot(ia_T1400K['time[ms]'] * 1E+03, ia_T1400K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='green', label='T=1400K')
plt.plot(ia_T1500K['time[ms]'] * 1E+03, ia_T1500K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='red', label='T=1500K')
#plt.plot((T1300K['VolX_NO'][2:] + T1300K['VolX_NO2'][2:]) * 1E+06, ia_T1300K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='blue', label='T1300K')
#plt.plot((T1400K['VolX_NO'][2:] + T1300K['VolX_NO2'][2:]) * 1E+06, ia_T1400K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='green', label='T1400K')
#plt.plot((T1500K['VolX_NO'][2:] + T1500K['VolX_NO2'][2:]) * 1E+06, ia_T1500K['IntAvgNOx'] * 1E+06 * factor, marker='x', color='red', label='T1500K')

# experimental data
plt.axhline(y=352.0, linestyle='--', color='blue')
plt.axhline(y=409.4, linestyle='-', color='blue')
plt.axhline(y=482.1, linestyle='--', color='blue')
plt.axhline(y=498.9, linestyle='--', color='green')
plt.axhline(y=515.7, linestyle='-', color='green')
plt.axhline(y=540.9, linestyle='--', color='green')
plt.axhline(y=599.6, linestyle='--', color='red')
plt.axhline(y=620.6, linestyle='-', color='red')
plt.axhline(y=654.2, linestyle='--', color='red')

plt.xlabel('time [ms]')
#plt.xlabel('VolX_NOx [ppm]')
plt.ylabel('IntAverage NOx [ppm]')
plt.legend(loc='best')
plt.tight_layout()

plt.show()
