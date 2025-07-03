#!/usr/bin/env python3

import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# File compares two volatile compositions for ONE feedstock (Coal or Biomass)

# ---------------
# INPUTS
# ---------------
# Define directory name
outdir = 'output_VolatileComposition'
# Define label names for all cases
labelA = 'Air'
labelO = 'Oxy'
# Define title
title = '90µm'
# Define colors
c_air = 'blue'
c_oxy = 'red'
# Define location of species names
SpeciesOnXAxis = False
# Define location
loc_C_A90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/AIR-20-DP-90/monitor/'
loc_C_O90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/OXY-20-DP-90/monitor/'
loc_B_A90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/AIR-20-DP-90/monitor/'
loc_B_O90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/OXY-20-DP-90/monitor/'
# ---------------

# Define font
#font = {'family': 'Helvetica', 'size': 18}
font = {'size': 18}
plt.rc('font', **font)

# Create folder
if not os.path.exists(outdir):
    os.makedirs(os.getcwd() + '/' + outdir)


def get_vol(df, init, index):

    vol_list = []
    species = []
    for i in range(df.columns.get_loc(init), len(df.columns)):
        if "_min" in df.columns[i] or 'CH2OHCH2CHO' == df.columns[i][:-
                                                                     1] or 'C2H6S_max' == df.columns[i]:
            continue
        # last column with volatiles
        if "O2_max" == df.columns[i]:
            break
        else:
            vol_list.append(df[df.columns[i]].loc[index])
            head = df.columns[i]
            if '_max' in head:
                head = head[:-4]
            if '_.1' in head:
                head = head[:-3]
            species.append(head)

    return vol_list, species


def plot_volatile_composition(loc_one, loc_two, ctime_one,
                              ctime_two, c1, c2, title, form, label1, label2, outdir, fname):

    # Read in data
    df_one = pd.read_csv(
        loc_one + '/coal',
        sep=r"\s+",
        low_memory=False,
        skiprows=[
            1,
            2])
    df_two = pd.read_csv(
        loc_two + '/coal',
        sep=r"\s+",
        low_memory=False,
        skiprows=[
            1,
            2])

    # time [s] -> [ms]
    time_one = 1E+03 * df_one['time']
    time_two = 1E+03 * df_two['time']

    # Which feedstock? Coal or Biomass
    feedstock = 'Coal'
    if 'CH3OH_max' in df_one.columns:
        feedstock = 'Biomass'
    #print('\nFeedstock is: ', feedstock)

    vol_one = []
    vol_two = []

    # Time -> Index
    for i in range(len(time_one)):
        if time_one[i] >= ctime_one:
            index_one = i
            break

    for j in range(len(time_two)):
        if time_two[j] >= ctime_two:
            index_two = j
            break

    if feedstock == 'Biomass':
        end_spec = 'C2H6S_max'
    if feedstock == 'Coal':
        end_spec = 'H2_max'

    vol_one, spec_one = get_vol(df_one, end_spec, float(index_one))
    vol_two, spec_two = get_vol(df_two, end_spec, float(index_two))

    species = spec_one
    y_two = vol_two
    y_one = []

    for i in range(len(spec_two)):
        if spec_two[i] in spec_one:
            y_one.append(vol_one[spec_one.index(spec_two[i])])
        else:
            y_one.append(0)

    for i in range(len(spec_one)):
        if spec_one[i] not in spec_two:
            species.append(spec_one[i])
            y_two.append(0)
            y_one.append(vol_one[spec_one.index(spec_one[i])])

    # plot if len != 0
    species_comp = species
    y_one_comp = y_one
    y_two_comp = y_two

    rm = []
    for i in range(len(species)):
        if y_one[i] == 0 and y_two[i] == 0:
            rm.append(i)

    rev = list(reversed(rm))
    for i in rev:
        del species[i]
        del y_one[i]
        del y_two[i]

    N = len(species)

    # rename species according to gas phase mechanism
    for i in range(len(species)):
        if species[i] == 'A1OH':
            species[i] = 'C6H5OH'
        if species[i] == 'HOA1CH3':
            species[i] = 'CRESOL'
        if species[i] == 'A1CH2OH':
            species[i] = 'C7H8O'
        if species[i] == 'OC8H7OOH':
            species[i] = 'VANILLIN'
        if species[i] == 'A2R5':
            species[i] = 'C12H8'
        if species[i] == 'A2CH3':
            species[i] = 'C10H7CH3'

    # Background
    for i in range(0, N):
        if i % 2:
            if form:
                plt.axvspan(i - .5, i + .5, facecolor='gainsboro', alpha=0.3)
            else:
                plt.axhspan(i - .5, i + .5, facecolor='gainsboro', alpha=0.3)

    ind = np.arange(N)
    width = 0.25
    if form:
        bar1 = plt.bar(ind - width / 2, y_one, width, color=c1)
        bar2 = plt.bar(ind + width / 2, y_two, width, color=c2)
        plt.xticks(ind, species, rotation=90)
        plt.ylabel('Y [-]')
        plt.ylim(0, 1)
        plt.legend((bar1, bar2), ('{}'.format(label1), '{}'.format(
            label2)), loc='upper right', edgecolor='white')
    else:
        bar1 = plt.barh(ind - width / 2, y_one, width, color=c1)
        bar2 = plt.barh(ind + width / 2, y_two, width, color=c2)
        plt.yticks(ind, species)
        plt.xlabel('Y [-]')
        plt.xlim(0, 1)
        plt.legend((bar1, bar2), ('{}'.format(label1), '{}'.format(
            label2)), loc='upper right', edgecolor='white')
    plt.title('$D_p = {}$'.format(title))
    plt.tight_layout()
    plt.savefig(
        os.getcwd() +
        '/' +
        outdir +
        '/' +
        '{}.png'.format(fname),
        bbox_inches='tight')
    plt.close()
    plt.clf()


# Run the script for the following cases:
# Coal: Ignition
time_one = 5.1030  # [ms]
time_two = 4.6830  # [ms]
fname = 'VolatileCompositionCoalIgnition'
plot_volatile_composition(
    loc_C_A90,
    loc_C_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Coal: max OH
time_one = 7.807  # [ms]
time_two = 7.815  # [ms]
fname = 'VolatileCompositionCoalMaxOH'
plot_volatile_composition(
    loc_C_A90,
    loc_C_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Coal: first dvdt peak
time_one = 6.926  # [ms]
time_two = 6.707  # [ms]
fname = 'VolatileCompositionCoalFirstDvdtPeak'
plot_volatile_composition(
    loc_C_A90,
    loc_C_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Coal: second dvdt peak
time_one = 14.644  # [ms]
time_two = 15.295  # [ms]
fname = 'VolatileCompositionCoalSecondDvdtPeak'
plot_volatile_composition(
    loc_C_A90,
    loc_C_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Biomass: Ignition
time_one = 4.7330  # [ms]
time_two = 4.3884  # [ms]
fname = 'VolatileCompositionBiomassIgnition'
plot_volatile_composition(
    loc_B_A90,
    loc_B_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Biomass: max OH
time_one = 7.532  # [ms]
time_two = 7.340  # [ms]
fname = 'VolatileCompositionBiomassMaxOH'
plot_volatile_composition(
    loc_B_A90,
    loc_B_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Biomass: first dvdt peak
time_one = 3.7422  # [ms]
time_two = 3.6225  # [ms]
fname = 'VolatileCompositionBiomassFirstDvdtPeak'
plot_volatile_composition(
    loc_B_A90,
    loc_B_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Biomass: second dvdt peak
time_one = 7.2486  # [ms]
time_two = 7.0155  # [ms]
fname = 'VolatileCompositionBiomassSecondDvdtPeak'
plot_volatile_composition(
    loc_B_A90,
    loc_B_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
# Biomass: third dvdt peak
time_one = 9.2286  # [ms]
time_two = 9.1683  # [ms]
fname = 'VolatileCompositionBiomassThirdDvdtPeak'
plot_volatile_composition(
    loc_B_A90,
    loc_B_O90,
    time_one,
    time_two,
    c_air,
    c_oxy,
    title,
    SpeciesOnXAxis,
    labelA,
    labelO,
    outdir,
    fname)
