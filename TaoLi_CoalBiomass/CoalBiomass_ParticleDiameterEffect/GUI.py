#!/usr/bin/python3
# -*- coding: utf-8 -*-


import os
import sys
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
from pathlib import Path
from scipy.signal import find_peaks
from scipy.signal import argrelextrema
from core import Z_Bilger as zbilger


# ---------------
# INPUTS
# ---------------
# Define output directory
dir_name = 'output_gui'
# IDT: % of peak OH
idt_p = 0.10
# What do you want to plot?
enable_1vs1 = True
enable_2vs2 = True
enable_3vs3 = True
enable_volumetric = True
# Save plots
savefigure = True
# Define labels for 1vs1
labelA = 'Air'
labelO = 'Oxy'
labelC = 'Coal'
labelB = 'Biomass'
# Define label for 3vs3
labelC1 = 'Coal: 90µm'
labelC2 = 'Coal: 125µm'
labelC3 = 'Coal: 160µm'
Dp1 = 0.090
Dp2 = 0.125
Dp3 = 0.160
pi6 = (3.14/6)
labelB1 = 'Biomass: 90µm'
labelB2 = 'Biomass: 125µm'
labelB3 = 'Biomass: 160µm'
# Define particle diameters
Dpar = [90, 125, 160]
# Define colors
color_coal = 'green'
color_biomass = 'red'
color_air = 'blue'
color_oxy = 'red'
# Define initial oxygen molefraction
YO2_air = 0.2242
YO2_oxy = 0.1733
# Location of all monitor files
loc_C_O90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/OXY-20-DP-90/monitor/'
loc_C_A90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/AIR-20-DP-90/monitor/'
loc_C_A125 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/AIR-20-DP-125/monitor/'
loc_C_A160 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/COAL/AIR-20-DP-160/monitor/'
loc_B_O90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/OXY-20-DP-90/monitor/'
loc_B_A90 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/AIR-20-DP-90/monitor/'
loc_B_A125 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/AIR-20-DP-125/monitor/'
loc_B_A160 = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/AIR-20-DP-160/monitor/'
# ----------

# Define font
#font = {'family': 'Helvetica', 'size': 18}
font = {'size': 18}
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False)

# Create output folder
if not os.path.exists(dir_name):
    os.makedirs(os.getcwd() + '/' + dir_name)


def save2dir(name, subdir):
    plt.savefig(os.getcwd() + '/' + dir_name + '/' + subdir + '/' +
                name + '.png', bbox_inches='tight')
    plt.close()
    plt.clf()


def compute_idt_based_on_OH(df):
    #data = np.array(list(df['max_OH']))
    #print(data[argrelextrema(data, np.greater)[0]])
    # peaks, _ = find_peaks(df[], )
    # 500 random... AIR + OXY 0.006
    peaks, _ = find_peaks(df['max_OH'], height=0.006, distance=1250)  # TODO
    idt = df['max_OH'][peaks[0]] * idt_p
    # print(idt)
    # Igniton Delay Time = 10% of the peak OH value
    #idt = max(df['max_OH']) * idt_p
    # print(max(df['max_OH']))
    #####inde = (df['max_OH'][df['max_OH'] == max(df['max_OH'])].index.tolist())
    # print(inde)
    # print(list(inde))
    # print(df['time'][inde])
    #plt.plot(df['time'], df['max_OH'])
    #plt.scatter(df['time'][peaks], df['max_OH'][peaks], color='red')
    # plt.show()
    # sys.exit()
    for i in range(len(df['max_OH'])):
        if idt <= df['max_OH'][i]:
            ignition_delay_time = df['time'][i] * 1E+03  # [ms]
            break

    return ignition_delay_time


# def Compute_IDT_T(df): # TODO
#    # Ignition Delay Time = 10% of the first 'Tgas' peak
#    # ignition temperature must be higher than 2000K!
#    peaks, properties = find_peaks(df['max_T'], height=2000, distance=100)
#    peak_temp = list(df['max_T'][peaks])
#    #time = list(df['time'][peaks])
#    ignition_delay = 0
#    for i in range(len(peak_temp) - 1):
#        if np.greater(peak_temp[i], peak_temp[i + 1]):
#            idt = df['max_T'][0] + (peak_temp[i] - df['max_T'][0]) * idt_p
#            for j in range(len(df['max_T'])):
#                if idt <= df['max_T'][j]:
#                    ignition_delay = df['time'][j] * 1E+03  # [ms]
#                    #print('ignition delay time: ', ignition_delay)
#                    break
#            break
#
#    #plt.plot(df['time'] * 1E+03, df['max_T'])
#    # plt.axvline(ignition_delay)
#    # plt.show()
#    return ignition_delay


def plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1, YO2_ox2, c1, c2, label1, label2, case, title, Dpar):

    # compute ignition delay time
    idt_one = compute_idt_based_on_OH(df_one_s)
    idt_two = compute_idt_based_on_OH(df_two_s)
    idt = [idt_one, idt_two]

    # time [s] -> ms
    df_one_c['time'] = df_one_c['time'] * 1E+03
    df_two_c['time'] = df_two_c['time'] * 1E+03
    df_one_s['time'] = df_one_s['time'] * 1E+03
    df_two_s['time'] = df_two_s['time'] * 1E+03

    # TG (= mass loss)
    plt.plot(df_one_c['time'], df_one_c['Mmax'] / df_one_c['Mmax'][0],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['Mmax'] / df_two_c['Mmax'][0],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='lower left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('TG [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.05)
    if savefigure:
        save2dir('1vs1_TG', case)
    else:
        plt.show()

    # Ash
    plt.plot(df_one_c['time'], df_one_c['ASH_max'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['ASH_max'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('ash [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 0.18)
    if savefigure:
        save2dir('1vs1_ash', case)
    else:
        plt.show()

    # Moisture
    plt.plot(df_one_c['time'], df_one_c['MOIST_max'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['MOIST_max'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('moisture [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('1vs1_moist', case)
    else:
        plt.show()

    # dvdt
    plt.plot(df_one_c['time'], df_one_c['dvdtmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dvdtmax'],
             color=c2, label='{}'.format(label2))
    if title != '160µm':
        plt.legend(loc='upper right', edgecolor='white')
    else:
        plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/s]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.2E-4)
    if savefigure:
        save2dir('1vs1_dvdt', case)
    else:
        plt.show()

    # dvdt + idt
    plt.plot(df_one_c['time'], df_one_c['dvdtmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dvdtmax'],
             color=c2, label='{}'.format(label2))
    plt.axvline(idt_one, color=c1, linestyle='--')
    plt.axvline(idt_two, color=c2, linestyle='--')
    if title != '160µm':
        plt.legend(loc='upper right', edgecolor='white')
    else:
        plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/s]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.2E-4)
    if savefigure:
        save2dir('1vs1_dvdt_idt', case)
    else:
        plt.show()

    # dvdt - vol
    # NOTE dvdt [g/s]
    plt.plot(df_one_c['time'], df_one_c['dvdtmax'] / ((pi6)*(Dpar**3)) / 1000,
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dvdtmax'] / ((pi6)*(Dpar**3)) / 1000,
             color=c2, label='{}'.format(label2))
    if title != '160µm':
        plt.legend(loc='upper right', edgecolor='white')
    else:
        plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/(mm³s)]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.4E-4)
    if savefigure:
        save2dir('1vs1_dvdt_vol', case)
    else:
        plt.show()

    # dvdt + idt - vol
    plt.plot(df_one_c['time'], df_one_c['dvdtmax'] / ((pi6)*(Dpar**3)) / 1000,
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dvdtmax'] / ((pi6)*(Dpar**3)) / 1000,
             color=c2, label='{}'.format(label2))
    plt.axvline(idt_one, color=c1, linestyle='--')
    plt.axvline(idt_two, color=c2, linestyle='--')
    if title != '160µm':
        plt.legend(loc='upper right', edgecolor='white')
    else:
        plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/(mm³s)]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.4E-4)
    if savefigure:
        save2dir('1vs1_dvdt_idt_vol', case)
    else:
        plt.show()

    # dchdt
    plt.plot(df_one_c['time'], df_one_c['dchdtmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dchdtmax'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{char}$ [kg/s]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.25E-06)
    if savefigure:
        save2dir('1vs1_dchdt', case)
    else:
        plt.show()

    # Umax
    plt.plot(df_one_c['time'], df_one_c['Umax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['Umax'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('U [m/s]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0.2, 1.65)
    if savefigure:
        save2dir('1vs1_Umax', case)
    else:
        plt.show()

    # Particle temperature
    plt.plot(df_one_c['time'], df_one_c['Tmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['Tmax'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$T_{prt}$ [K]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(250, 1850)
    if savefigure:
        save2dir('1vs1_Tprt', case)
    else:
        plt.show()

    # Tgpmax
    plt.plot(df_one_c['time'], df_one_c['Tgpmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['Tgpmax'],
             color=c2, label='{}'.format(label2))
    if title != '160µm':
        plt.legend(loc='lower right', edgecolor='white')
    else:
        plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$T_{gp}$ [K]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1600, 2400)
    if savefigure:
        save2dir('1vs1_Tgpmax', case)
    else:
        plt.show()

    # Gas temperature
    plt.plot(df_one_s['time'], df_one_s['max_T'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_s['time'], df_two_s['max_T'],
             color=c2, label='{}'.format(label2))
    if title == '125µm':
        plt.legend(loc='lower right', edgecolor='white')
    elif title == '160µm':
        plt.legend(loc='upper left', edgecolor='white')
    else:
        if case == 'CoalBiomassAIR90µm':
            plt.legend(loc='lower center', edgecolor='white')
        elif case == 'CoalBiomassOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'BiomassAIRvsOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'CoalAIRvsOXY90µm':
            plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$T_{gas}$ [K]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1800, 2600)
    if savefigure:
        save2dir('1vs1_Tgas', case)
    else:
        plt.show()

    # Gas temperature + idt
    plt.plot(df_one_s['time'], df_one_s['max_T'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_s['time'], df_two_s['max_T'],
             color=c2, label='{}'.format(label2))
    plt.axvline(idt_one, color=c1, linestyle=':')
    plt.axvline(idt_two, color=c2, linestyle=':')
    if title == '125µm':
        plt.legend(loc='lower right', edgecolor='white')
    elif title == '160µm':
        plt.legend(loc='upper left', edgecolor='white')
    else:
        if case == 'CoalBiomassAIR90µm':
            plt.legend(loc='lower center', edgecolor='white')
        elif case == 'CoalBiomassOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'BiomassAIRvsOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'CoalAIRvsOXY90µm':
            plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$T_{gas}$ [K]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(1800, 2600)
    if savefigure:
        save2dir('1vs1_Tgas_idt', case)
    else:
        plt.show()

    # Ignition delay time
    plt.scatter('', idt_one, marker='s', color=c1,
                label='{}'.format(label1))
    plt.scatter('', idt_two, marker='^', color=c2, label='{}'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    if int(min(idt)) > 0:
        plt.ylim(int(min(idt)), int(max(idt)) + 1)
    else:
        plt.ylim(0, int(max(idt)) + 1)
    plt.minorticks_on()
    plt.ylabel(r'$\tau_{ign}$ [ms]')
    plt.xlabel('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('1vs1_IDT', case)
    else:
        plt.show()

    # OH
    plt.plot(df_one_s['time'], df_one_s['max_OH'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_s['time'], df_two_s['max_OH'],
             color=c2, label='{}'.format(label2))
    if title == '125µm':
        plt.legend(loc='lower right', edgecolor='white')
    elif title == '160µm':
        plt.legend(loc='upper left', edgecolor='white')
    else:
        if case == 'CoalBiomassAIR90µm':
            plt.legend(loc='lower center', edgecolor='white')
        elif case == 'CoalBiomassOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'BiomassAIRvsOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'CoalAIRvsOXY90µm':
            plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$Y_{OH}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 0.016)
    if savefigure:
        save2dir('1vs1_YOH', case)
    else:
        plt.show()

    # OH + idt
    plt.plot(df_one_s['time'], df_one_s['max_OH'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_s['time'], df_two_s['max_OH'],
             color=c2, label='{}'.format(label2))
    plt.axvline(idt_one, color=c1, linestyle=':')
    plt.axvline(idt_two, color=c2, linestyle=':')
    if title == '125µm':
        plt.legend(loc='lower right', edgecolor='white')
    elif title == '160µm':
        plt.legend(loc='upper left', edgecolor='white')
    else:
        if case == 'CoalBiomassAIR90µm':
            plt.legend(loc='lower center', edgecolor='white')
        elif case == 'CoalBiomassOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'BiomassAIRvsOXY90µm':
            plt.legend(loc='upper right', edgecolor='white')
        elif case == 'CoalAIRvsOXY90µm':
            plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('$Y_{OH}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 0.016)
    if savefigure:
        save2dir('1vs1_YOH_idt', case)
    else:
        plt.show()

    # dTpdtmax
    plt.plot(df_one_c['time'], df_one_c['dTpdtmax'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_c['time'], df_two_c['dTpdtmax'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{T}_{prt}$ [K/s]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 300000)
    if savefigure:
        save2dir('1vs1_dTpdtmax', case)
    else:
        plt.show()

    # Zmix
    plt.plot(df_one_s['time'], df_one_s['max_ZMIX'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_s['time'], df_two_s['max_ZMIX'],
             color=c2, label='{}'.format(label2))
    if title != '90µm':
        plt.legend(loc='upper left', edgecolor='white')
    else:
        plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$Z_{mix}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 0.4)
    if savefigure:
        save2dir('1vs1_Zmix', case)
    else:
        plt.show()

    # Z-Bilger
    feedstock1 = 'Coal'
    feedstock2 = 'Coal'
    if 'CH3OH_max' in df_one_c.columns:
        feedstock1 = 'Biomass'
    if 'CH3OH_max' in df_two_c.columns:
        feedstock2 = 'Biomass'
    if feedstock1 == 'Coal':
        df_1 = zbilger.MixtureFractionCoal(df_one_c, YO2_ox1)
        plt.plot(df_one_c['time'], df_1['Z'],
                 color=c1, label='{}'.format(label1))
    else:
        df_1 = zbilger.MixtureFractionBiomass(df_one_c, YO2_ox1)
        plt.plot(df_one_c['time'], df_1['Z'],
                 color=c1, label='{}'.format(label1))
    if feedstock2 == 'Coal':
        df_2 = zbilger.MixtureFractionCoal(df_two_c, YO2_ox2)
        plt.plot(df_two_c['time'], df_2['Z'],
                 color=c2, label='{}'.format(label2))
    else:
        df_2 = zbilger.MixtureFractionBiomass(df_two_c, YO2_ox2)
        plt.plot(df_two_c['time'], df_2['Z'],
                 color=c2, label='{}'.format(label2))
    plt.legend(loc='lower right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$Z$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1)
    if savefigure:
        save2dir('1vs1_ZBilger', case)
    else:
        plt.show()


def plot_2vs2(df_one_s1, df_one_s2, df_two_s1, df_two_s2, c1, c2, label1, label2, case, title):

    # ignition delay time
    idt_one_1 = compute_idt_based_on_OH(df_one_s1)
    idt_one_2 = compute_idt_based_on_OH(df_one_s2)
    idt_two_1 = compute_idt_based_on_OH(df_two_s1)
    idt_two_2 = compute_idt_based_on_OH(df_two_s2)

    # time [s] -> ms
    df_one_s1['time'] = df_one_s1['time'] * 1E+03
    df_two_s1['time'] = df_two_s1['time'] * 1E+03
    df_one_s2['time'] = df_one_s2['time'] * 1E+03
    df_two_s2['time'] = df_two_s2['time'] * 1E+03

    # OH + idt
    plt.plot(df_one_s1['time'], df_one_s1['max_OH'],
             color=c1, label='{}: Air'.format(label1))
    plt.plot(df_one_s2['time'], df_one_s2['max_OH'],
             color=c1, linestyle='--', label='{}: Oxy'.format(label1))
    plt.plot(df_two_s1['time'], df_two_s1['max_OH'],
             color=c2, label='{}: Air'.format(label2))
    plt.plot(df_two_s2['time'], df_two_s2['max_OH'],
             color=c2, linestyle='--', label='{}: Oxy'.format(label2))
    plt.axvline(idt_one_1, color=c1, linestyle='-')
    plt.axvline(idt_one_2, color=c1, linestyle='--')
    plt.axvline(idt_two_1, color=c2, linestyle='-')
    plt.axvline(idt_two_2, color=c2, linestyle='--')
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlim(0, 40)
    plt.xlabel('time [ms]')
    plt.ylabel('$Y_{OH}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('2vs2_YOH_IDT', case)
    else:
        plt.show()

    # OH
    plt.plot(df_one_s1['time'], df_one_s1['max_OH'],
             color=c1, label='{}: Air'.format(label1))
    plt.plot(df_one_s2['time'], df_one_s2['max_OH'],
             color=c1, linestyle='--', label='{}: Oxy'.format(label1))
    plt.plot(df_two_s1['time'], df_two_s1['max_OH'],
             color=c2, label='{}: Air'.format(label2))
    plt.plot(df_two_s2['time'], df_two_s2['max_OH'],
             color=c2, linestyle='--', label='{}: Oxy'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlim(0, 40)
    plt.xlabel('time [ms]')
    plt.ylabel('$Y_{OH}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('2vs2_YOH', case)
    else:
        plt.show()


def plot_3vs3(df_one_s1, df_one_s2, df_one_s3, df_two_s1, df_two_s2, df_two_s3, df_one_c1, df_one_c2, df_one_c3, df_two_c1, df_two_c2, df_two_c3, c1, c2, label1, label2, case):

    # Ignition delay time
    idt_one1 = compute_idt_based_on_OH(df_one_s1)
    idt_one2 = compute_idt_based_on_OH(df_one_s2)
    idt_one3 = compute_idt_based_on_OH(df_one_s3)
    idt_two1 = compute_idt_based_on_OH(df_two_s1)
    idt_two2 = compute_idt_based_on_OH(df_two_s2)
    idt_two3 = compute_idt_based_on_OH(df_two_s3)

    idt_one = [idt_one1, idt_one2, idt_one3]
    idt_two = [idt_two1, idt_two2, idt_two3]

    # time [s] -> [ms]
    df_one_s1['time'] = df_one_s1['time'] * 1E+03
    df_two_s1['time'] = df_two_s1['time'] * 1E+03
    df_one_s2['time'] = df_one_s2['time'] * 1E+03
    df_two_s2['time'] = df_two_s2['time'] * 1E+03
    df_one_s3['time'] = df_one_s3['time'] * 1E+03
    df_two_s3['time'] = df_two_s3['time'] * 1E+03

    df_one_c1['time'] = df_one_c1['time'] * 1E+03
    df_two_c1['time'] = df_two_c1['time'] * 1E+03
    df_one_c2['time'] = df_one_c2['time'] * 1E+03
    df_two_c2['time'] = df_two_c2['time'] * 1E+03
    df_one_c3['time'] = df_one_c3['time'] * 1E+03
    df_two_c3['time'] = df_two_c3['time'] * 1E+03

    # IDT: Coal vs Biomass
    plt.plot(Dpar, idt_one, marker='s', color=c1,
             label='{}'.format(label1))
    plt.plot(Dpar, idt_two, marker='^', color=c2,
             linestyle='--', label='{}'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.minorticks_on()
    plt.xlim(80, 180)
    plt.ylim(0, 16)
    plt.xlabel('$D_{p}$ [µm]')
    plt.ylabel(r'$\tau_{ign}$ [ms]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('3vs3_IDT', case)
    else:
        plt.show()

    # IDT: Coal (simulation) vs Li et al.
    Li_air20_c1 = pd.read_csv('Input/Data_IDT_Li/AIR20_C1.csv', sep=',')
    Li_air20_c2 = pd.read_csv('Input/Data_IDT_Li/AIR20_C2.csv', sep=',')
    Li_air20_c3 = pd.read_csv('Input/Data_IDT_Li/AIR20_C3.csv', sep=',')
    plt.scatter(Li_air20_c1['dp'], Li_air20_c1['ign'],
                marker='x', alpha=0.25, color='grey', label='C1')
    plt.scatter(Li_air20_c2['dp'], Li_air20_c2['ign'],
                marker='x', alpha=0.25, color='lightseagreen', label='C2')
    plt.scatter(Li_air20_c3['dp'], Li_air20_c3['ign'],
                marker='x', alpha=0.25, color='lime', label='C3')
    plt.plot(Dpar, idt_one, marker='^', color=c1,
             linewidth=3, label='AIR num.'.format(label1))
    #plt.errorbar(107.56, 4.328, 0.9, 13, marker='d', color='grey', lw=3, capsize=6, alpha=0.3)
    #plt.errorbar(124.4, 5.89, 1.7, 11, marker='o', color='lightseagreen', lw=3, capsize=6, alpha=0.3)
    leg_lines = (Line2D([0], [0], marker='x', lw=0, color='black', label='AIR exp.', markersize=14),
                 Line2D([0], [0], color='green', lw=3, label='Coal num.'))
    plt.legend(loc='upper left', edgecolor='white')
    plt.minorticks_on()
    plt.xlim(80, 180)
    plt.ylim(0, 16)
    plt.xlabel('$D_{p}$ [µm]')
    plt.ylabel(r'$\tau_{ign}$ [ms]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('3vs3_Coal_Li', case)
    else:
        plt.show()

    # IDT: Biomass (simulation) vs Li et al.
    Li_air20_b1 = pd.read_csv('Input/Data_IDT_Li/AIR20_W1.csv', sep=',')
    Li_air20_b2 = pd.read_csv('Input/Data_IDT_Li/AIR20_W2.csv', sep=',')
    Li_air20_b3 = pd.read_csv('Input/Data_IDT_Li/AIR20_W3.csv', sep=',')
    plt.scatter(Li_air20_b1['dp'], Li_air20_b1['ign'],
                marker='x', alpha=0.25, color='olive', label='WS1')
    plt.scatter(Li_air20_b2['dp'], Li_air20_b2['ign'],
                marker='x', alpha=0.25, color='purple', label='WS2')
    plt.scatter(Li_air20_b3['dp'], Li_air20_b3['ign'],
                marker='x', alpha=0.25, color='navy', label='WS3')
    plt.plot(Dpar, idt_two, marker='^', color=c2,
             linewidth=3, label='AIR num.'.format(label2))
    #plt.errorbar(122.67, 6.363, 2.5, 16, marker='d', color='olive', lw=3, capsize=6, alpha=0.3)
    #plt.errorbar(154.67, 8.03, 2.5, 21, marker='o', color='purple', lw=3, capsize=6, alpha=0.3)
    # leg_lines = (Line2D([0], [0], marker='x', lw=0, color='black', label='AIR exp.', markersize=14),
    #          #Line2D([0], [0], marker='+', lw=0, color='black', label='OXY exp.', markersize=14),
    #          Line2D([0], [0], color='red', lw=3, label='Biomass num.'))
    plt.minorticks_on()
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlim(80, 180)
    plt.ylim(0, 16)
    plt.minorticks_on()
    plt.xlabel('$D_{p}$ [µm]')
    plt.ylabel(r'$\tau_{ign}$ [ms]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    if savefigure:
        save2dir('3vs3_BIO_Li', case)
    else:
        plt.show()

    # TG (= mass loss): Coal
    plt.plot(df_one_c1['time'], df_one_c1['Mmax'] / df_one_c1['Mmax'][0],
             color='cyan', label='{}: 90µm'.format(label1))
    plt.plot(df_one_c2['time'], df_one_c2['Mmax'] / df_one_c2['Mmax'][0],
             color='magenta', label='{}: 125µm'.format(label1))
    plt.plot(df_one_c3['time'], df_one_c3['Mmax'] / df_one_c3['Mmax']
             [0], color='lime', label='{}: 160µm'.format(label1))
    plt.legend(loc='lower left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('TG [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.05)
    if savefigure:
        save2dir('3vs3_mass_loss_Coal', case)
    else:
        plt.show()

    # TG (= mass loss): Biomass
    plt.plot(df_two_c1['time'], df_two_c1['Mmax'] / df_two_c1['Mmax'][0],
             color='cyan', label='{}: 90µm'.format(label2))
    plt.plot(df_two_c2['time'], df_two_c2['Mmax'] / df_two_c2['Mmax'][0],
             color='magenta', label='{}: 125µm'.format(label2))
    plt.plot(df_two_c3['time'], df_two_c3['Mmax'] / df_two_c3['Mmax']
             [0], color='lime', label='{}: 160µm'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel('TG [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.05)
    plt.xlim(0, 55)
    if savefigure:
        save2dir('3vs3_mass_loss_Biomass', case)
    else:
        plt.show()

    # dvdt - Coal
    print('\nThis plot must be streched manually -> stretch it and then save it!')
    plt.plot(df_one_c1['time'], df_one_c1['dvdtmax'],
             color='cyan', label='{}: 90µm'.format(label1))
    plt.plot(df_one_c2['time'], df_one_c2['dvdtmax'],
             color='magenta', label='{}: 125µm'.format(label1))
    plt.plot(df_one_c3['time'], df_one_c3['dvdtmax'],
             color='lime', label='{}: 160µm'.format(label1))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.2E-4)
    if savefigure:
        #save2dir('3vs3_dvdt_Coal', case)
        plt.show()  # strech it
    else:
        plt.show()

    # dvdt - Biomass
    plt.plot(df_two_c1['time'], df_two_c1['dvdtmax'],
             color='cyan', label='{}: 90µm'.format(label2))
    plt.plot(df_two_c2['time'], df_two_c2['dvdtmax'],
             color='magenta', label='{}: 125µm'.format(label2))
    plt.plot(df_two_c3['time'], df_two_c3['dvdtmax'],
             color='lime', label='{}: 160µm'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.2E-4)
    if savefigure:
        save2dir('3vs3_dvdt_Biomass', case)
    else:
        plt.show()

    # dvdt volumetric - Coal
    plt.plot(df_one_c1['time'], df_one_c1['dvdtmax'] / ((pi6)*(Dp1**3)) / 1000,
             color='cyan', label='{}: 90µm'.format(label1))
    plt.plot(df_one_c2['time'], df_one_c2['dvdtmax'] / ((pi6)*(Dp2**3)) / 1000,
             color='magenta', label='{}: 125µm'.format(label1))
    plt.plot(df_one_c3['time'], df_one_c3['dvdtmax'] / ((pi6)*(Dp3**3)) / 1000,
             color='lime', label='{}: 160µm'.format(label1))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/(mm³s)]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.4E-4)
    if savefigure:
        save2dir('3vs3_dvdt_vol_Coal', case)
    else:
        plt.show()

    # dvdt volumetric - Biomass
    plt.plot(df_two_c1['time'], df_two_c1['dvdtmax'] / ((pi6)*(Dp1**3)) / 1000,
             color='cyan', label='{}: 90µm'.format(label2))
    plt.plot(df_two_c2['time'], df_two_c2['dvdtmax'] / ((pi6)*(Dp2**3)) / 1000,
             color='magenta', label='{}: 125µm'.format(label2))
    plt.plot(df_two_c3['time'], df_two_c3['dvdtmax'] / ((pi6)*(Dp3**3)) / 1000,
             color='lime', label='{}: 160µm'.format(label2))
    plt.legend(loc='upper right', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$\dot{m}_{dev}$ [kg/(mm³s)]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 1.4E-4)
    if savefigure:
        save2dir('3vs3_dvdt_vol_Biomass', case)
    else:
        plt.show()


def plot_volumetric_average_1vs1(df_one_v, df_two_v, c1, c2, label1, label2, title, case_):

    # OH
    plt.plot(df_one_v['time'], df_one_v['VolAvY_OH'],
             color=c1, label='{}'.format(label1))
    plt.plot(df_two_v['time'], df_two_v['VolAvY_OH'],
             color=c2, label='{}'.format(label2))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$Y_{OH,vol}$ [-]')
    plt.title('$D_p = {}$'.format(title))
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 2.5E-3)
    if savefigure:
        save2dir('1vs1_' + case_ + '_YOH_vol', case)
    else:
        plt.show()


def plot_volumetric_average_data_3vs3(df_one_v1, df_one_v2, df_one_v3, df_two_v1, df_two_v2, df_two_v3):

    # OH - Coal
    plt.plot(df_one_v1['time'], df_one_v1['VolAvY_OH'],
             color='cyan', label='{}'.format(labelC1))
    plt.plot(df_one_v2['time'], df_one_v2['VolAvY_OH'],
             color='magenta', label='{}'.format(labelC2))
    plt.plot(df_one_v3['time'], df_one_v3['VolAvY_OH'],
             color='limegreen', label='{}'.format(labelC3))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$Y_{OH,vol}$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 2.5E-3)
    if savefigure:
        save2dir('3vs3_YOH_vol_Coal', case)
    else:
        plt.show()

    # OH - Biomass
    plt.plot(df_two_v1['time'], df_two_v1['VolAvY_OH'],
             color='cyan', label='{}'.format(labelB1))
    plt.plot(df_two_v2['time'], df_two_v2['VolAvY_OH'],
             color='magenta', label='{}'.format(labelB2))
    plt.plot(df_two_v3['time'], df_two_v3['VolAvY_OH'],
             color='limegreen', label='{}'.format(labelB3))
    plt.legend(loc='upper left', edgecolor='white')
    plt.xlabel('time [ms]')
    plt.ylabel(r'$Y_{OH,vol}$ [-]')
    plt.ticklabel_format(axis='y', style='scientific',
                         scilimits=[-3, 4], useMathText=True)
    plt.ylim(0, 2.5E-3)
    if savefigure:
        save2dir('3vs3_YOH_vol_Biomass', case)
    else:
        plt.show()


###
# Execute the script
###
if enable_1vs1:
    #
    case = 'CoalBiomassAIR90µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_C_A90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_B_A90 + '/coal_clipped',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_C_A90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_B_A90 + '/scalar_clipped', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_air
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '90µm'
    dpar = Dp1
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)

    #
    case = 'CoalBiomassAIR125µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_C_A125 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_B_A125 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_C_A125 + '/scalar',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_B_A125 + '/scalar',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_air
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '125µm'
    dpar = Dp2
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)

    #
    case = 'CoalBiomassAIR160µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_C_A160 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_B_A160 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_C_A160 + '/scalar',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_B_A160 + '/scalar',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_air
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '160µm'
    dpar = Dp3
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)

    #
    case = 'CoalBiomassOXY90µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_C_O90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_B_O90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_C_O90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_B_O90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_oxy
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '90µm'
    dpar = Dp1
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)

    #
    case = 'CoalAIRvsOXY90µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_C_A90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_C_O90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_C_A90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_C_O90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_oxy
    c1 = color_air
    c2 = color_oxy
    label1 = labelA
    label2 = labelO
    title = '90µm'
    dpar = Dp1
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)

    #
    case = 'BiomassAIRvsOXY90µm'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_c = pd.read_csv(loc_B_A90 + '/coal_clipped',
                           sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_c = pd.read_csv(loc_B_O90 + '/coal', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_one_s = pd.read_csv(loc_B_A90 + '/scalar_clipped', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    df_two_s = pd.read_csv(loc_B_O90 + '/scalar', sep=r"\s+",
                           low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_oxy
    c1 = color_air
    c2 = color_oxy
    label1 = labelA
    label2 = labelO
    title = '90µm'
    dpar = Dp1
    plot_1vs1(df_one_c, df_two_c, df_one_s, df_two_s, YO2_ox1,
              YO2_ox2, c1, c2, label1, label2, case, title, dpar)


if enable_2vs2:
    case = '2vs2'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_s1 = pd.read_csv(loc_C_A90 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s1 = pd.read_csv(loc_B_A90 + '/scalar_clipped',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_s2 = pd.read_csv(loc_C_O90 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s2 = pd.read_csv(loc_B_O90 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    YO2_ox1 = YO2_air
    YO2_ox2 = YO2_oxy
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '90µm'
    plot_2vs2(df_one_s1, df_one_s2, df_two_s1, df_two_s2,
              c1, c2, label1, label2, case, title)

if enable_3vs3:
    case = '3vs3'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_s1 = pd.read_csv(loc_C_A90 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_s2 = pd.read_csv(loc_C_A125 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_s3 = pd.read_csv(loc_C_A160 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s1 = pd.read_csv(loc_B_A90 + '/scalar_clipped',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s2 = pd.read_csv(loc_B_A125 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_s3 = pd.read_csv(loc_B_A160 + '/scalar',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_c1 = pd.read_csv(loc_C_A90 + '/coal', sep=r"\s+",
                            low_memory=False, skiprows=[1, 2])
    df_one_c2 = pd.read_csv(loc_C_A125 + '/coal',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_one_c3 = pd.read_csv(loc_C_A160 + '/coal',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_c1 = pd.read_csv(loc_B_A90 + '/coal_clipped',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_c2 = pd.read_csv(loc_B_A125 + '/coal',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    df_two_c3 = pd.read_csv(loc_B_A160 + '/coal',
                            sep=r"\s+", low_memory=False, skiprows=[1, 2])
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    plot_3vs3(df_one_s1, df_one_s2, df_one_s3, df_two_s1, df_two_s2, df_two_s3, df_one_c1,
              df_one_c2, df_one_c3, df_two_c1, df_two_c2, df_two_c3, c1, c2, label1, label2, case)

if enable_volumetric:
    case = 'Volumetric'
    if not os.path.exists(dir_name + '/' + case):
        os.makedirs(os.getcwd() + '/' + dir_name + '/' + case)
    df_one_vol1a = pd.read_csv(
        'Input/VolumetricAveragedData/CoalAir90_VolAverageY.txt', sep="\t", low_memory=False)
    df_one_vol1o = pd.read_csv(
        'Input/VolumetricAveragedData/CoalOxy90_VolAverageY.txt', sep="\t", low_memory=False)
    df_one_vol2a = pd.read_csv(
        'Input/VolumetricAveragedData/CoalAir125_VolAverageY.txt', sep="\t", low_memory=False)
    df_one_vol3a = pd.read_csv(
        'Input/VolumetricAveragedData/CoalAir160_VolAverageY.txt', sep="\t", low_memory=False)
    df_two_vol1a = pd.read_csv(
        'Input/VolumetricAveragedData/BiomassAir90_VolAverageY_clipped.txt', sep="\t", low_memory=False)
    df_two_vol1o = pd.read_csv(
        'Input/VolumetricAveragedData/BiomassOxy90_VolAverageY.txt', sep="\t", low_memory=False)
    df_two_vol2a = pd.read_csv(
        'Input/VolumetricAveragedData/BiomassAir125_VolAverageY.txt', sep="\t", low_memory=False)
    df_two_vol3a = pd.read_csv(
        'Input/VolumetricAveragedData/BiomassAir160_VolAverageY.txt', sep="\t", low_memory=False)

    # time [s] -> [ms]
    df_one_vol1a['time'] = df_one_vol1a['time'] * 1E+03
    df_two_vol1a['time'] = df_two_vol1a['time'] * 1E+03
    df_one_vol1o['time'] = df_one_vol1o['time'] * 1E+03
    df_two_vol1o['time'] = df_two_vol1o['time'] * 1E+03
    df_one_vol2a['time'] = df_one_vol2a['time'] * 1E+03
    df_two_vol2a['time'] = df_two_vol2a['time'] * 1E+03
    df_one_vol3a['time'] = df_one_vol3a['time'] * 1E+03
    df_two_vol3a['time'] = df_two_vol3a['time'] * 1E+03

    # 3 vs 3
    plot_volumetric_average_data_3vs3(
        df_one_vol1a, df_one_vol2a, df_one_vol3a, df_two_vol1a, df_two_vol2a, df_two_vol3a)

    # Coal vs Biomass: Air 90µm
    case_ = 'CoalBiomassAir90µm'
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '90µm'
    plot_volumetric_average_1vs1(
        df_one_vol1a, df_two_vol1a, c1, c2, label1, label2, title, case_)

    # Coal vs Biomass: Oxy 90µm
    case_ = 'CoalBiomassOxy90µm'
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '90µm'
    plot_volumetric_average_1vs1(
        df_one_vol1o, df_two_vol1o, c1, c2, label1, label2, title, case_)

    # Coal vs Biomass: Air 125µm
    case_ = 'CoalBiomassAir125µm'
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '125µm'
    plot_volumetric_average_1vs1(
        df_one_vol2a, df_two_vol2a, c1, c2, label1, label2, title, case_)

    # Coal vs Biomass: Air 160µm
    case_ = 'CoalBiomassAir160µm'
    c1 = color_coal
    c2 = color_biomass
    label1 = labelC
    label2 = labelB
    title = '160µm'
    plot_volumetric_average_1vs1(
        df_one_vol3a, df_two_vol3a, c1, c2, label1, label2, title, case_)

    # Air vs Oxy: Coal
    case_ = 'CoalAirOxy90µm'
    c1 = color_air
    c2 = color_oxy
    label1 = labelA
    label2 = labelO
    title = '90µm'
    plot_volumetric_average_1vs1(
        df_one_vol1a, df_one_vol1o, c1, c2, label1, label2, title, case_)

    # Air vs Oxy: Biomass
    case_ = 'BiomassAirOxy90µm'
    c1 = color_air
    c2 = color_oxy
    label1 = labelA
    label2 = labelO
    title = '90µm'
    plot_volumetric_average_1vs1(
        df_two_vol1a, df_two_vol1o, c1, c2, label1, label2, title, case_)
