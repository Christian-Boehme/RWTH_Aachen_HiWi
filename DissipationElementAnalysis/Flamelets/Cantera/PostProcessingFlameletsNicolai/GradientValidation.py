#!/usr/bin/env python3

import os
import re
import sys
import math
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def calculate_relative_error(f, outdir, chi, D, grad, x, relative, show):
    
    #
    for i in f:
        
        # read data
        df = pd.read_csv(i, sep=r'\s+')
        
        # case
        case_ = i.split('/')[-1]
        Tin = case_.split('.')[-3]
        a = case_.split('.')[-2]
        case = 'Tin' + Tin + '_a' + a

        # get x and y data
        x_data = df[x].to_list()
        chi_data = df[chi].to_list()
        D_data = df[D].to_list()
        grad_data = df[grad].to_list()
        
        if x == 'x':
            # m -> mm
            x_data = [x * 1E+03 for x in x_data]
    
        # gradient g = sqrt(chi / 6 / D)
        g = []
        for i in range(df.shape[0]):
            g.append((chi_data[i] / (6 * D_data[i]))**0.5)

        if relative:
            # relative error
            y_data = [((a - b) / (b)) * 100 if b != 0 else float('inf') for a, b in zip(g, grad_data)]
        else:
            # absolute difference
            y_data = [a - b for a, b in zip(g, grad_data)]

        # create figure
        plt.plot(x_data, y_data, color='blue')
        plt.scatter(x_data, y_data, marker='x', color='blue')
        plt.xlabel(r'$x$ [mm]')
        ylab = 'g'
        if relative:
            plt.ylabel(r'$\epsilon_\mathrm{rel}' + r'=\frac{' + ylab + r'_\mathrm{post}-' + ylab + r'_\mathrm{eq}}{' + ylab + r'_\mathrm{eq}}$ [%]')
        else:
            plt.ylabel(r'$' + ylab + r'_\mathrm{post}-' + ylab + r'_\mathrm{eq}$')
        plt.title(r'$T_\mathrm{in}$=' + str(int(Tin)) + r'K $a$=' + str(int(a)) + r'$\frac{1}{s}$')
        plt.tight_layout()
        if not show:
            plt.savefig(outdir + '/GradientValidation_' + ylab + '_over_' +
                        x + '_Case_' + case + '.pdf', format="pdf", bbox_inches='tight')
        else:
            plt.show()
        
        # clear figure
        plt.clf()

    return


def main(args=None):

    # parser description
    parser = argparse.ArgumentParser(
        description="Calculate aboslute or relative error of gradient g")

    # parser option
    parser.add_argument('-i', type=str, nargs='+', required=True,
                        help='Input file(s)')
    parser.add_argument('-o', type=str, required=False,
                        help='Output directory')
    parser.add_argument('-chi', type=str, required=False,
                        help='Column name of dissipation rate chi')
    parser.add_argument('-D', type=str, required=False,
                        help='Column name of diffustion coefficient D')
    parser.add_argument('-g', type=str, required=False,
                        help='Column name of gradient g')
    parser.add_argument('-x', type=str, required=False,
                        help='Column name of x-data')
    parser.add_argument('-fs', type=float, required=False, help='Font size')
    parser.add_argument('-rel', action='store_true', required=False,
                        help='Calculate relative error, not aboslute difference.')
    parser.add_argument('-showFigure', action='store_true', required=False,
                        help='Show figures and do not save them in the output folder.')
    
    # parser default settings
    parser.set_defaults(i1='')
    parser.set_defaults(o='../FiguresAndOutputData/DefaultRelativeError/')
    parser.set_defaults(chi='chi')
    parser.set_defaults(D='D')
    parser.set_defaults(g='grad')
    parser.set_defaults(x='x')
    parser.set_defaults(fs=18)
    parser.set_defaults(rel=False)
    parser.set_defaults(showFigure=False)

    # parse
    args = parser.parse_args(args)

    # terminate if input is not provided
    if args.i == '':
        sys.exit(
            '\nAdd either one or multiple flamelet files or a directory containing flamelet file(s): "-i1 <path>"!')

    # create output-directory
    if not os.path.exists(args.o):
        os.makedirs(args.o)

    # read file(s)
    if args.i != '':
        if os.path.isdir((args.i)[0]):
            path = args.i[0]
            files1 = [os.path.join(path, f) for f in os.listdir(
                path) if os.path.isfile(os.path.join(path, f))]
        else:
            files1 = [(args.i)[x] for x in range(len(args.i))]

    # sort datafiles
    files1 = sorted(files1)

    # figure: define font
    font = {'size': args.fs}
    plt.rcParams['font.family'] = 'serif'
    plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
    plt.rc('font', **font)
    plt.rc('axes', unicode_minus=False, linewidth=1.0)

    calculate_relative_error(files1, args.o, args.chi, args.D, args.g, args.x, args.rel, args.showFigure)

    return


if __name__ == "__main__":
    main()
