#!/usr/bin/env python3

import os
import sys
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt


def ExtractTinlet(s):
    return s.split('.')[1]


def SplitFilesBasedOnInletTemperatures(f):

    # allocate memory
    files = []

    #
    buf = []
    Tinlet = ExtractTinlet(f[0])
    for i in f:
        tinlet = ExtractTinlet(i)
        if tinlet == Tinlet:
            buf.append(i)
        else:
            Tinlet = tinlet
            files.append(buf)
            buf = [i]

    files.append(buf)

    return files


def GetData(files):

    # allocate memory
    chi = []
    temp = []
    for i in files:
        df = pd.read_csv(i, sep='\t')
        df.columns = df.columns.str.replace(" ", "")
        idx = (df['Z'] - Zst).abs().idxmin()
        # nearest_Z = df.loc[idx, 'Z']
        # print(nearest_Z)
        chi_ = df['chi'][idx]
        temp_ = df['Temp'][idx]
        chi.append(chi_)
        temp.append(temp_)

    return chi, temp


def CalculateReactionZoneThickness(f):

    # read data
    df = pd.read_csv(f, sep='\t')
    df.columns = df.columns.str.replace(" ", "")

    # max HR
    w_max = df['HeatRelease'].max()
    w_idxmax = df['HeatRelease'].idxmax()

    # second derivative (finite difference approximation)
    # dwdZ_sec = (df.loc[w_idxmax + 1, 'HeatRelease'] - 2*df.loc[w_idxmax, 'HeatRelease'] + df.loc[w_idxmax - 1, 'HeatRelease']) / \
    #    ((df.loc[w_idxmax + 1, 'Z'] - df.loc[w_idxmax, 'Z']) **
    #     2)
    # ensure to have an equidistant grid
    dZp = df.loc[w_idxmax + 1, 'Z'] - df.loc[w_idxmax, 'Z']
    dZm = df.loc[w_idxmax, 'Z'] - df.loc[w_idxmax - 1, 'Z']
    dwdZ_sec = 2 * (dZm * df.loc[w_idxmax+1, 'HeatRelease'] - (dZm + dZp) * df.loc[w_idxmax,
                    'HeatRelease'] + dZp * df.loc[w_idxmax-1, 'HeatRelease']) / ((dZm + dZp) * (dZm * dZp))
    dzr = 2 * (-2 * np.log(2) * w_max * (dwdZ_sec**(-1)))**0.5
    # print('Reaction zone thickness: {:.5f}'.format(dzr))

    return dzr


def DetermineQuenchingGradient(f):

    # read data
    df = pd.read_csv(f, sep='\t')
    df.columns = df.columns.str.replace(" ", "")

    #
    gq = df['chi'].max()

    return gq


# stoichiometric mixture fraction
Zst = 0.117

# output folder
FigOutdir = '../../Figures/FlameletsNicolai/'
DataOutdir = '../../PostProcessedData/'

# data
folder = '/home/cb376114/NHR/DE_Analysis/Flamelets/Cantera/OutputData/Flamelet_preheated_PassiveScalarMixtureFraction/Data/'
# folder = '/home/cb376114/NHR/DE_Analysis/Flamelets/Cantera/OutputData/Flamelet_preheated_relevant/Data/'

# get files
files = [f for f in os.listdir(folder) if os.path.isfile(
    os.path.join(folder, f)) and f.endswith('.csv')]

# sort files
sfiles = sorted(files)

# split files based on inlet temperature
sfiles_Tinlet = SplitFilesBasedOnInletTemperatures(sfiles)

# add full path
sfiles_ = [folder + x for x in sfiles]
sfiles_Tinlet_ = [[folder + x for x in l] for l in sfiles_Tinlet]

# define font
font = {'size': 18}
plt.rcParams['font.family'] = 'serif'
plt.rcParams['font.serif'] = ['Times New Roman'] + plt.rcParams['font.serif']
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False, linewidth=1.0)

# create output-directory
if not os.path.exists(FigOutdir):
    os.makedirs(FigOutdir)

# create figure
fig, ax = plt.subplots()
cmap = plt.get_cmap('jet')  # , len(sfiles_Tinlet_))
norm = mpl.colors.Normalize(300, 1500)  # len(sfiles_Tinlet_))   # interpolated
Tlevels = [row[0].split('/')[-1] for row in sfiles_Tinlet]
Tlevels = [int(ExtractTinlet(x)) for x in Tlevels]

quench = []
for i in range(len(sfiles_Tinlet_)):
    Tinlet = ExtractTinlet(sfiles_Tinlet_[i][0])
    chi, temp = GetData(sfiles_Tinlet_[i])
    # ax.scatter(chi[-1], temp[-1], marker='o', color='black')
    # Tlevels[i])))
    ax.scatter(chi, temp, marker='x', color=cmap(norm(300 + i*100)))
    # data are based on the last flamelet file!
    dZr = CalculateReactionZoneThickness(sfiles_Tinlet_[i][-1])
    gq = DetermineQuenchingGradient(sfiles_Tinlet_[i][-1])
    quench.append([float(Tinlet), float(temp[-1]),
                  float(chi[-1]), float(dZr), float(gq)])
print('Flamelet data are based on the last flamelet file!')

# creating ScalarMappable
sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
# sm.set_array([])

# len(Tlevels)/2)) #, ticks=np.linspace(0, 2, len(sfiles_Tinlet_)))
plt.colorbar(sm, ax=ax, label=r'$T_\mathrm{inlet}$ [K]', ticks=np.linspace(
    Tlevels[0], Tlevels[-1], 7))

# chi = [1/x for x in chi]
# plt.plot(chi, temp, linestyle='-', color='blue')
# plt.scatter(chi, temp, marker='x', color='blue')
# plt.xlabel(r'$1/\chi$ [1/s]')
plt.xlabel(r'$\chi_\mathrm{st}$ [1/s]')
plt.ylabel(r'$T$ [K]')

plt.tight_layout()

# plt.show()
plt.savefig(FigOutdir + '/QuenchingGradient.pdf',
            format="pdf", bbox_inches='tight')

# write to csv
df = pd.DataFrame(quench, columns=['InletTemp', 'Temp', 'chi', 'dZr', 'g_q'])
df.columns = list([col.rjust(20, ' ') for col in df.columns])
df.to_csv(DataOutdir + "QuenchingData_FlameletsNicolai.csv",
          sep='\t', float_format='%20.6E',  index=False)
