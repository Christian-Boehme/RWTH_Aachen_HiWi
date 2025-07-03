#!/usr/bin/env python3

import os
import re
import sys
import math
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def calculate_relative_error(f1, f2, outdir, x, y, l1, l2, show):

    # check input
    if len(f1) != len(f2):
        sys.exit('\nNumber of input files is not consistent!')

    #
    for f in range(len(f1)):
        print('f1: ', f1[f])
        print('f2: ', f2[f])

        # read data
        df1 = pd.read_csv(f1[f], sep=r'\s+')
        df2 = pd.read_csv(f2[f], sep=r'\s+')
        
        # case
        case_ = f1[f].split('/')[-1]
        Tin = case_.split('.')[-3]
        a = case_.split('.')[-2]
        case = 'Tin' + Tin + '_a' + a

        # get x and y data
        x_data_f1 = df1[x].to_list()
        x_data_f2 = df2[x].to_list()
        y_data_f1 = df1[y].to_list()
        y_data_f2 = df2[y].to_list()
        
        # m -> mm
        x_data_f1 = [x * 1E+03 for x in x_data_f1]
        x_data_f2 = [x * 1E+03 for x in x_data_f2]

        # relative error
        rel_error = [((a - b) / (b)) * 100 if b != 0 else float('inf') for a, b in zip(y_data_f1, y_data_f2)]

        # create figure
        plt.plot(x_data_f1, rel_error, color='blue')
        plt.scatter(x_data_f1, rel_error, marker='x', color='blue')
        if x_data_f1 != x_data_f2:
            plt.plot(x_data_f2, rel_error, color='red')
        plt.xlabel(r'$x$ [mm]')
        if y == 'chi':
            ylab = r'\chi'
        else:
            ylab = y
        plt.ylabel(r'$\epsilon_\mathrm{rel}' + r'=\frac{' + ylab + r'_\mathrm{' + l1 + '}-' + ylab + r'_\mathrm{' + l2 + '}}{' + ylab + r'_\mathrm{' + l2 + '}}$ [%]')
        plt.title(r'$T_\mathrm{in}$=' + str(int(Tin)) + r'K $a$=' + str(int(a)) + r'$\frac{1}{s}$')
        plt.tight_layout()
        if not show:
            plt.savefig(outdir + '/RelativeError_' + y + '_over_' +
                        x + '_Case_' + case + '.pdf', format="pdf", bbox_inches='tight')
        else:
            plt.show()
        
        # clear figure
        plt.clf()

    return


def main(args=None):

    # parser description
    parser = argparse.ArgumentParser(
        description="Calculate relative error of two data-sets.")

    # parser option
    parser.add_argument('-i1', type=str, nargs='+', required=True,
                        help='Input file(s)')
    parser.add_argument('-i2', type=str, nargs='+', required=True,
                        help='Input file(s)')
    parser.add_argument('-o', type=str, required=False,
                        help='Output directory')
    parser.add_argument('-x', type=str, required=False,
                        help='Column name of x-data')
    parser.add_argument('-y', type=str, required=False,
                        help='Column name of y-data (relative error)')
    parser.add_argument('-l1', type=str, required=False,
                        help='Label of first input file(s)')
    parser.add_argument('-l2', type=str, required=False,
                        help='Label of second input file(s)')
    parser.add_argument('-fs', type=float, required=False, help='Font size')
    parser.add_argument('-showFigure', action='store_true', required=False,
                        help='Show figures and do not save them in the output folder.')
    
    # parser default settings
    parser.set_defaults(i1='')
    parser.set_defaults(i2='')
    parser.set_defaults(o='../FiguresAndOutputData/DefaultRelativeError/')
    parser.set_defaults(x='x')
    parser.set_defaults(y='N2')
    parser.set_defaults(l1='File1')
    parser.set_defaults(l2='File2')
    parser.set_defaults(fs=18)
    parser.set_defaults(showFigure=False)

    # parse
    args = parser.parse_args(args)

    # terminate if input is not provided
    if args.i1 == '':
        sys.exit(
            '\nAdd either one or multiple flamelet files or a directory containing flamelet file(s): "-i1 <path>"!')
    elif args.i2 == '':
        sys.exit(
            '\nAdd either one or multiple flamelet files or a directory containing flamelet file(s): "-i2 <path>"!')

    # create output-directory
    if not os.path.exists(args.o):
        os.makedirs(args.o)

    # read file(s)
    if args.i1 != '':
        if os.path.isdir((args.i1)[0]):
            path = args.i1[0]
            files1 = [os.path.join(path, f) for f in os.listdir(
                path) if os.path.isfile(os.path.join(path, f))]
        else:
            files1 = [(args.i1)[x] for x in range(len(args.i1))]
    if args.i2 != '':
        if os.path.isdir((args.i2)[0]):
            path = args.i2[0]
            files2 = [os.path.join(path, f) for f in os.listdir(
                path) if os.path.isfile(os.path.join(path, f))]
        else:
            files2 = [(args.i2)[x] for x in range(len(args.i2))]

    # sort datafiles
    files1 = sorted(files1)
    files2 = sorted(files2)

    # figure: define font
    font = {'size': args.fs}
    plt.rcParams['font.family'] = 'serif'
    plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
    plt.rc('font', **font)
    plt.rc('axes', unicode_minus=False, linewidth=1.0)

    calculate_relative_error(files1, files2, args.o, args.x, args.y, args.l1, args.l2, args.showFigure)

    return


if __name__ == "__main__":
    main()
