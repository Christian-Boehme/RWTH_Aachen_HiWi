#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd

inpfile = sys.argv[1]
subdir = sys.argv[2]

with open(inpfile, 'r') as inp:
    data = [line.rstrip() for line in inp]

results = []
for line in range(len(data)):
    if data[line].startswith('/rwthfs/'):
        if data[line + 1] != 'FlameThicknessApproach':
            sim = data[line].split('/')[-2:]
            simulation_average = float(data[line + 3].split(':')[1].strip())
            simulation_max = float(data[line + 4].split(':')[1].strip())
            smoothed_average = float(data[line + 6].split(':')[1].strip())
            smoothed_max = float(data[line + 7].split(':')[1].strip())
            results.append([sim, [simulation_average, simulation_max], [smoothed_average, smoothed_max]])
        else:
            sim = data[line].split('/')[-2:]
            # index = CASE: Mid
            simulation_average = float(data[line + 7].split(':')[1].strip())
            simulation_max = float(data[line + 8].split(':')[1].strip())
            smoothed_average = float(data[line + 18].split(':')[1].strip())
            smoothed_max = float(data[line + 19].split(':')[1].strip())
            results.append([sim, [simulation_average, simulation_max], [smoothed_average, smoothed_max]])

# create df
df_Coal_EffectOfSize_Air_sim_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Air_sim_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Air_smo_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Air_smo_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Oxy_sim_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Oxy_sim_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Oxy_smo_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfSize_Oxy_smo_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfOxygenContent_Air_sim_avg = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfOxygenContent_Air_sim_max = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfOxygenContent_Air_smo_avg = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_Coal_EffectOfOxygenContent_Air_smo_max = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Air_sim_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Air_sim_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Air_smo_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Air_smo_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Oxy_sim_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Oxy_sim_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Oxy_smo_avg = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfSize_Oxy_smo_max = pd.DataFrame({'Xaxis': [90, 125, 160], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfOxygenContent_Air_sim_avg = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfOxygenContent_Air_sim_max = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfOxygenContent_Air_smo_avg = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])
df_WS_EffectOfOxygenContent_Air_smo_max = pd.DataFrame({'Xaxis': [10, 20, 40], 'Data': [0, 0, 0]}, columns=['Xaxis', 'Data'])

for i in range(len(results)):
    if results[i][0][0] == 'Coal':
        if results[i][0][1] == 'AIR10-DP125':
            df_Coal_EffectOfOxygenContent_Air_sim_avg.iat[0, 1] = results[i][1][0]
            df_Coal_EffectOfOxygenContent_Air_sim_max.iat[0, 1] = results[i][1][1]
            df_Coal_EffectOfOxygenContent_Air_smo_avg.iat[0, 1] = results[i][2][0]
            df_Coal_EffectOfOxygenContent_Air_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP90':
            df_Coal_EffectOfSize_Air_sim_avg.iat[0, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Air_sim_max.iat[0, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Air_smo_avg.iat[0, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Air_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP125':
            df_Coal_EffectOfOxygenContent_Air_sim_avg.iat[1, 1] = results[i][1][0]
            df_Coal_EffectOfOxygenContent_Air_sim_max.iat[1, 1] = results[i][1][1]
            df_Coal_EffectOfOxygenContent_Air_smo_avg.iat[1, 1] = results[i][2][0]
            df_Coal_EffectOfOxygenContent_Air_smo_max.iat[1, 1] = results[i][2][1]
            df_Coal_EffectOfSize_Air_sim_avg.iat[1, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Air_sim_max.iat[1, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Air_smo_avg.iat[1, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Air_smo_max.iat[1, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP160':
            df_Coal_EffectOfSize_Air_sim_avg.iat[2, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Air_sim_max.iat[2, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Air_smo_avg.iat[2, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Air_smo_max.iat[2, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR40-DP125':
            df_Coal_EffectOfOxygenContent_Air_sim_avg.iat[2, 1] = results[i][1][0]
            df_Coal_EffectOfOxygenContent_Air_sim_max.iat[2, 1] = results[i][1][1]
            df_Coal_EffectOfOxygenContent_Air_smo_avg.iat[2, 1] = results[i][2][0]
            df_Coal_EffectOfOxygenContent_Air_smo_max.iat[2, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP90':
            df_Coal_EffectOfSize_Oxy_sim_avg.iat[0, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Oxy_sim_max.iat[0, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Oxy_smo_avg.iat[0, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Oxy_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP125':
            df_Coal_EffectOfSize_Oxy_sim_avg.iat[1, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Oxy_sim_max.iat[1, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Oxy_smo_avg.iat[1, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Oxy_smo_max.iat[1, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP160':
            df_Coal_EffectOfSize_Oxy_sim_avg.iat[2, 1] = results[i][1][0]
            df_Coal_EffectOfSize_Oxy_sim_max.iat[2, 1] = results[i][1][1]
            df_Coal_EffectOfSize_Oxy_smo_avg.iat[2, 1] = results[i][2][0]
            df_Coal_EffectOfSize_Oxy_smo_max.iat[2, 1] = results[i][2][1]
    if results[i][0][0] == 'WS':
        if results[i][0][1] == 'AIR10-DP125':
            df_WS_EffectOfOxygenContent_Air_sim_avg.iat[0, 1] = results[i][1][0]
            df_WS_EffectOfOxygenContent_Air_sim_max.iat[0, 1] = results[i][1][1]
            df_WS_EffectOfOxygenContent_Air_smo_avg.iat[0, 1] = results[i][2][0]
            df_WS_EffectOfOxygenContent_Air_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP90':
            df_WS_EffectOfSize_Air_sim_avg.iat[0, 1] = results[i][1][0]
            df_WS_EffectOfSize_Air_sim_max.iat[0, 1] = results[i][1][1]
            df_WS_EffectOfSize_Air_smo_avg.iat[0, 1] = results[i][2][0]
            df_WS_EffectOfSize_Air_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP125':
            df_WS_EffectOfOxygenContent_Air_sim_avg.iat[1, 1] = results[i][1][0]
            df_WS_EffectOfOxygenContent_Air_sim_max.iat[1, 1] = results[i][1][1]
            df_WS_EffectOfOxygenContent_Air_smo_avg.iat[1, 1] = results[i][2][0]
            df_WS_EffectOfOxygenContent_Air_smo_max.iat[1, 1] = results[i][2][1]
            df_WS_EffectOfSize_Air_sim_avg.iat[1, 1] = results[i][1][0]
            df_WS_EffectOfSize_Air_sim_max.iat[1, 1] = results[i][1][1]
            df_WS_EffectOfSize_Air_smo_avg.iat[1, 1] = results[i][2][0]
            df_WS_EffectOfSize_Air_smo_max.iat[1, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR20-DP160':
            df_WS_EffectOfSize_Air_sim_avg.iat[2, 1] = results[i][1][0]
            df_WS_EffectOfSize_Air_sim_max.iat[2, 1] = results[i][1][1]
            df_WS_EffectOfSize_Air_smo_avg.iat[2, 1] = results[i][2][0]
            df_WS_EffectOfSize_Air_smo_max.iat[2, 1] = results[i][2][1]
        if results[i][0][1] == 'AIR40-DP125':
            df_WS_EffectOfOxygenContent_Air_sim_avg.iat[2, 1] = results[i][1][0]
            df_WS_EffectOfOxygenContent_Air_sim_max.iat[2, 1] = results[i][1][1]
            df_WS_EffectOfOxygenContent_Air_smo_avg.iat[2, 1] = results[i][2][0]
            df_WS_EffectOfOxygenContent_Air_smo_max.iat[2, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP90':
            df_WS_EffectOfSize_Oxy_sim_avg.iat[0, 1] = results[i][1][0]
            df_WS_EffectOfSize_Oxy_sim_max.iat[0, 1] = results[i][1][1]
            df_WS_EffectOfSize_Oxy_smo_avg.iat[0, 1] = results[i][2][0]
            df_WS_EffectOfSize_Oxy_smo_max.iat[0, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP125':
            df_WS_EffectOfSize_Oxy_sim_avg.iat[1, 1] = results[i][1][0]
            df_WS_EffectOfSize_Oxy_sim_max.iat[1, 1] = results[i][1][1]
            df_WS_EffectOfSize_Oxy_smo_avg.iat[1, 1] = results[i][2][0]
            df_WS_EffectOfSize_Oxy_smo_max.iat[1, 1] = results[i][2][1]
        if results[i][0][1] == 'OXY20-DP160':
            df_WS_EffectOfSize_Oxy_sim_avg.iat[2, 1] = results[i][1][0]
            df_WS_EffectOfSize_Oxy_sim_max.iat[2, 1] = results[i][1][1]
            df_WS_EffectOfSize_Oxy_smo_avg.iat[2, 1] = results[i][2][0]
            df_WS_EffectOfSize_Oxy_smo_max.iat[2, 1] = results[i][2][1]

# write to file
df_Coal_EffectOfSize_Air_sim_avg.to_csv(subdir + '/Sim_Coal_EffectOfSize_Air_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Air_sim_max.to_csv(subdir + '/Sim_Coal_EffectOfSize_Air_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Air_smo_avg.to_csv(subdir + '/Sim_Coal_EffectOfSize_Air_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Air_smo_max.to_csv(subdir + '/Sim_Coal_EffectOfSize_Air_smo_max.csv', sep='\t', float_format='%9.3f', index=False)

df_Coal_EffectOfSize_Oxy_sim_avg.to_csv(subdir + '/Sim_Coal_EffectOfSize_Oxy_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Oxy_sim_max.to_csv(subdir + '/Sim_Coal_EffectOfSize_Oxy_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Oxy_smo_avg.to_csv(subdir + '/Sim_Coal_EffectOfSize_Oxy_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfSize_Oxy_smo_max.to_csv(subdir + '/Sim_Coal_EffectOfSize_Oxy_smo_max.csv', sep='\t', float_format='%9.3f', index=False)

df_Coal_EffectOfOxygenContent_Air_sim_avg.to_csv(subdir + '/Sim_Coal_EffectOfOxygenContent_Air_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfOxygenContent_Air_sim_max.to_csv(subdir + '/Sim_Coal_EffectOfOxygenContent_Air_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfOxygenContent_Air_smo_avg.to_csv(subdir + '/Sim_Coal_EffectOfOxygenContent_Air_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_Coal_EffectOfOxygenContent_Air_smo_max.to_csv(subdir + '/Sim_Coal_EffectOfOxygenContent_Air_smo_max.csv', sep='\t', float_format='%9.3f', index=False)

df_WS_EffectOfSize_Air_sim_avg.to_csv(subdir + '/Sim_WS_EffectOfSize_Air_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Air_sim_max.to_csv(subdir + '/Sim_WS_EffectOfSize_Air_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Air_smo_avg.to_csv(subdir + '/Sim_WS_EffectOfSize_Air_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Air_smo_max.to_csv(subdir + '/Sim_WS_EffectOfSize_Air_smo_max.csv', sep='\t', float_format='%9.3f', index=False)

df_WS_EffectOfSize_Oxy_sim_avg.to_csv(subdir + '/Sim_WS_EffectOfSize_Oxy_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Oxy_sim_max.to_csv(subdir + '/Sim_WS_EffectOfSize_Oxy_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Oxy_smo_avg.to_csv(subdir + '/Sim_WS_EffectOfSize_Oxy_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfSize_Oxy_smo_max.to_csv(subdir + '/Sim_WS_EffectOfSize_Oxy_smo_max.csv', sep='\t', float_format='%9.3f', index=False)

df_WS_EffectOfOxygenContent_Air_sim_avg.to_csv(subdir + '/Sim_WS_EffectOfOxygenContent_Air_sim_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfOxygenContent_Air_sim_max.to_csv(subdir + '/Sim_WS_EffectOfOxygenContent_Air_sim_max.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfOxygenContent_Air_smo_avg.to_csv(subdir + '/Sim_WS_EffectOfOxygenContent_Air_smo_avg.csv', sep='\t', float_format='%9.3f', index=False)
df_WS_EffectOfOxygenContent_Air_smo_max.to_csv(subdir + '/Sim_WS_EffectOfOxygenContent_Air_smo_max.csv', sep='\t', float_format='%9.3f', index=False)






