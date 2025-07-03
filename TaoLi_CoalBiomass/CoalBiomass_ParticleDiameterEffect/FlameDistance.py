#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path


# ---------------
# INPUTS
# ---------------
dir_name = 'output_FlameDistance'
savefigure = True
enable_1vs1 = True
enable_3vs3 = True
# label names - 1vs1
labelC = 'Coal'
labelB = 'Biomass'
labelA = 'Air'
labelO = 'Oxy'
# label names - 3vs3
labelC1 = 'COL: 90µm'
labelC2 = 'COL: 125µm'
labelC3 = 'COL: 160µm'
labelB1 = 'WS: 90µm'
labelB2 = 'WS: 125µm'
labelB3 = 'WS: 160µm'
title90 = '90µm'
title125 = '125µm'
title160 = '160µm'
# 160µm
tignC160A = 14.232
tignB160A = 12.582
# 125µm
tignC125A = 9.3338
tignB125A = 8.3880
# 90µm
tignC90A = 5.1030
tignB90A = 4.7330
# 90µm oxy
tignC90O = 4.6830
tignB90O = 4.3884
# input data - NOTE: not used
loc_C90A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR90.txt'
loc_B90A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR90.txt'
loc_C125A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR125.txt'
loc_B125A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR125.txt'
loc_C160A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR160.txt'
loc_B160A = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR160.txt'
loc_C90O = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_OXY90.txt'
loc_B90O = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_OXY90.txt'
# input data - smoothed
loc_C90As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR90_smoothed.txt'
loc_B90As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR90_smoothed.txt'
loc_C125As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR125_smoothed.txt'
loc_B125As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR125_smoothed.txt'
loc_C160As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_AIR160_smoothed.txt'
loc_B160As = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_AIR160_smoothed.txt'
loc_C90Os = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_COAL_OXY90_smoothed.txt'
loc_B90Os = 'Input/VolatileFlameDistanceData/VolatileFlameStandOffDistance_BIOMASS_OXY90_smoothed.txt'
# ---------------


def save2dir(name):
    plt.savefig(
        os.getcwd() +
        '/' +
        dir_name +
        '/' +
        name +
        '.png',
        bbox_inches='tight')
    plt.close()
    plt.clf()
    return


# Define font
font = {'size': 18}  # {'family': 'Helvetica', 'size': 18}
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False)

# Create folder
if not os.path.exists(dir_name):
    os.makedirs(os.getcwd() + '/' + dir_name)


def plot_volatile_flame_stand_off_distance(
        time_fd_c, df_fd_c, time_fd_b, df_fd_b, c1, c2, labelC, labelB, title, savefig, smoothed, name, tignC, tignB):

    # due to the smoothing -> mid_flame before ignition should be equal to one
    for i in range(df_fd_c.shape[0]):
        if time_fd_c[i] < tignC:
            df_fd_c['min_flame'][i] = 1.0
            df_fd_c['mid_flame'][i] = 1.0
            df_fd_c['maxflame'][i] = 1.0

    for i in range(df_fd_b.shape[0]):
        if time_fd_b[i] < tignB:
            df_fd_b['min_flame'][i] = 1.0
            df_fd_b['mid_flame'][i] = 1.0
            df_fd_b['maxflame'][i] = 1.0

    # volatile flame stand-off distance
    plt.plot(
        time_fd_c,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameDistanceSmoothed' + name)
        else:
            save2dir('1vs1_FlameDistance' + name)
    else:
        plt.show()

    # IDT lines
    plt.plot(
        time_fd_c,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.axvline(tignC, color=c1, linestyle=':')
    plt.axvline(tignB, color=c2, linestyle=':')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameDistanceSmoothed_IDT' + name)
        else:
            save2dir('1vs1_FlameDistance_IDT' + name)
    else:
        plt.show()

    plt.plot(
        time_fd_c - tignC,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b - tignB,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('$\\Delta time [ms]$')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    plt.xlim(0, max(max(time_fd_c), max(time_fd_b)) - max(tignC, tignB) + 1)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameDistance_t-tignSmoothed' + name)
        else:
            save2dir('1vs1_FlameDistance_t-tign' + name)
    else:
        plt.show()

    # flame thickness
    # if maxlfame - min_flame < 0 => set to zero
    thickness_c = []
    thickness_b = []
    for i in range(len(df_fd_c)):
        if df_fd_c['maxflame'][i] - df_fd_c['min_flame'][i] < 0:
            thickness_c.append(0)
        else:
            thickness_c.append(
                df_fd_c['maxflame'][i] -
                df_fd_c['min_flame'][i])
    for i in range(len(df_fd_b)):
        if df_fd_b['maxflame'][i] - df_fd_b['min_flame'][i] < 0:
            thickness_b.append(0)
        else:
            thickness_b.append(
                df_fd_b['maxflame'][i] -
                df_fd_b['min_flame'][i])

    plt.plot(time_fd_c, thickness_c, color=c1, label='{}'.format(labelC))
    plt.plot(time_fd_b, thickness_b, color=c2, label='{}'.format(labelB))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$l_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameThicknessSmoothed' + name)
        else:
            save2dir('1vs1_FlameThickness' + name)
    else:
        plt.show()

    # IDT lines
    plt.plot(time_fd_c, thickness_c, color=c1, label='{}'.format(labelC))
    plt.plot(time_fd_b, thickness_b, color=c2, label='{}'.format(labelB))
    plt.axvline(tignC, color=c1, linestyle=':')
    plt.axvline(tignB, color=c2, linestyle=':')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$l_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameThicknessSmoothed_IDT' + name)
        else:
            save2dir('1vs1_FlameThickness_IDT' + name)
    else:
        plt.show()

    plt.plot(
        time_fd_c - tignC,
        thickness_c,
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b - tignB,
        thickness_b,
        color=c2,
        label='{}'.format(labelB))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('$\\Delta time [ms]$')
    plt.ylabel(r'$l_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    plt.xlim(0, max(max(time_fd_c), max(time_fd_b)) - max(tignC, tignB) + 1)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameThickness_t-tignSmoothed' + name)
        else:
            save2dir('1vs1_FlameThickness_t-tign' + name)
    else:
        plt.show()

    # volatile flame stand-off distance with flame thickness
    plt.plot(
        time_fd_c,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.fill_between(
        time_fd_c,
        df_fd_c['maxflame'],
        df_fd_c['min_flame'],
        alpha=0.25,
        color=c1)
    plt.fill_between(
        time_fd_b,
        df_fd_b['maxflame'],
        df_fd_b['min_flame'],
        alpha=0.25,
        color=c2)
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameDistanceSmoothedWithFlameThickness' + name)
        else:
            save2dir('1vs1_FlameDistanceWithFlameThickness' + name)
    else:
        plt.show()

    # IDT lines
    plt.plot(
        time_fd_c,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.fill_between(
        time_fd_c,
        df_fd_c['maxflame'],
        df_fd_c['min_flame'],
        alpha=0.25,
        color=c1)
    plt.fill_between(
        time_fd_b,
        df_fd_b['maxflame'],
        df_fd_b['min_flame'],
        alpha=0.25,
        color=c2)
    plt.axvline(tignC, color=c1, linestyle=':')
    plt.axvline(tignB, color=c2, linestyle=':')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    if savefigure:
        if smoothed:
            save2dir('1vs1_FlameDistanceSmoothedWithFlameThickness_IDT' + name)
        else:
            save2dir('1vs1_FlameDistanceWithFlameThickness_IDT' + name)
    else:
        plt.show()

    plt.plot(
        time_fd_c - tignC,
        df_fd_c['mid_flame'],
        color=c1,
        label='{}'.format(labelC))
    plt.plot(
        time_fd_b - tignB,
        df_fd_b['mid_flame'],
        color=c2,
        label='{}'.format(labelB))
    plt.fill_between(
        time_fd_c - tignC,
        df_fd_c['maxflame'],
        df_fd_c['min_flame'],
        alpha=0.25,
        color=c1)
    plt.fill_between(
        time_fd_b - tignB,
        df_fd_b['maxflame'],
        df_fd_b['min_flame'],
        alpha=0.25,
        color=c2)
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('$\\Delta time [ms]$')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 12)
    plt.xlim(0, max(max(time_fd_c), max(time_fd_b)) - max(tignC, tignB) + 1)
    if savefigure:
        if smoothed:
            save2dir(
                '1vs1_FlameDistance_t-tignSmoothedWithFlameThickness' +
                name)
        else:
            save2dir('1vs1_FlameDistance_t-tignWithFlameThickness' + name)
    else:
        plt.show()


if enable_1vs1:
    # Coal-Biomass: 90µm
    df_fd_c = pd.read_csv(loc_C90As, sep='\t')
    df_fd_b = pd.read_csv(loc_B90As, sep='\t')
    # time [s] -> [ms]
    time_fd_c = 1E+03 * df_fd_c['time']
    time_fd_b = 1E+03 * df_fd_b['time']
    # define plot
    c1 = 'green'
    c2 = 'red'
    label1 = labelC
    label2 = labelB
    tign1 = tignC90A
    tign2 = tignB90A
    plot_volatile_flame_stand_off_distance(
        time_fd_c,
        df_fd_c,
        time_fd_b,
        df_fd_b,
        c1,
        c2,
        label1,
        label2,
        title90,
        True,
        False,
        '_Air90',
        tign1,
        tign2)

    # Coal-Biomass: 125µm
    df_fd_c = pd.read_csv(loc_C125As, sep='\t')
    df_fd_b = pd.read_csv(loc_B125As, sep='\t')
    # time [s] -> [ms]
    time_fd_c = 1E+03 * df_fd_c['time']
    time_fd_b = 1E+03 * df_fd_b['time']
    # define plot
    c1 = 'green'
    c2 = 'red'
    label1 = labelC
    label2 = labelB
    tign1 = tignC125A
    tign2 = tignB125A
    plot_volatile_flame_stand_off_distance(
        time_fd_c,
        df_fd_c,
        time_fd_b,
        df_fd_b,
        c1,
        c2,
        label1,
        label2,
        title125,
        True,
        False,
        '_Air125',
        tign1,
        tign2)

    # Coal-Biomass: 160µm
    df_fd_c = pd.read_csv(loc_C160As, sep='\t')
    df_fd_b = pd.read_csv(loc_B160As, sep='\t')
    # time [s] -> [ms]
    time_fd_c = 1E+03 * df_fd_c['time']
    time_fd_b = 1E+03 * df_fd_b['time']
    # define plot
    c1 = 'green'
    c2 = 'red'
    label1 = labelC
    label2 = labelB
    tign1 = tignC160A
    tign2 = tignB160A
    plot_volatile_flame_stand_off_distance(
        time_fd_c,
        df_fd_c,
        time_fd_b,
        df_fd_b,
        c1,
        c2,
        label1,
        label2,
        title160,
        True,
        False,
        '_Air160',
        tign1,
        tign2)

    # Coal: Air-Oxy
    df_fd_c = pd.read_csv(loc_C90As, sep='\t')
    df_fd_b = pd.read_csv(loc_C90Os, sep='\t')
    # time [s] -> [ms]
    time_fd_c = 1E+03 * df_fd_c['time']
    time_fd_b = 1E+03 * df_fd_b['time']
    # define plot
    c1 = 'blue'
    c2 = 'red'
    label1 = labelA
    label2 = labelO
    tign1 = tignC90A
    tign2 = tignC90O
    plot_volatile_flame_stand_off_distance(
        time_fd_c,
        df_fd_c,
        time_fd_b,
        df_fd_b,
        c1,
        c2,
        label1,
        label2,
        title90,
        True,
        False,
        '_COAL_AirOXY',
        tign1,
        tign2)

    # Biomass: Air-Oxy
    df_fd_c = pd.read_csv(loc_B90As, sep='\t')
    df_fd_b = pd.read_csv(loc_B90Os, sep='\t')
    # time [s] -> [ms]
    time_fd_c = 1E+03 * df_fd_c['time']
    time_fd_b = 1E+03 * df_fd_b['time']
    # define plot
    c1 = 'blue'
    c2 = 'red'
    label1 = labelA
    label2 = labelO
    tign1 = tignB90A
    tign2 = tignB90O
    plot_volatile_flame_stand_off_distance(
        time_fd_c,
        df_fd_c,
        time_fd_b,
        df_fd_b,
        c1,
        c2,
        label1,
        label2,
        title90,
        True,
        False,
        '_BIOMASS_AirOXY',
        tign1,
        tign2)


if enable_3vs3:

    #    # Coal-Biomass: 90µm
    #    df_fd_c1 = pd.read_csv(loc_C90As, sep='\t')
    #    df_fd_b1 = pd.read_csv(loc_B90As, sep='\t')
    #    # time [s] -> [ms]
    #    time_fd_c1 = 1E+03 * df_fd_c1['time']
    #    time_fd_b1 = 1E+03 * df_fd_b1['time']
    #
    #    # Coal-Biomass: 125µm
    #    df_fd_c2 = pd.read_csv(loc_C125As, sep='\t')
    #    df_fd_b2 = pd.read_csv(loc_B125As, sep='\t')
    #    # time [s] -> [ms]
    #    time_fd_c2 = 1E+03 * df_fd_c2['time']
    #    time_fd_b2 = 1E+03 * df_fd_b2['time']
    #
    #    # Coal-Biomass: 160µm
    #    df_fd_c3 = pd.read_csv(loc_C160As, sep='\t')
    #    df_fd_b3 = pd.read_csv(loc_B160As, sep='\t')
    #    # time [s] -> [ms]
    #    time_fd_c3 = 1E+03 * df_fd_c3['time']
    #    time_fd_b3 = 1E+03 * df_fd_b3['time']
    #
    #    plt.plot(
    #        time_fd_c1,
    #        df_fd_c1['mid_flame'],
    #        alpha=0.50,
    #        color='blue',
    #        label='{}'.format(labelC1))
    #    plt.plot(
    #        time_fd_c2,
    #        df_fd_c2['mid_flame'],
    #        alpha=0.75,
    #        color='blue',
    #        label='{}'.format(labelC2))
    #    plt.plot(
    #        time_fd_c3,
    #        df_fd_c3['mid_flame'],
    #        color='blue',
    #        label='{}'.format(labelC3))
    #    plt.plot(
    #        time_fd_b1,
    #        df_fd_b1['mid_flame'],
    #        alpha=0.50,
    #        color='red',
    #        label='{}'.format(labelB1))
    #    plt.plot(
    #        time_fd_b2,
    #        df_fd_b2['mid_flame'],
    #        alpha=0.75,
    #        color='red',
    #        label='{}'.format(labelB2))
    #    plt.plot(
    #        time_fd_b3,
    #        df_fd_b3['mid_flame'],
    #        color='red',
    #        label='{}'.format(labelB3))
    #    plt.legend(loc='upper right', edgecolor='white')
    #    plt.xlabel('time [s]')
    #    plt.ylabel(r'$r_f/r_p$ [-]')
    #    #plt.title('$D_p = {}$'.format(title))
    #    plt.ticklabel_format(axis='y', style='scientific',
    #                         scilimits=[-3, 4], useMathText=True)
    #    plt.ylim(0, 11)
    #    if savefigure:
    #        save2dir('3vs3_FlameDistance')
    #    else:
    #        plt.show()

    ###
    # Biomass
    ###
    # Coal-Biomass: 90µm
    df_fd_c1 = pd.read_csv(loc_C90As, sep='\t')
    df_fd_b1 = pd.read_csv(loc_B90As, sep='\t')
    # time [s] -> [ms]
    time_fd_c1 = 1E+03 * df_fd_c1['time']
    time_fd_b1 = 1E+03 * df_fd_b1['time']

    # Coal-Biomass: 125µm
    df_fd_c2 = pd.read_csv(loc_C125As, sep='\t')
    df_fd_b2 = pd.read_csv(loc_B125As, sep='\t')
    # time [s] -> [ms]
    time_fd_c2 = 1E+03 * df_fd_c2['time']
    time_fd_b2 = 1E+03 * df_fd_b2['time']

    # Coal-Biomass: 160µm
    df_fd_c3 = pd.read_csv(loc_C160As, sep='\t')
    df_fd_b3 = pd.read_csv(loc_B160As, sep='\t')
    # time [s] -> [ms]
    time_fd_c3 = 1E+03 * df_fd_c3['time']
    time_fd_b3 = 1E+03 * df_fd_b3['time']
    # flame thickness
    # if maxlfame - min_flame < 0 => set to zero
    thickness_c1 = []
    thickness_c2 = []
    thickness_c3 = []
    thickness_b1 = []
    thickness_b2 = []
    thickness_b3 = []
    for i in range(len(df_fd_c1)):
        if df_fd_c1['maxflame'][i] - df_fd_c1['min_flame'][i] < 0:
            thickness_c1.append(0)
        else:
            thickness_c1.append(
                df_fd_c1['maxflame'][i] -
                df_fd_c1['min_flame'][i])
    for i in range(len(df_fd_b1)):
        if df_fd_b1['maxflame'][i] - df_fd_b1['min_flame'][i] < 0:
            thickness_b1.append(0)
        else:
            thickness_b1.append(
                df_fd_b1['maxflame'][i] -
                df_fd_b1['min_flame'][i])

    for i in range(len(df_fd_c2)):
        if df_fd_c2['maxflame'][i] - df_fd_c2['min_flame'][i] < 0:
            thickness_c2.append(0)
        else:
            thickness_c2.append(
                df_fd_c2['maxflame'][i] -
                df_fd_c2['min_flame'][i])
    for i in range(len(df_fd_b2)):
        if df_fd_b2['maxflame'][i] - df_fd_b2['min_flame'][i] < 0:
            thickness_b2.append(0)
        else:
            thickness_b2.append(
                df_fd_b2['maxflame'][i] -
                df_fd_b2['min_flame'][i])

    for i in range(len(df_fd_c3)):
        if df_fd_c3['maxflame'][i] - df_fd_c3['min_flame'][i] < 0:
            thickness_c3.append(0)
        else:
            thickness_c3.append(
                df_fd_c3['maxflame'][i] -
                df_fd_c3['min_flame'][i])
    for i in range(len(df_fd_b3)):
        if df_fd_b3['maxflame'][i] - df_fd_b3['min_flame'][i] < 0:
            thickness_b3.append(0)
        else:
            thickness_b3.append(
                df_fd_b3['maxflame'][i] -
                df_fd_b3['min_flame'][i])

    plt.plot(
        time_fd_b1,
        df_fd_b1['mid_flame'],
        color='cyan',
        label='{}'.format(labelB1))
    plt.plot(
        time_fd_b2,
        df_fd_b2['mid_flame'],
        color='magenta',
        label='{}'.format(labelB2))
    plt.plot(
        time_fd_b3,
        df_fd_b3['mid_flame'],
        color='lime',
        label='{}'.format(labelB3))
    plt.fill_between(
        time_fd_b1,
        df_fd_b1['maxflame'],
        df_fd_b1['min_flame'],
        alpha=0.25,
        color='cyan')
    plt.fill_between(
        time_fd_b2,
        df_fd_b2['maxflame'],
        df_fd_b2['min_flame'],
        alpha=0.25,
        color='magenta')
    plt.fill_between(
        time_fd_b3,
        df_fd_b3['maxflame'],
        df_fd_b3['min_flame'],
        alpha=0.25,
        color='lime')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    #plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 15)
    if savefigure:
        save2dir('3vs3_FlameDistance_Biomass')
        # plt.show()
    else:
        plt.show()

    ###
    # Coal
    ###
    # Coal-Biomass: 90µm
    df_fd_c1 = pd.read_csv(loc_C90As, sep='\t')
    df_fd_b1 = pd.read_csv(loc_B90As, sep='\t')
    # time [s] -> [ms]
    time_fd_c1 = 1E+03 * df_fd_c1['time']
    time_fd_b1 = 1E+03 * df_fd_b1['time']

    # Coal-Biomass: 125µm
    df_fd_c2 = pd.read_csv(loc_C125As, sep='\t')
    df_fd_b2 = pd.read_csv(loc_B125As, sep='\t')
    # time [s] -> [ms]
    time_fd_c2 = 1E+03 * df_fd_c2['time']
    time_fd_b2 = 1E+03 * df_fd_b2['time']

    # Coal-Biomass: 160µm
    df_fd_c3 = pd.read_csv(loc_C160As, sep='\t')
    df_fd_b3 = pd.read_csv(loc_B160As, sep='\t')
    # time [s] -> [ms]
    time_fd_c3 = 1E+03 * df_fd_c3['time']
    time_fd_b3 = 1E+03 * df_fd_b3['time']
    # flame thickness
    # if maxlfame - min_flame < 0 => set to zero
    thickness_c1 = []
    thickness_c2 = []
    thickness_c3 = []
    thickness_b1 = []
    thickness_b2 = []
    thickness_b3 = []
    for i in range(len(df_fd_c1)):
        if df_fd_c1['maxflame'][i] - df_fd_c1['min_flame'][i] < 0:
            thickness_c1.append(0)
        else:
            thickness_c1.append(
                df_fd_c1['maxflame'][i] -
                df_fd_c1['min_flame'][i])
    for i in range(len(df_fd_b1)):
        if df_fd_b1['maxflame'][i] - df_fd_b1['min_flame'][i] < 0:
            thickness_b1.append(0)
        else:
            thickness_b1.append(
                df_fd_b1['maxflame'][i] -
                df_fd_b1['min_flame'][i])

    for i in range(len(df_fd_c2)):
        if df_fd_c2['maxflame'][i] - df_fd_c2['min_flame'][i] < 0:
            thickness_c2.append(0)
        else:
            thickness_c2.append(
                df_fd_c2['maxflame'][i] -
                df_fd_c2['min_flame'][i])
    for i in range(len(df_fd_b2)):
        if df_fd_b2['maxflame'][i] - df_fd_b2['min_flame'][i] < 0:
            thickness_b2.append(0)
        else:
            thickness_b2.append(
                df_fd_b2['maxflame'][i] -
                df_fd_b2['min_flame'][i])

    for i in range(len(df_fd_c3)):
        if df_fd_c3['maxflame'][i] - df_fd_c3['min_flame'][i] < 0:
            thickness_c3.append(0)
        else:
            thickness_c3.append(
                df_fd_c3['maxflame'][i] -
                df_fd_c3['min_flame'][i])
    for i in range(len(df_fd_b3)):
        if df_fd_b3['maxflame'][i] - df_fd_b3['min_flame'][i] < 0:
            thickness_b3.append(0)
        else:
            thickness_b3.append(
                df_fd_b3['maxflame'][i] -
                df_fd_b3['min_flame'][i])
    plt.plot(
        time_fd_c1,
        df_fd_c1['mid_flame'],
        color='cyan',
        label='{}'.format(labelC1))
    plt.plot(
        time_fd_c2,
        df_fd_c2['mid_flame'],
        color='magenta',
        label='{}'.format(labelC2))
    plt.plot(
        time_fd_c3,
        df_fd_c3['mid_flame'],
        color='lime',
        label='{}'.format(labelC3))
    plt.fill_between(
        time_fd_c1,
        df_fd_c1['maxflame'],
        df_fd_c1['min_flame'],
        alpha=0.25,
        color='cyan')
    plt.fill_between(
        time_fd_c2,
        df_fd_c2['maxflame'],
        df_fd_c2['min_flame'],
        alpha=0.25,
        color='magenta')
    plt.fill_between(
        time_fd_c3,
        df_fd_c3['maxflame'],
        df_fd_c3['min_flame'],
        alpha=0.25,
        color='lime')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$r_f/r_p$ [-]')
    #plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 15)
    if savefigure:
        save2dir('3vs3_FlameDistance_Coal')
        # plt.show()
    else:
        plt.show()

    def clipp_data_before_ignition(df, ign):
        for i in range(df.shape[0]):
            if df['time'][i] * 1E+3 >= ign:
                break
        df = df.iloc[i:]
        df = df.set_index(np.arange(0, int(df.shape[0])))
        df['time'] = df['time'] - ign * 1E-03
        return df

    ###
    # Biomass: t - tign
    ###
    # Coal-Biomass: 90µm
    df_fd_b1 = pd.read_csv(loc_B90As, sep='\t')
    # clipp data before ignition
    df_fd_b1 = clipp_data_before_ignition(df_fd_b1, tignB90A)
    # time [s] -> [ms] and
    time_fd_b1 = 1E+03 * df_fd_b1['time']

    # Coal-Biomass: 125µm
    df_fd_b2 = pd.read_csv(loc_B125As, sep='\t')
    # clipp data before ignition
    df_fd_b2 = clipp_data_before_ignition(df_fd_b2, tignB125A)
    # time [s] -> [ms]
    time_fd_b2 = 1E+03 * df_fd_b2['time']

    # Coal-Biomass: 160µm
    df_fd_b3 = pd.read_csv(loc_B160As, sep='\t')
    # clipp data before ignition
    df_fd_b3 = clipp_data_before_ignition(df_fd_b3, tignB160A)
    # time [s] -> [ms]
    time_fd_b3 = 1E+03 * df_fd_b3['time']

    # Ignition delay times
    tignb1 = tignB90A
    tignb2 = tignB125A
    tignb3 = tignB160A

    # flame thickness
    # if maxlfame - min_flame < 0 => set to zero
    thickness_b1 = []
    thickness_b2 = []
    thickness_b3 = []
    for i in range(df_fd_b1.shape[0]):
        if df_fd_b1['maxflame'][i] - df_fd_b1['min_flame'][i] < 0:
            thickness_b1.append(0)
        else:
            thickness_b1.append(
                df_fd_b1['maxflame'][i] -
                df_fd_b1['min_flame'][i])
    for i in range(len(df_fd_b2)):
        if df_fd_b2['maxflame'][i] - df_fd_b2['min_flame'][i] < 0:
            thickness_b2.append(0)
        else:
            thickness_b2.append(
                df_fd_b2['maxflame'][i] -
                df_fd_b2['min_flame'][i])
    for i in range(len(df_fd_b3)):
        if df_fd_b3['maxflame'][i] - df_fd_b3['min_flame'][i] < 0:
            thickness_b3.append(0)
        else:
            thickness_b3.append(
                df_fd_b3['maxflame'][i] -
                df_fd_b3['min_flame'][i])

    plt.plot(
        time_fd_b1,
        df_fd_b1['mid_flame'],
        color='cyan',
        label='{}'.format(labelB1))
    plt.plot(
        time_fd_b2,
        df_fd_b2['mid_flame'],
        color='magenta',
        label='{}'.format(labelB2))
    plt.plot(
        time_fd_b3,
        df_fd_b3['mid_flame'],
        color='lime',
        label='{}'.format(labelB3))
    plt.fill_between(
        time_fd_b1,
        df_fd_b1['maxflame'],
        df_fd_b1['min_flame'],
        alpha=0.25,
        color='cyan')
    plt.fill_between(
        time_fd_b2,
        df_fd_b2['maxflame'],
        df_fd_b2['min_flame'],
        alpha=0.25,
        color='magenta')
    plt.fill_between(
        time_fd_b3,
        df_fd_b3['maxflame'],
        df_fd_b3['min_flame'],
        alpha=0.25,
        color='lime')

    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('$\\Delta time [ms]$')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 15)
    if savefigure:
        save2dir('3vs3_FlameDistance_Biomass_t-tign')
    else:
        plt.show()

    ###
    # Coal t-tign
    ###
    # Coal-Biomass: 90µm
    df_fd_c1 = pd.read_csv(loc_C90As, sep='\t')
    # clipp data before ignition
    df_fd_c1 = clipp_data_before_ignition(df_fd_c1, tignC90A)
    # time [s] -> [ms]
    time_fd_c1 = 1E+03 * df_fd_c1['time']

    # Coal-Biomass: 125µm
    df_fd_c2 = pd.read_csv(loc_C125As, sep='\t')
    # clipp data before ignition
    df_fd_c2 = clipp_data_before_ignition(df_fd_c2, tignC125A)
    # time [s] -> [ms]
    time_fd_c2 = 1E+03 * df_fd_c2['time']

    # Coal-Biomass: 160µm
    df_fd_c3 = pd.read_csv(loc_C160As, sep='\t')
    # clipp data before ignition
    df_fd_c3 = clipp_data_before_ignition(df_fd_c3, tignC160A)
    # time [s] -> [ms]
    time_fd_c3 = 1E+03 * df_fd_c3['time']

    # Ignition delay time
    tignc1 = tignC90A
    tignc2 = tignC125A
    tignc3 = tignC160A

    # flame thickness
    # if maxlfame - min_flame < 0 => set to zero
    thickness_c1 = []
    thickness_c2 = []
    thickness_c3 = []
    for i in range(df_fd_c1.shape[0]):
        if df_fd_c1['maxflame'][i] - df_fd_c1['min_flame'][i] < 0:
            thickness_c1.append(0)
        else:
            thickness_c1.append(
                df_fd_c1['maxflame'][i] -
                df_fd_c1['min_flame'][i])
    for i in range(df_fd_c2.shape[0]):
        if df_fd_c2['maxflame'][i] - df_fd_c2['min_flame'][i] < 0:
            thickness_c2.append(0)
        else:
            thickness_c2.append(
                df_fd_c2['maxflame'][i] -
                df_fd_c2['min_flame'][i])
    for i in range(df_fd_c3.shape[0]):
        if df_fd_c3['maxflame'][i] - df_fd_c3['min_flame'][i] < 0:
            thickness_c3.append(0)
        else:
            thickness_c3.append(
                df_fd_c3['maxflame'][i] -
                df_fd_c3['min_flame'][i])

    plt.plot(
        time_fd_c1,
        df_fd_c1['mid_flame'],
        color='cyan',
        label='{}'.format(labelC1))
    plt.plot(
        time_fd_c2,
        df_fd_c2['mid_flame'],
        color='magenta',
        label='{}'.format(labelC2))
    plt.plot(
        time_fd_c3,
        df_fd_c3['mid_flame'],
        color='lime',
        label='{}'.format(labelC3))
    plt.fill_between(
        time_fd_c1,
        df_fd_c1['maxflame'],
        df_fd_c1['min_flame'],
        alpha=0.25,
        color='cyan')
    plt.fill_between(
        time_fd_c2,
        df_fd_c2['maxflame'],
        df_fd_c2['min_flame'],
        alpha=0.25,
        color='magenta')
    plt.fill_between(
        time_fd_c3,
        df_fd_c3['maxflame'],
        df_fd_c3['min_flame'],
        alpha=0.25,
        color='lime')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('$\\Delta time [ms]$')
    plt.ylabel(r'$r_f/r_p$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1, 15)
    if savefigure:
        save2dir('3vs3_FlameDistance_Coal_t-tign')
    else:
        plt.show()
