#!/usr/bin/env python3

import re
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from . import Utils as utils
from . import MechanismDependentFunctions as mdf
from . import Modification as modi
#from adjustText import adjust_text


def ignore_reaction(df, spec, nreac, W):

    if spec == 'NO':
        # ignore NO2 = NO + xyz
        for j in range(len(nreac)):
            r, p, a, b = utils.DetermineReactantAndProductSpecies(nreac[j], W)
            if (spec in r and 'NO2' in p) or (spec in p and 'NO2' in r):
                df[j] = 0
            if (spec in r and 'HONO' in p) or (spec in p and 'HONO' in r):
                df[j] = 0

    elif spec == 'HCN':
        # ignore HNC = HCN + xyz
        for j in range(len(nreac)):
            r, p, a, b = utils.DetermineReactantAndProductSpecies(nreac[j], W)
            if (spec in r and 'HNC' in p) or (spec in p and 'HNC' in r):
                df[j] = 0

    return df


def Normalization(df, s, lim, ul, nr, r, rates, c, p):

    # consider only species of interest
    df_species = df[s]
    
    if c:
        # consider only consumption reaction of species
        for i in range(len(nr)):
            if df_species.iat[i] == 0:
                continue
            reactants, products, a, b = utils.DetermineReactantAndProductSpecies(
                nr[i], rates)
            if s in products:
                df_species[i] = 0.0
    elif p:
        # consider only production reactions of species
        for i in range(len(nr)):
            if df_species.iat[i] == 0:
                continue
            reactants, products, a, b = utils.DetermineReactantAndProductSpecies(
                nr[i], rates)
            if s in reactants:
                df_species[i] = 0.0
    # focus on source
    df_species = ignore_reaction(df_species, s, nr, rates)
    # normalize fluxes
    norm = df_species.abs().sum()
    df_norm = df_species / norm * 100  # [%]
    if len(r) == 0:
        # sort percentages from small to large (absolute values)
        df_norm = df_norm.iloc[df_norm.abs().argsort()]
        # neglect: abs(fluxes) < limit
        df_plot = df_norm[abs(df_norm) > lim]
        # clipp reactions if not readable
        N = df_plot.shape[0]
        # if N > ul:
        #    df_plot = df_plot.iloc[N-ul:]
        #N = df_plot.shape[0]

        # first input defines reactions
        reactions = df_plot.index.to_list()
        
        return df_plot, N, reactions

    else:
        # get respective reactions
        df_plot2 = pd.DataFrame(0, columns=[s], index=np.arange(0, 1))
        for j in r:
            df_plot2.loc[len(df_plot2)] = df_norm.loc[j]
        # remove
        df_plot2 = df_plot2.iloc[1:, :]

        return df_plot2


def MergeData(df_complete, df_data, pos):

    dfidx = list(df_data.index)

    for i in range(df_complete.shape[0]):
        idx = df_complete.iat[i, 0]
        for j in range(pos-1, pos):
            if idx in dfidx:
                df_complete.iat[i, j] = float(df_data.iloc[dfidx.index(idx)])

    return df_complete


def calculate_ticks(xmin, xmax, step):

    # Calculate the start and end ticks based on the range
    # Round down to the nearest multiple of step
    x_start = np.floor(xmin / step) * step
    # Round up to the nearest multiple of step
    x_end = np.ceil(xmax / step) * step
    
    ticks = np.arange(x_start, x_end + step, step)
    # ensure that '0' is included
    if 0 not in ticks:
        if ticks[0] < 0:
            ticks = np.append(ticks, 0)
        else:
            ticks = np.append(0, ticks)

    return ticks


def GeneratePlot(f, fs, df, df_2, df_3, df_4, species, limit, outdir, label1, label2, label3, label4, legend_pos, reac_color, x_label, Nreac, cons, prod):

    # define font
    font = {'size': fs}
    plt.rcParams['font.family'] = 'serif'
    plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
    plt.rc('font', **font)
    plt.rc('axes', unicode_minus=False, linewidth=1.0)

    # get reactions
    reac, netreac_ = mdf.Reactions()
    #netreac_ = netreac # RM

    # extract reaction rate
    W = pd.DataFrame(df['ReactionRate']).transpose()
    W.columns = netreac_ #
    df_ = df.drop('ReactionRate', axis=1)
    df_, netreac, W = modi.ReactionNumberModification(df_, species, W) # RM
    df, N1, reac_idx1 = Normalization(
        df_, species, limit, Nreac, netreac, [], W, cons, prod)
    Ncases = ['Case1']

    reac_idx = []
    for num in reac_idx1:
        if num not in reac_idx:
            reac_idx.append(num)

    # define number of cases
    cases = 1
    if isinstance(df_2, pd.DataFrame):
        cases += 1
    if isinstance(df_3, pd.DataFrame):
        cases += 1
    if isinstance(df_4, pd.DataFrame):
        cases += 1
    if isinstance(df_2, pd.DataFrame) == False and isinstance(df_3, pd.DataFrame) == True:
        df_2 = df_3
    if isinstance(df_3, pd.DataFrame) == False and isinstance(df_4, pd.DataFrame) == True:
        df_3 = df_4

    # optional input data
    if cases >= 2:
        W_2 = pd.DataFrame(df_2['ReactionRate']).transpose()
        W_2.columns = netreac_ #
        df_2_ = df_2.drop('ReactionRate', axis=1)
        df_2_, netreac, W_2 = modi.ReactionNumberModification(df_2_, species, W_2) # RM
        df_2, N2, reac_idx2 = Normalization(df_2_, species, limit, Nreac,
                                            netreac, [], W_2, cons, prod)
        reac_idx = []
        for num in reac_idx1 + reac_idx2:
            if num not in reac_idx:
                reac_idx.append(num)
        Ncases.append('Case2')

    if cases >= 3:
        W_3 = pd.DataFrame(df_3['ReactionRate']).transpose()
        W_3.columns = netreac_ # 
        df_3_ = df_3.drop('ReactionRate', axis=1)
        df_3_, netreac, W_3 = modi.ReactionNumberModification(df_3_, species, W_3) # RM
        df_3, N3, reac_idx3 = Normalization(df_3_, species, limit, Nreac,
                                            netreac, [], W_3, cons, prod)
        reac_idx = []
        for num in reac_idx1 + reac_idx2 + reac_idx3:
            if num not in reac_idx:
                reac_idx.append(num)
        Ncases.append('Case3')

    if cases == 4:
        W_4 = pd.DataFrame(df_4['ReactionRate']).transpose()
        W_4.columns = netreac_ #
        df_4_ = df_4.drop('ReactionRate', axis=1)
        df_4_, netreac, W_4 = modi.ReactionNumberModification(df_4_, species, W_4) # RM
        df_4, N4, reac_idx4 = Normalization(df_4_, species, limit, Nreac,
                                            netreac, [], W_4, cons, prod)
        reac_idx = []
        for num in reac_idx1 + reac_idx2 + reac_idx3 + reac_idx4:
            if num not in reac_idx:
                reac_idx.append(num)
        Ncases.append('Case4')

    # create a 'results' df
    df_complete = pd.DataFrame(
        float(0.0), columns=[Ncases], index=np.arange(len(reac_idx)))
    df_complete.insert(0, 'ReactionIndex', reac_idx)

    if cases >= 1:
        df_complete = MergeData(df_complete, df, 2)
    if cases >= 2:
        df_complete = MergeData(df_complete, df_2, 3)
    if cases >= 3:
        df_complete = MergeData(df_complete, df_3, 4)
    if cases >= 4:
        df_complete = MergeData(df_complete, df_4, 5)

    # calculate percentages for all reactions in df_complete
    if cases >= 2:
        df_buf = Normalization(df_, species, limit, Nreac,
                               netreac, reac_idx, W_2, cons, prod)
        df_complete['Case1'] = df_buf[species].to_list()
        df_buf = Normalization(df_2_, species, limit,
                               Nreac, netreac, reac_idx, W_2, cons, prod)
        df_complete['Case2'] = df_buf[species].to_list()
    if cases >= 3:
        df_buf = Normalization(df_3_, species, limit,
                               Nreac, netreac, reac_idx, W_2, cons, prod)
        df_complete['Case3'] = df_buf[species].to_list()
    if cases >= 4:
        df_buf = Normalization(df_4_, species, limit,
                               Nreac, netreac, reac_idx, W_2, cons, prod)
        df_complete['Case4'] = df_buf[species].to_list()

    # sort df
    col = list(df_complete.columns)
    df_complete = df_complete.sort_values(by=col[1], key=lambda x: x.abs())
    reac_idx = list(np.concatenate([arr.flatten()
                    for arr in df_complete['ReactionIndex'].values]))

    if cases >= 1:
        Data1 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case1'].values]))
    if cases >= 2:
        Data2 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case2'].values]))
    if cases >= 3:
        Data3 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case3'].values]))
    if cases >= 4:
        Data4 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case4'].values]))

    # reaction index to reaction
    reactions = []
    for j in reac_idx:
        reactions.append(netreac[j])

    # total number of reactions in figure
    N = len(reac_idx)

    # rename columns
    W.columns = netreac

    # dashed line at x=0
    plt.axvline(0, color='black', linestyle='-')

    # grey stripes in background
    # for i in range(0, N):
    #    if i % 2:
    #        plt.axhspan(i-.5, i+.5, facecolor='slategrey', alpha=0.1)

    y_ticks_positions = np.arange(N)
    grid_positions = y_ticks_positions + 0.5
    plt.yticks(y_ticks_positions, reactions)
    for pos in grid_positions:
        plt.axhline(pos, color='black', linestyle=':', linewidth=0.5)
    plt.grid(False, axis='y')
    plt.ylim(-0.5, grid_positions[-1])

    # add horizontal bars
    ind = np.arange(N)
    width = 0.25
    if cases == 1:
        width = 0.85
        bwidth = width
        for i in range(len(Data1)):
            if Data1[i] >= 0:
                plt.barh(ind[i], Data1[i], width, color='green')
            else:
                plt.barh(ind[i], Data1[i], width, color='red')
        xmin = min(Data1)
        xmax = max(Data1)
    elif cases == 2:
        bwidth = width * 2 * 0.85
        bar1 = plt.barh(ind+width, Data1, bwidth,
                        color='red', edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind-width, Data2, bwidth,
                        color='green', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2), ('{0}'.format(label1), '{0}'.format(
            label2)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2))
        xmax = max(max(Data1), max(Data2))
    elif cases == 3:
        width = 0.3
        bwidth = width
        bar1 = plt.barh(ind+width, Data1, bwidth, color='black',
                        edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind, Data2, bwidth, color='red',
                        edgecolor='white', linewidth=1)
        bar3 = plt.barh(ind-width, Data3, bwidth,
                        color='blue', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2, bar3), ('{0}'.format(label1), '{0}'.format(
            label2), '{0}'.format(label3)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2), min(Data3))
        xmax = max(max(Data1), max(Data2), max(Data3))
    elif cases == 4:
        plt.rcParams['hatch.linewidth'] = 1.5
        bwidth = width * 0.9
        bar1 = plt.barh(ind+width, Data1, bwidth, color='#1f78b4',
                        edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind+width/2, Data2, bwidth, color='#e31a1c',
                        edgecolor='white', linewidth=1)
        bar3 = plt.barh(ind-width/2, Data3, bwidth,
                        color='#1f78b4', hatch='//', edgecolor='white', linewidth=1)
        bar4 = plt.barh(ind-width, Data4, bwidth,
                        color='#e31a1c', hatch='//', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2, bar3, bar4), ('{0}'.format(label1), '{0}'.format(
            label2), '{0}'.format(label3), '{0}'.format(label4)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2), min(Data3), min(Data4))
        xmax = max(max(Data1), max(Data2), max(Data3), max(Data4))

    # rename reactions: species is consumed => species as reactant & species produced => species as product
    symb = '='
    #symb = '$\\rightleftarrows$'
    for i in range(len(reactions)):
        rename = False
        #print('reaction: ' + str(reactions[i]) + '\tW=' + str(W[reactions[i]][0]))
        reactants, products, a, b = utils.DetermineReactantAndProductSpecies(
            reactions[i], W)
        if '+M' in reactions[i]:
            reactants[-1] += '(+M)'
            products[-1] += '(+M)'
        if cons and species not in reactants:
            rename = True
        elif prod and species not in products:
            rename = True
        elif prod is False and cons is False and species in reactants:
            rename = True
        # i.e.C5H4NO2 = CO+CO+C2H3+HCN function returns 2CO+...
        if sum(a) / len(a) != 1:
            if len(reactants) == 1:
                reactants.append(reactants[0])
            else:
                products.insert(0, products[0])
        if sum(b) / len(b) != 1:
            if len(products) == 1:
                products.append(products[0])
            else:
                products.insert(0, products[0])
        # consider index: H2O to H_2O
        reactants = [re.sub("([0-9])", "_\\1", x) for x in reactants]
        reactants = [r'$\mathregular{'+x+'}$' for x in reactants]
        products = [re.sub("([0-9])", "_\\1", x) for x in products]
        products = [r'$\mathregular{'+x+'}$' for x in products]
        if rename:
            reactions[i] = reactions[i].split(
                ': ')[0] + ': ' + '+'.join(products) + symb + '+'.join(reactants)
        else:
            reactions[i] = reactions[i].split(
                ': ')[0] + ': ' + '+'.join(reactants) + symb + '+'.join(products)

    # specify xticks
    step = 5
    while ((xmax - xmin)/step > 8):
        step = step*2
    xticks = calculate_ticks(xmin, xmax, step)
    plt.xticks(xticks)

    plt.xlim(min(xticks), max(xticks))
    plt.grid(True, axis='x', linestyle=':', color='black',
             linewidth=0.5)
   
    # modify reaction name color
    color = plt.gca().get_yticklabels()
    for i in range(len(reactions)):
        r = reactions[i].split(': ')
        if r[0] in reac_color.keys():
            color[i].set_color(reac_color[r[0]])
            #reactions[i] = '$\\Longrightarrow $' + reactions[i]
        # remove reaction number
        reactions[i] = reactions[i].split(': ')[1]
    plt.yticks(ind, reactions)

    plt.xlabel(x_label)
    
   # # add annotation
   # ann = 'Target22: '.format(species)
   # ann = plt.annotate(ann, xy=(0.05,0.05), xytext=(0.05, 0.1), textcoords='axes fraction') #xycoords='axes fraction')
   # adjust_text([ann], plt=plt)

    plt.savefig(outdir + '/ROPA_' + species + '.pdf',
                format="pdf", bbox_inches='tight')

    return
