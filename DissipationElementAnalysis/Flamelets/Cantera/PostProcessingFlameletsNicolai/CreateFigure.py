#!/usr/bin/env python3

import os
import re
import sys
import math
import argparse
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
from core import MechanismData as md


def read_flamelet(f):

    idx = -1
    with open(f, 'r') as inp:
        data = [line.rstrip() for line in inp]

    # cantera input data - Nicolai
    if not f.endswith('.csv'):
        # clipp data
        idx = 0
        for line in range(len(data)):
            if data[line] == '[FILE_STRUCTURE_COLUMNS_CONTAINING]':
                idx = line
                break

    # if FlameMaster:
    #    idx = 1
    data = data[idx+1:]

    # convert data
    header = data[0].split(' ')
    header = [x for x in header if x != '']

    Data = []
    nSpec = len(md.Species()) + 1
    for i in range(1, len(data)):
        row = data[i].split(' ')
        Data_ = [float(x) for x in row if x != '']
        # set negative mass fractions to zero
        Data_[1:nSpec] = [0 if x < 0 else x for x in Data_[1:nSpec]]
        Data.append(Data_)

    # read data
    if f.endswith('.csv'):
        df = pd.read_csv(f, sep=r'\s+')
    else:
        df = pd.DataFrame(Data, columns=header)

    return df


def fig_label(var):

    v = 'Y_'
    vsub = var
    u = '-'
    if var.startswith('s'):
        v = r'\dot{\omega}'
        vsub = var[1:]
        u = 'kmol/m³/s'
    elif var == 'Z':
        v = 'Z'
        vsub = ''
    elif var == 'chi':
        v = r'\chi'
        vsub = ''
        u = '1/s'
    elif var == 'Temp':
        v = r'T'
        vsub = ''
        u = 'K'
    elif var == 'x':
        v = r'x'
        vsub = ''
        u = 'mm'

    return v, vsub, u


def MinMaxLimitsColorbar(l):
    return min(l), max(l)


def ColorbarNormalization(f):

    # allocate memory
    colorbar = False
    inlet_temp = False
    strain_rate = False
    cbmin = 0
    cbmax = 0

    # get filename
    files = [x.split('/')[-1] for x in f]
    
    # rm '.csv' or any other file format if present
    if files[0].count('.') == 3:
        files = ['.'.join(x.split('.')[:-1]) for x in files]

    # get inlet temperature and strain rate
    # NOTE: filename must be <something>.Tinlet.a
    t_in = [int(x.split('.')[1]) for x in files]
    a = [int(x.split('.')[-1]) for x in files]

    if t_in.count(t_in[0]) == len(t_in):
        strain_rate = True
        colorbar = True
        cbmin, cbmax = MinMaxLimitsColorbar(a)
        lev = a
        lab = r'$a \mathrm{[1/s]}$'
    if a.count(a[0]) == len(a):
        inlet_temp = True
        colorbar = True
        cbmin, cbmax = MinMaxLimitsColorbar(t_in)
        lev = t_in
        lab = r'$T_\mathrm{inlet} \mathrm{[K]}$'

    if inlet_temp and strain_rate:
        colorbar = False

    return cbmin, cbmax, lev, lab, colorbar


# def GetSpeciesList(df):
#
#    col = list(df.columns)
#    pos = next((i for i, item in enumerate(col) if item.startswith('s')), None)
#    cpos = int((len(col) - 5) / 2) + 1
#    if pos != cpos:
#        sys.exit('\nFailed to detect species list!')
#    #print('Number of species: ', pos-1)
#    species = col[1:pos]
#    print('Species: ', species)
#
#    return species


def SpeciesNumberOfKAtoms(spec, species_list, element):

    df = md.ElementalComposition(species_list)

    if spec not in species_list:
        sys.exit('SPECIES NOT FOUND: ', spec)
    else:
        k_atoms = df.loc[element, spec]
        # print('Species: ' + str(spec) + '\t=> C atoms = ', k_atoms)

    return k_atoms


def MassToMole(df):

    # allocate memory
    X = []

    #
    species = md.Species()

    #
    MM = md.MolecularWeight()

    #
    for i in range(df.shape[0]):
        x_pos = []
        for j in range(len(species)):
            x_pos.append(df.iloc[i, j+1] * df.loc[i, 'WMix'] / MM[j])
        X.append(x_pos)

    # create df
    Xspecies = ['X_'+i for i in species]
    dfX = pd.DataFrame(X, columns=Xspecies)
    # for i in range(dfX.shape[0]):
    #    print("Sum mole fractions - row " + str(i) + ':\t' + str(dfX.iloc[i].sum()))

    return dfX


def Compute_WMix(df):

    #
    species = md.Species()

    #
    MM = md.MolecularWeight()

    #
    wmix = []
    for i in range(df.shape[0]):
        tot = 0
        for j in range(0, len(species)):
            tot += df.iloc[i, j+1] / MM[j]
        wmix.append(1/tot)

    # add WMix to df
    df['WMix'] = wmix

    return df


def DiffusionCoefficient(df, dfX):

    #
    species = md.Species()

    # species-species diffusion coefficients
    df_D = md.DiffusionCoefficients()

    #
    D = []
    for pos in range(df.shape[0]):
        D_species = 0
        for i in range(len(species)):
            d = 0
            for j in range(len(species)):
                if i == j:
                    continue
                d += float(dfX.iloc[pos, j] / df_D.iloc[i, j])
            D_species += float(dfX.iloc[pos, i] *
                               ((1 - df.iloc[pos, i + 1]) / d))
        D.append(D_species)

    # D = [2E-05] * dfX.shape[0]
    # add D to df
    df['D'] = D
    # print(df)

    return df


def calc_mixture_fraction_passive_scalar(df, pS, Yi):

    #
    species = md.Species()

    # passive scalar
    ps = pS.split(',')
    for i in ps:
        if i not in species:
            sys.exit('\nInvalid passive scalar: ' +
                     str(i) + '\n=> Not in species list')

    #
    Z = []
    for i in range(df.shape[0]):
        Yps = 0
        for j in ps:
            Yps += df.loc[i, j]
        Z.append(1 - (Yps / Yi))

    # Z to df
    df['Z'] = Z

    return df


def calc_mixture_fraction_atomic_mass_fractions(df):

    # calculate mixture fraction based on atomic mass fractions
    # Equation: Z = (Y_k - Y_k,Ox) / (Y_k,F - Y_k,Ox) k is a 'key element'
    # Y_k = Sum_i Y_i * n_k,i * M_k / M_i
    # => k = Carbon

    # allocate memory
    Y_kF = 0
    Y_kOx = 0
    Z = [1.0]  # Fuel side

    #
    k = 'C'
    M_k = 12.0107  # Carbon

    #
    species = md.Species()

    # molecular weight
    MM = md.MolecularWeight()

    # calculate atomic mass fraction for fuel and oxidzer side
    for j in range(0, len(species)):
        Y_Fi = df.iloc[0, j+1]
        Y_Oxi = df.iloc[df.shape[0]-1, j+1]
        n_ki = SpeciesNumberOfKAtoms(species[j], species, k)
        M_i = MM[j]
        Y_kF += Y_Fi * n_ki * M_k / M_i
        Y_kOx += Y_Oxi * n_ki * M_k / M_i
    # print('Atomic mass fraction - fuel side:     ', Y_kF)
    # print('Atomic mass fraction - oxidizer side: ', Y_kOx)

    # calculate atomic mass fraction for all remaining points
    for x in range(1, df.shape[0] - 1):
        Y_k = 0
        for y in range(0, len(species)):
            Y_i = df.iloc[x, y + 1]
            n_ki = SpeciesNumberOfKAtoms(species[y], species, k)
            M_i = MM[y]
            # print('n_ki = ', n_ki)
            # print('M[i] = ', M_i)
            Y_k += Y_i * n_ki * M_k / M_i
        Z.append((Y_k - Y_kOx) / (Y_kF - Y_kOx))

    # add oxidizer side
    Z.append(0.0)

    # Z to df
    df['Z'] = Z

    return df


def calc_dissipation_rate(df, ScalarApproach, pS, Yi):

    # mixture fraction
    if 'Z' not in df.columns:
        if not ScalarApproach:
            df = calc_mixture_fraction_passive_scalar(df, pS, Yi)
        else:
            df = calc_mixture_fraction_atomic_mass_fraction(df)

    # add molecular weight of mixture to df
    df = Compute_WMix(df)

    # species mole fractions
    df_mole = MassToMole(df)

    # allocate memory
    chi = []

    # diffusion coefficient
    df_D = DiffusionCoefficient(df, df_mole)

    # for i in range(1, df.shape[0] - 1):
    #    dZdx = (df.loc[i + 1, 'Z'] - df.loc[i - 1, 'Z']) / (df.loc[i + 1, 'x'] - df.loc[i - 1, 'x'])        # TODO np.graident() - see cantera script!
    #    chi.append(2 * df_D.loc[i, 'D'] * dZdx**2)
    # first and last data point assumed to be constant
    # chi.insert(0, chi[0])
    # chi.append(chi[-1])

    dZdx = np.gradient(df['Z'], df['x'])
    for i in range(df.shape[0]):
        chi.append(2 * df_D.loc[i, 'D'] * dZdx[i]**2)

    # add chi to df
    df['chi'] = chi

    return df


def reaction_zone_thickness(df, ScalarApproach, pS, Yi):

    # mixture fraction
    if 'Z' not in df.columns:
        if not ScalarApproach:
            df = calc_mixture_fraction_passive_scalar(df, pS, Yi)
        else:
            df = calc_mixture_fraction_atomic_mass_fraction(df)

    # max and idx
    w_max = df['HeatRelease'].max()
    w_idxmax = df['HeatRelease'].idxmax()

    # second derivative (finite difference approximation)
    dwdZ_sec = (df.loc[w_idxmax + 1, 'HeatRelease'] - 2*df.loc[w_idxmax, 'HeatRelease'] + df.loc[w_idxmax - 1, 'HeatRelease']) / \
        ((df.loc[w_idxmax + 1, 'Z'] - df.loc[w_idxmax, 'Z']) **
         2)   # finite difference approximation
    dZr = 2 * (-2 * np.log(2) * w_max * (dwdZ_sec**(-1)))**0.5
    print('Reaction zone thickness: {:.5f}'.format(dZr))

    return dZr


def gradient_g(df):

    # mixture fraction
    if 'Z' not in df.columns:
        if not ScalarApproach:
            df = calc_mixture_fraction_passive_scalar(df, pS, Yi)
        else:
            df = calc_mixture_fraction_atomic_mass_fraction(df)

    # allocate memory
    g = []

    # calculate gradient
    # fac = 1 / (3**0.5)
    grad = np.gradient(df['Z'], df['x'])
    for i in range(df.shape[0]):
        g.append(((grad[i]**2) / 3)**0.5)
        # g.append(fac * grad[i])

    # add g to df
    df['grad'] = g

    return df


# TODO nicer ...
def create_figure(files, variables, xvar, outdir, ScalarApproach, pScalar, pScalarSumY, save, show, DetermineQ, DeterminedZr):

    if variables == 'ALL':
        df = read_flamelet(files[0])
        variables = list(df.columns())

    if DeterminedZr:
        # input file where maximum heat release
        inp = files[0]
        if len(files) != 1:
            w_T_max_global = 0
            for f in files:
                df = read_flamelet(f)
                wTmax = df['HeatRelease'].max()
                if wTmax > w_T_max_global:
                    w_T_max_global = wTmax
                    inp = f
            print('Maximum heat release in file: ', inp)
        files = [inp]

    fac = 1
    x_var, vx_fig, xunit = fig_label(xvar)
    if xvar == 'x':
        fac = 1E+03

    # save data
    if save:
        for f in files:
            print(f)
            df = read_flamelet(f)
            # complete df
            if 'Z' not in list(df.columns):
                if not ScalarApproach:
                    # passive Scalar
                    df = calc_mixture_fraction_passive_scalar(
                        df, pScalar, pScalarSumY)
                else:
                    # atomic mass fractions
                    df = calc_mixture_fraction_atomic_mass_fractions(df)
            if 'chi' not in list(df.columns):
                df = calc_dissipation_rate(
                    df, ScalarApproach, pScalar, pScalarSumY)
            if 'grad' not in list(df.columns):
                df = gradient_g(df)
            # ensure that all columns have a scientific notation
            for col in list(df.columns):
                if df[col].sum() == 0:
                    df[col] = df[col].astype(float)
            df.columns = list([col.rjust(20, ' ') for col in df.columns])
            df.to_csv(outdir + '/Data_' + str(f.split('/')
                      [-1]) + '.csv', sep='\t', float_format='%20.6E', index=False)
        sys.exit('All data were written to ' + str(outdir))

    # colorbar required
    cb_activated = False
    if len(files) != 1:
        cb_min, cb_max, cb_levels, cb_label, cb_activated = ColorbarNormalization(
            files)
        if cb_activated:
            cmap = plt.get_cmap('jet')
            norm = mpl.colors.Normalize(int(cb_min), int(cb_max))

    for v in variables:
        yvar, vy_fig, yunit = fig_label(v)

        xmax = 0
        if cb_activated:
            fig, ax = plt.subplots()
        for f_ in range(len(files)):

            # get file
            f = files[f_]

            print(f)
            # read data
            df = read_flamelet(f)

            # append df if needed
            if (v == 'Z' or xvar == 'Z') and 'Z' not in list(df.columns):
                if not ScalarApproach:
                    # passive Scalar
                    df = calc_mixture_fraction_passive_scalar(
                        df, pScalar, pScalarSumY)
                else:
                    # atomic mass fractions
                    df = calc_mixture_fraction_atomic_mass_fractions(df)
            if (v == 'chi' or xvar == 'chi') and 'chi' not in list(df.columns):
                df = calc_dissipation_rate(
                    df, ScalarApproach, pScalar, pScalarSumY)
            if v == 'grad' not in list(df.columns):
                df = gradient_g(df)

            # create figure
            if DetermineQ and v == 'chi':
                plt.plot(df[v], df['Temp'])
            elif DeterminedZr:
                dZr = reaction_zone_thickness(
                    df, ScalarApproach, pScalar, pScalarSumY)
                plt.plot(df['Z'], df['HeatRelease'])
            else:
                if cb_activated:
                    ax.plot(df[xvar] * fac, df[v], c=cmap(norm(cb_levels[f_])))
                else:
                    plt.plot(df[xvar] * fac, df[v])
                if df[xvar].max() * fac > xmax:
                    xmax = df[xvar].max() * fac

        # create figure
        if DetermineQ and v == 'chi':
            print('\nmax("chi") = {:.5f} [1/s]\n@T = {:.5f} [K]'.format(
                df['chi'].max(), df.loc[df['chi'].idxmax(), 'Temp']))
            plt.xlabel(r'$\mathregular{' + str(yvar) + '{' + str(
                re.sub('([0-9])', '_\\1', vy_fig)) + '}}$ [' + str(yunit) + ']')
            plt.ylabel('$T$ [K]')
        elif DeterminedZr:
            plt.xlabel('$Z$ [-]')
            plt.ylabel(r'$\omega_\mathrm{T}$ $\mathrm{[Jm^{-3}s^{-1}]}$')
        else:
            if cb_activated:
                sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
                # int(len(cb_levels) / 2))) # TODO not every point
                plt.colorbar(sm, ax=ax, label=cb_label, ticks=np.linspace(
                    cb_levels[0], cb_levels[-1] + 1, 20))
            # TODO label good for species names, but not for variabels like T, Z, ...
            plt.xlabel(r'$\mathregular{' + str(xvar) + '{' + str(
                re.sub('([0-9])', '_\\1', vx_fig)) + '}}$ [' + str(xunit) + ']')
            # print(r'$\mathregular{' + str(yvar) + '{' + str(re.sub('([0-9])', '_\\1', vy_fig)) + '}}$ [' + str(yunit) + ']')
            plt.ylabel(r'$\mathregular{' + str(yvar) + '{' + str(
                re.sub('([0-9])', '_\\1', vy_fig)) + '}}$ [' + str(yunit) + ']')
        if xmax != 0:
            plt.xlim(0, math.ceil(xmax))
        plt.xlim(0, 0.20)
        plt.tight_layout()
        if not show:
            plt.savefig(outdir + '/Flamelet_' + v + '_over_' +
                        xvar + '.pdf', format="pdf", bbox_inches='tight')
        else:
            plt.show()
        # clear figure for next plot
        plt.clf()

    return


def main(args=None):

    # parser description
    parser = argparse.ArgumentParser(
        description="Create figures based on flamelet solution.")

    # parser option
    parser.add_argument('-i', type=str, nargs='+', required=True,
                        # type=argparse.FileType('r')
                        help='Flamelet solution file(s)')
    parser.add_argument('-vx', type=str, required=False,
                        help='Variable to plot: x-axis')
    parser.add_argument('-vy', type=str, required=False,
                        help='Variable to plot: y-axis')
    parser.add_argument('-o', type=str, required=False,
                        help='Output directory')
    parser.add_argument('-fs', type=float, required=False, help='Font size')
    parser.add_argument('-atomicZ', action='store_true', required=False,
                        help='Calculate mixture fraction based on atomic mass fractions (Default: based on passive scalar)')
    parser.add_argument('-pScalar', type=str, required=False,
                        help='List of passive scalars for mixture fraction calculation')
    parser.add_argument('-pScalarSumY', type=str, required=False,
                        help='Initial mass fraction of all passive scalars (or as list)')
    parser.add_argument('-saveData', action='store_true', required=False,
                        help='Save all data to a csv file in the output folder')
    parser.add_argument('-showFigure', action='store_true', required=False,
                        help='Show figures and do not save them in the output folder.')
    parser.add_argument('-DetermineQ', action='store_true',
                        required=False, help='Determines quenching point.')
    parser.add_argument('-DeterminedZr', action='store_true',
                        required=False, help='Determines reaction zone thickness.')

    # parser default settings
    parser.set_defaults(i='')
    parser.set_defaults(d='')
    parser.set_defaults(vx='x')
    parser.set_defaults(vy='ALL')
    parser.set_defaults(o='../FiguresAndOutputData/Default')
    parser.set_defaults(fs=18)
    parser.set_defaults(atomicZ=False)  # should be default!
    parser.set_defaults(pScalar='N2')
    parser.set_defaults(pScalarSumY=0.586)
    parser.set_defaults(saveData=False)
    parser.set_defaults(showFigure=False)
    parser.set_defaults(DetermineQ=False)
    parser.set_defaults(DeterminedZr=False)

    # parse
    args = parser.parse_args(args)

    # terminate if input is not provided
    if args.i == '':
        sys.exit(
            '\nAdd either one or multiple flamelet files or a directory containing flamelet file(s): "-i <path>"!')

    # create output-directory
    if not os.path.exists(args.o):
        os.makedirs(args.o)

    # read file(s)
    if args.i != '':
        if os.path.isdir((args.i)[0]):
            path = args.i[0]
            files = [os.path.join(path, f) for f in os.listdir(
                path) if os.path.isfile(os.path.join(path, f))]
        else:
            files = [(args.i)[x] for x in range(len(args.i))]

    # sort datafiles
    files = sorted(files)

    # get variables
    var = (args.vy)
    if ',' in var:
        var = var.split(',')
    if isinstance(var, str):
        var = [var]

    # figure: define font
    font = {'size': args.fs}
    plt.rcParams['font.family'] = 'serif'
    plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
    plt.rc('font', **font)
    plt.rc('axes', unicode_minus=False, linewidth=1.0)

    # create figures
    create_figure(files, var, args.vx, args.o, args.atomicZ, args.pScalar, args.pScalarSumY,
                  args.saveData, args.showFigure, args.DetermineQ, args.DeterminedZr)

    return


if __name__ == "__main__":
    main()
