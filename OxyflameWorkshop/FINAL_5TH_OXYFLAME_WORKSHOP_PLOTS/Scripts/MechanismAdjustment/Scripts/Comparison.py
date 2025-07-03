#!/usr/bin/env python3

import pandas as pd
from core import MechanismDependentFunctions_ITVBioNOx as Mech
from core import MechanismDependentFunctions_ITVBioNOx_Modified as MechMod


r, nr = Mech.Reactions()
mod_r, mod_nr = MechMod.Reactions()

# C5H5N module changed
idx = 990
nr = nr[990:]
mod_nr = mod_nr[990:]

# add 0 (same list length)
mod_nr.extend([0]*(len(nr) - len(mod_nr)))

# create df
reac = {'Original': nr, 'Modified': mod_nr}
df_comp = pd.DataFrame(reac)
#print(df_comp)

#
df_diffRnumber = pd.DataFrame(data=[[0, 0],[0, 0]], columns=['Simulation', 'Modified'])
df_rmR = pd.DataFrame(data=[[0, 0], [0, 0]], columns=['Simulation', 'Modified'])
for i in range(df_comp.shape[0]):
    reac_i = df_comp.iloc[i][0].split(': ')[1]
    for j in range(df_comp.shape[0]):
        if df_comp.iloc[j][1] == 0:
            continue
        else:
            reac_j = df_comp.iloc[j][1].split(': ')[1]
            if reac_i == reac_j:
                df_diffRnumber.loc[len(df_diffRnumber)] = [df_comp.iloc[i][0], df_comp.iloc[j][1]]

for i in range(df_comp.shape[0]):
    if df_comp.iloc[i][1] == 0:
        df_rmR.loc[len(df_rmR)] = [df_comp.iloc[i][0], df_comp.iloc[i][1]]

# 
df_diffRnumber = df_diffRnumber.iloc[2:].reset_index(drop=True)
df_rmR = df_rmR.iloc[2:].reset_index(drop=True)
#print(df_diffRnumber)
#print(df_rmR)

