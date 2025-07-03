#!usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
from . import MechanismDependentFunctions as mdf
from matplotlib.backends.backend_pdf import PdfPages


def remove_space(string):
    return "".join(string.split())


def plot_figures(df1, df2, df3, cases, pp, filename, l1, l2, l3, lpos):

    for col in df1.columns:
        if col == 'time[ms]':
            continue
        plt.clf()
        if cases == 1:
            if l1 == '':
                plt.plot(df1['time[ms]'] * 1E+03, df1[col])
            else:
                plt.plot(df1['time[ms]'] * 1E+03, df1[col], label=l1)
                plt.legend(loc=lpos, edgecolor='white')
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(col) + '}$ [kmol/m³/s]')
        elif cases == 2:
            plt.plot(df1['time[ms]'] * 1E+03, df1[col], label=l1)
            plt.plot(df2['time[ms]'] * 1E+03, df2[col], label=l2)
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(col) + '}$ [kmol/m³/s]')
            plt.legend(loc=lpos, edgecolor='white')
        else:
            plt.plot(df1['time[ms]'] * 1E+03, df1[col], label=l1)
            plt.plot(df2['time[ms]'] * 1E+03, df2[col], label=l2)
            plt.plot(df3['time[ms]'] * 1E+03, df3[col], label=l3)
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(col) + '}$ [kmol/m³/s]')
            plt.legend(loc=lpos, edgecolor='white')
        plt.ticklabel_format(axis='y', style='scientific',
                             scilimits=[-3, 4], useMathText=True)
        pp.savefig(bbox_inches='tight')

    return pp


def CreateProductionRatesFigures(inp1, inp2, inp3, outdir, spec, fs, l1, l2, l3, lpos):

    # define font
    font = {'size': fs}
    plt.rcParams['font.family'] = 'serif'
    plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
    plt.rc('font', **font)
    plt.rc('axes', unicode_minus=False, linewidth=1.0)

    # read data
    df2 = 0
    df3 = 0
    cases = 1
    df1 = pd.read_csv(inp1, sep=r'\s+', low_memory=False)
    df1.columns = list([remove_space(col) for col in df1.columns])
    if inp2 != '':
        cases += 1
        df2 = pd.read_csv(inp2, sep=r'\s+', low_memory=False)
        df2.columns = list([remove_space(col) for col in df2.columns])
    if inp3 != '':
        cases += 1
        df3 = pd.read_csv(inp3, sep=r'\s+', low_memory=False)
        df3.columns = list([remove_space(col) for col in df3.columns])

    if inp3 != '' and inp2 == '':
        df2 = df_3

    if spec.upper() == 'ALL':
        # create pdf file containing all figures
        fname = outdir + '/PRates_AllSpecies.pdf'
        species = mdf.Species()
        pp = PdfPages(fname)
        pp = plot_figures(df1, df2, df3, cases, pp, fname, l1, l2, l3, lpos)
        pp.close()
    else:
        if cases == 1:
            if l1 == '':
                plt.plot(df1['time[ms]'] * 1E+03, df1[spec])
            else:
                plt.plot(df1['time[ms]'] * 1E+03, df1[spec], label=l1)
                plt.legend(loc=lpos, edgecolor='white')
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(spec) + '}$ [kmol/m³/s]')
            plt.ticklabel_format(axis='y', style='scientific',
                                 scilimits=[-3, 4], useMathText=True)
            plt.savefig(outdir + '/ProdRate_' + spec +
                        '.png', bbox_inches='tight')
        elif cases == 2:
            plt.plot(df1['time[ms]'] * 1E+03, df1[spec], label=l1)
            plt.plot(df2['time[ms]'] * 1E+03, df2[spec], label=l2)
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(spec) + '}$ [kmol/m³/s]')
            plt.legend(loc=lpos, edgecolor='white')
            plt.ticklabel_format(axis='y', style='scientific',
                                 scilimits=[-3, 4], useMathText=True)
            plt.savefig(outdir + '/ProdRate_' + spec +
                        '.png', bbox_inches='tight')
        else:
            plt.plot(df1['time[ms]'] * 1E+03, df1[spec], label=l1)
            plt.plot(df2['time[ms]'] * 1E+03, df2[spec], label=l2)
            plt.plot(df3['time[ms]'] * 1E+03, df3[spec], label=l3)
            plt.xlabel('time [ms]')
            plt.ylabel('$\dot{C}_{' + str(spec) + '}$ [kmol/m³/s]')
            plt.legend(loc=lpos, edgecolor='white')
            plt.ticklabel_format(axis='y', style='scientific',
                                 scilimits=[-3, 4], useMathText=True)
            plt.savefig(outdir + '/ProdRate_' + spec +
                        '.png', bbox_inches='tight')

    return
