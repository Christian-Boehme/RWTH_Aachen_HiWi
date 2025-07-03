#!/usr/bin/env python3

import argparse
import pandas as pd

def main(args=None):

    #
    parser = argparse.ArgumentParser(description='Create gnuplot input file')
    #
    parser.add_argument('-o', type=str, required=True, help='Name of output file')
    parser.add_argument('-i1', type=str, required=True, help='(1) path to integrated average data (required)')
    parser.add_argument('-i2', type=str, required=False, help='(2) path to integrate average data (optional)')
    parser.add_argument('-i3', type=str, required=False, help='(3) path to integrated average data (optional)')
    parser.add_argument('-i4', type=str, required=False, help='(4) path to integrated average data (optional)')
    parser.add_argument('-i5', type=str, required=False, help='(5) path to integrated average data (optional)')
    parser.add_argument('-i6', type=str, required=False, help='(6) path to integrated average data (optional)')
    #
    parser.set_defaults(i2='')
    parser.set_defaults(i3='')
    parser.set_defaults(i3='')
    parser.set_defaults(i4='')
    parser.set_defaults(i5='')
    parser.set_defaults(i6='')
    #
    args = parser.parse_args(args)

    out = args.o
    if not out.endswith('.txt'):
        out += '.txt'
    
    # allocate memory
    Data = []
    Temp = [1300, 1400, 1500]

    #
    df = pd.read_csv(args.i1, sep='\t', low_memory=False)
    df = df.rename(columns=lambda x: x.strip())
    Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    if args.i2 != '':
        df = pd.read_csv(args.i2, sep='\t', low_memory=False)
        df = df.rename(columns=lambda x: x.strip())
        Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    if args.i3 != '':
        df = pd.read_csv(args.i3, sep='\t', low_memory=False)
        df = df.rename(columns=lambda x: x.strip())
        Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    if args.i4 != '':
        df = pd.read_csv(args.i4, sep='\t', low_memory=False)
        df = df.rename(columns=lambda x: x.strip())
        Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    if args.i5 != '':
        df = pd.read_csv(args.i5, sep='\t', low_memory=False)
        df = df.rename(columns=lambda x: x.strip())
        Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    if args.i6 != '':
        df = pd.read_csv(args.i6, sep='\t', low_memory=False)
        df = df.rename(columns=lambda x: x.strip())
        Data.append(df['VolX_NO'][0] + df['VolX_NO2'][0])
    Data1 = [x * 1E+06 for x in Data[:3]]
    Data2 = [x * 1E+06 for x in Data[3:]]
    df = pd.DataFrame({'Temperature': Temp, 'Inj_20': Data1, 'Inj_0': Data2})
    df.columns = list([col.rjust(20, ' ') for col in df.columns])
    df.to_csv(out, sep='\t', float_format='%20.6E', index=False)
    #print('IntAvg NOx [ppm]: ', [x * 1E+06 for x in Data])

    return


if __name__ == '__main__':
    main()
