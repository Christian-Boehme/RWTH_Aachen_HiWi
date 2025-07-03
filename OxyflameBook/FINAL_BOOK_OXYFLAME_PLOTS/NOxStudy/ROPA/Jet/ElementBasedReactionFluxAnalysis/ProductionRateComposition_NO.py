#!/usr/bin/eny python3

import argparse
import pandas as pd
import matplotlib.pyplot as plt
from core import Utils as utils
from core import MechanismDependentFunctions as mdf


def ExtractZeldovichReactions(r):

    Zeldovich = [['N2', 'O', 'NO', 'N'], [
        'O2', 'N', 'NO', 'O'], ['N', 'OH', 'NO', 'H']]

    zeldovich = []
    for i in range(len(r)):
        found = False
        lhs_spec, lhs_coeff, rhs_spec, rhs_coeff = utils.SpeciesInReaction(
            r[i])
        if len(list(set(Zeldovich[0]) - set(list(lhs_spec + rhs_spec)))) == 0:
            found = True
        elif len(list(set(Zeldovich[1]) - set(list(lhs_spec + rhs_spec)))) == 0:
            found = True
        elif len(list(set(Zeldovich[2]) - set(list(lhs_spec + rhs_spec)))) == 0:
            found = True

        if found:
            zeldovich.append(r[i])

    return zeldovich


def main(args=None):

    # description
    parser = argparse.ArgumentParser(
        description='Compute the contribution of thermal-NO (Zeldovich) on the total NO source term.')

    # options
    parser.add_argument('-i', type=str, required=True,
                        help='Input file containing the (volumetric averaged) data - mass fractions or reaction rates.')
    parser.add_argument('-tend', type=float, required=False, help='Last time step [ms]')

    # default settings
    parser.set_defaults(i='')
    parser.set_defaults(tend=-1)
    parser.set_defaults(Coal=False)

    args = parser.parse_args(args)

    df = pd.read_csv(args.i, sep=r'\s+', low_memory=False)
    if args.tend == -1:
        tend = df.shape[0]  # use all input data
    else:
        for i in range(df.shape[0]):
            if df['time[ms]'][i] * 1000 >= args.tend:
                tend = i
                break

    reactions, net_reactions = mdf.Reactions()
    Zeldovich = ExtractZeldovichReactions(reactions)
    species_list = mdf.Species()
    W, CDOT, CDOTp, CDOTd = utils.ComputeReactionRateAndProductionRate(
        reactions, species_list, 0, tend, df)

    # thermal-NO
    CDOT_tNO = 0
    for i in Zeldovich:
        reactants, products, cr, cp = utils.DetermineReactantAndProductSpecies(
            i, W)
        if 'NO' in reactants:
            CDOT_tNO -= W[i]
        elif 'NO' in products:
            CDOT_tNO += W[i]

    # integated average
    int_av_thermalNO = 0
    int_av_NO = 0
    for i in range(1, tend):
        int_av_thermalNO += CDOT_tNO[i] * \
            (df['time[ms]'][i] - df['time[ms]'][i-1])
        int_av_NO += CDOT['NO'][i] * (df['time[ms]'][i] - df['time[ms]'][i-1])
    int_av_thermalNO = int_av_thermalNO / \
            (df['time[ms]'][tend - 1] - df['time[ms]'][0])
    int_av_NO = int_av_NO / (df['time[ms]'][tend - 1] - df['time[ms]'][0])


    # print results
    thermal_cont = int_av_thermalNO / int_av_NO * 100  # [%]
    print('thermal-NO contribution: ', thermal_cont, '%')
    print('fuel-NO contribution:    ', 100 - thermal_cont, '%')

    # save data to file
    time = CDOT['time[ms]'].to_list()
    Fuel_NO = CDOT['NO'].to_list()

    df = pd.DataFrame(list(zip(time, Fuel_NO, CDOT_tNO.to_list())), columns=[
                      'time', 'Fuel-NO', 'Thermal-NO'])

    df.columns = list([col.rjust(20, ' ') for col in df.columns])
    df.to_csv('ThermalNOContribution.csv', sep='\t',
              float_format='%20.6E', index=False)


if __name__ == '__main__':
    main()
