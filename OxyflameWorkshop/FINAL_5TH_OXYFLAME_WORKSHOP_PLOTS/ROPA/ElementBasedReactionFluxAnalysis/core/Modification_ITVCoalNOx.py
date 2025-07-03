#!/usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from . import MechanismDependentFunctions_ITVCoalNOx as Mech
from . import MechanismDependentFunctions_ITVCoalNOx_Modified as MechMod


def CompareReactions():

    #
    r, nr_ = Mech.Reactions()
    mod_r, mod_nr_ = MechMod.Reactions()

    # C5H5N module changed
    idx = 691
    nr = nr_[idx:]
    mod_nr = mod_nr_[idx:]

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
        reac_i = df_comp.iloc[i, 0].split(': ')[1]
        #reac_i = df_comp.iloc[i][0].split(': ')[1]
        for j in range(df_comp.shape[0]):
            if df_comp.iloc[j, 1] == 0: #df_comp.iloc[j][1] == 0:
                continue
            else:
                reac_j = df_comp.iloc[j, 1].split(': ')[1]
                #reac_j = df_comp.iloc[j][1].split(': ')[1]
                if reac_i == reac_j:
                    df_diffRnumber.loc[len(df_diffRnumber)] = [df_comp.iloc[i, 0], df_comp.iloc[j, 1]]
                    #df_diffRnumber.loc[len(df_diffRnumber)] = [df_comp.iloc[i][0], df_comp.iloc[j][1]]

    for i in range(df_comp.shape[0]):
        #if df_comp.iloc[i][1] == 0:
        #    df_rmR.loc[len(df_rmR)] = [df_comp.iloc[i][0], df_comp.iloc[i][1]]
        flag = False
        reac_sim = (df_comp.iloc[i, 0]).split(': ')[1]
        for j in range(df_comp.shape[0]):
            if df_comp.iloc[j, 1] == 0:
                continue
            reac_mod = (df_comp.iloc[j, 1]).split(': ')[1]
            if reac_sim == reac_mod:
                # found reaction
                flag = True
                break
        if not flag:
            df_rmR.loc[len(df_rmR)] = [df_comp.iloc[i, 0], 0]

    # 
    df_diffRnumber = df_diffRnumber.iloc[2:].reset_index(drop=True)
    df_rmR = df_rmR.iloc[2:].reset_index(drop=True)
    
    return df_diffRnumber, df_rmR, nr_, mod_nr_


def ReactionNumberModification(df, species, W):
   
    ReactionNumber, removedReac, nr, mod_nr = CompareReactions()
    #print(ReactionNumber)
    #print(removedReac)
    #sys.exit()
    sl = list(df.columns)
    df_new = pd.DataFrame(0, columns=sl, index=np.arange(len(mod_nr)))
    W_new = pd.DataFrame(0, columns=mod_nr, index=np.arange(1))
    W_new.index = W_new.index.astype(str)
    W_new.index.values[0] = 'ReactionRate'

    pos = 0
    changed = 0
    neglected = 0
    for i in range(0, df.shape[0]):
        #if df_new[species][pos] != 0.0:
        #    print('pos=', pos)
        #    print('pos not equal zero!')
        #    # element already added to this position due to different reaction number # DOUBLE check
        #    continue
        if nr[i] in removedReac['Simulation'].to_list():
            neglected += 1
            # ignore this reaction
            #print('Reaction is neglected: ', nr[i])
            continue
        elif nr[i] in ReactionNumber['Simulation'].to_list():
            changed += 1
            # search for modified reaction number and add element to this position in df
            #print('\nnr[i]: ', nr[i])
            #print('df[species][i]: ', df[species][i])
            #print('pos=', pos)
            idx = ReactionNumber.loc[ReactionNumber['Simulation'] == nr[i]].index
            #print(int(idx[0]))
            reac = str(ReactionNumber.iat[int(idx[0]), 1])
            #reac = reac.split(' R')[-1]
            #print('new reaction: ', reac)
            rnum = reac.split(': ')[0]
            rnumber = int(rnum.split('R')[1])
            #print('new reaction number: ', rnumber)
            #print('element to replace: ', df_new[species][rnumber])
            df_new.loc[rnumber - 1, i] = df.loc[i, species] #df_new[species][rnumber - 1] = df[species][i]
            W_new = W_new.astype({W_new.columns[rnumber - 1]: float}) # Added
            W_new.iat[0, rnumber - 1] = W.iat[0, i]
            #print(df_new[species].to_list())
            #print('Reaction number is modified: ' + str(nr[i]) + ' to ' + str(reac))
            pos += 1
        else:
            #print('Not effected: ' + str(nr[i]))
            df_new = df_new.astype(float)
            df_new.loc[pos, species] = df.loc[i, species]
            #df_new[species][pos] = df[species][i]
            W_new = W_new.astype(float) # Added
            W_new.iat[0, pos] = W.iat[0, i]
            pos += 1
    #print('pos = ', pos)
    #print('neglected: ', neglected)
    #print('changed: ', changed)
    #print('\nRESULT: \n', df[species].to_list())
   
    # modify reaction rate df
    #print('W:\n', W.iloc[:, 988:])
    #print('Wnew:\n', W_new.iloc[:, 988:])
    #print('nr[1004]: ', nr[1003])
    #print('W[1004]: ', W.iloc[0, 1003])
    #print(W_new.columns)
    #print(ReactionNumber)
    #print(removedReac)
    #sys.exit()
    return df_new, mod_nr, W_new
