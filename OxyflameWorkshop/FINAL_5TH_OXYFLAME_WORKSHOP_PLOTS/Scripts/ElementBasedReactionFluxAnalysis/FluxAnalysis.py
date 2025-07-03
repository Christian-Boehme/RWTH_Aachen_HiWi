#!usr/bin/env python3

import os
import sys
import argparse
import pandas as pd
from core import RPA as rpa
from core import ROPA as ropa
from core import Utils as utils
from core import PRates as prates
from core import MechanismDependentFunctions as mdf


class StoreDictKeyPair(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        my_dict = {}
        for kv in values.split(','):
            k, v = kv.split("=")
            my_dict[k] = v
        setattr(namespace, self.dest, my_dict)


def ComputeElementFluxes(element, df, start_time, end_time, save, outdir, species):

    # time range
    if start_time == 0 and end_time == 0:
        start = 0
        end = int(df.shape[0])
    else:
        start, end = utils.DetermineStartAndEndIteration(
            df, start_time, end_time)

    # molecular weight of element
    if element == 'N':
        MM_ele = 14.0067
    elif element == 'H':
        MM_ele = 1.00794
    elif element == 'C':
        MM_ele = 12.0107
    elif element == 'O':
        MM_ele = 15.9994
    else:
        sys.exit('Unsupported element ' + str(element) + '!')

    # species list
    species_list = mdf.Species()

    # reaction list
    reactions, net_reactions = mdf.Reactions()

    # elemental composition of each species
    ele_df = mdf.ElementalComposition(species_list)

    # index of element in df
    ele_idx = ele_df.index.to_list().index(element)

    # element in reaction
    ele_in_reac = utils.ElementContainingReactions(
        net_reactions, ele_df, ele_idx)

    # compute net reaction rate
    W, CDOTp, CDOTd, CDOT = utils.NetReactionRate(
        reactions, species_list, start, end, df, net_reactions)

    # integrate net reaction rates in time
    if W.shape[0] > 1:
        W_int = utils.TimeIntegratedNetReactionRate(W, df.iloc[start:end, :])

    if save:
        # (integrated) net reaction rate and species production rate to file
        W.to_csv(outdir + 'NetReactionRates.csv', sep='\t',
                 float_format='%20.6E', index=False)
        W_int.to_csv(outdir + '/TimeIntegratedNetReactionRate.csv',
                     sep='\t', float_format='%20.6E', index=False)
        CDOTp.columns = list([col.rjust(20, ' ') for col in CDOTp.columns])
        CDOTd.columns = list([col.rjust(20, ' ') for col in CDOTd.columns])
        CDOT.columns = list([col.rjust(20, ' ') for col in CDOT.columns])

        CDOTp.to_csv(outdir + '/SpeciesProductionRates.csv',
                     sep='\t', float_format='%20.6E', index=False)
        CDOTd.to_csv(outdir + '/SpeciesDestructionRates.csv',
                     sep='\t', float_format='%20.6E', index=False)
        CDOT.to_csv(outdir + '/SpeciesNetProductionRates.csv',
                    sep='\t', float_format='%20.6E', index=False)

    # compute mass flux of element containing species for ROPA
    L_species = utils.SpeciesMassFlux(
        species_list, net_reactions, element, ele_idx, MM_ele, ele_df, ele_in_reac, W_int, save, outdir)

    # compute mass flux of element for RPA
    L = utils.MassFluxOfElement(species_list, net_reactions, W_int,
                                ele_in_reac, ele_df, ele_idx, MM_ele, element, save, outdir)


def main(args=None):

    # create output folder
    outdir = 'Output'
    if not os.path.exists(outdir):
        os.makedirs(outdir)
    if not outdir.endswith('/'):
        outdir += '/'

    # parser description
    parser = argparse.ArgumentParser(
        description='Flux analysis to perform a rate of production analysis or reaction pathway analysis.')

    # parsser options
    parser.add_argument('-i', type=str, required=False,
                        help='Input file containing data to compute the mass flux.')
    parser.add_argument('-L_ROPA_1', type=str, required=False,
                        help='First input file containing the element containing species mass fluxes for the ROPA.')
    parser.add_argument('-L_ROPA_2', type=str, required=False,
                        help='Second input file (optional) containing the element containing species mass fluxes for the ROPA.')
    parser.add_argument('-L_ROPA_3', type=str, required=False,
                        help='Third input file (optional) containing the element containing species mass fluxes for the ROPA.')
    parser.add_argument('-L_ROPA_4', type=str, required=False,
                        help='Fourth input file (optional) containing the element containing species mass fluxes for the ROPA.')
    parser.add_argument('-L_RPA', type=str, required=False,
                        help='Input file containing the normalized mass flux file for the RPA.')
    parser.add_argument('-IntRRates', type=str, required=False,
                        help='Input file containing the integrated reaction rates, required for the RPA.')
    parser.add_argument('-target', type=str, required=False,
                        help='Target species for RPA.')
    parser.add_argument('-element', type=str, required=False,
                        help='Element for the flux calculations. Default element is N, supported are: H, C, N, and O.')
    parser.add_argument('-tstart', type=float, required=False,
                        help='Initital time in ms for the element flux calculation. Default is 0ms.')
    parser.add_argument('-tend', type=float, required=False,
                        help='Last time step for the element flux calculation. See option "-tstart".')
    parser.add_argument('-DeacFileSave', action='store_false', required=False,
                        help='If specified, element flux data are NOT saved to a seperate file. Default is true.')
    parser.add_argument('-species', type=str, required=False,
                        help='Species for the ROPA or species for the initial node in the RPA.')
    parser.add_argument('-limit', type=float, required=False,
                        help='Defines the limit for the normalized fluxes for the ROPA or RPA. Default: 3 [%%]')
    parser.add_argument('-f', type=str, required=False,
                        help='Font of figure. Default: Times')
    parser.add_argument('-fs', type=float, required=False,
                        help='Fontsize of figure. Default: 16')
    parser.add_argument('-label_1', type=str, required=False,
                        help='Label for the first input file in the ROPA plot.')
    parser.add_argument('-label_2', type=str, required=False,
                        help='Label for the second input file in the ROPA plot.')
    parser.add_argument('-label_3', type=str, required=False,
                        help='Label for the third input file in the ROPA plot.')
    parser.add_argument('-label_4', type=str, required=False,
                        help='Label for the fourth input file in the ROPA plot.')
    parser.add_argument('-legend_position', type=str, required=False,
                        help='Legend position in the ROPA plot.')
    parser.add_argument('-rcs', action=StoreDictKeyPair, required=False,
                        help='Changes color of (net) reaction. Usage: R1=red,R5=blue,...')
    parser.add_argument('-NodeColor', action=StoreDictKeyPair, required=False,
                        help='Changes color of node in the RPA. Usage: HCN=red,NH3=blue,...')
    parser.add_argument('-xlabel', type=str, required=False,
                        help="x-axis label for the ROPA plot. Default: 'N element flux [%%]'")
    parser.add_argument('-cons', action='store_true', required=False,
                        help='Consider only consumption pathways.')
    parser.add_argument('-prod', action='store_true',
                        required=False, help='Consider only production pathways.')
    # parser.add_argument('N', type=str, required=False, help='Number of reactions (upper limit) for ROPA. Nth dominant reactions. Default is 5')
    parser.add_argument('-NormTotalFlux', action='store_true', required=False,
                        help='Normalize the element flux of all fluxes in the RPA diagram.')
    parser.add_argument('-NormOutGoing', action='store_true', required=False,
                        help='Normalize the element flux of all consumed (outgoing) fluxes in the RPA diagram.')
    parser.add_argument('-DThickness', action='store_false',
                        required=False, help='Disable proportional arrow thickness')
    parser.add_argument('-PRates_1', type=str, required=False,
                        help='Plot production or destruction rates. NOTE: use flag "-species ALL" for every species.')
    parser.add_argument('-PRates_2', type=str, required=False,
                        help='Plot production or destruction rates.')
    parser.add_argument('-PRates_3', type=str, required=False,
                        help='Plot production or destruction rates.')
    parser.add_argument('-PRates_4', type=str, required=False,
                        help='Plot production or destruction rates.')
    parser.add_argument('-single', action='store_true', required=False,
                        help='RPA for target species only - direct neighbours are only considered')
    parser.add_argument('-PrecursorAnalysis', action='store_true', required=False,
                        help='Creates RPA output data - can be used for precursor analysis.')

    # parser default settings
    parser.set_defaults(i='')
    parser.set_defaults(element='N')
    parser.set_defaults(DeacFileSave=True)
    parser.set_defaults(f='serif')
    parser.set_defaults(fs=16)
    parser.set_defaults(species='NH3')
    parser.set_defaults(limit=3)
    parser.set_defaults(tstart=0)
    parser.set_defaults(tend=0)
    # ROPA specific
    parser.set_defaults(L_ROPA_1='')
    parser.set_defaults(L_ROPA_2='')
    parser.set_defaults(L_ROPA_3='')
    parser.set_defaults(L_ROPA_4='')
    parser.set_defaults(label_1='')
    parser.set_defaults(label_2='')
    parser.set_defaults(label_3='')
    parser.set_defaults(label_4='')
    parser.set_defaults(legend_position='best')
    parser.set_defaults(rcs={})
    parser.set_defaults(cons=False)
    parser.set_defaults(prod=False)
    parser.set_defaults(xlabel='N element flux [%]')
    parser.set_defaults(num_reac=20)
    # RPA specific
    parser.set_defaults(L_RPA='')
    parser.set_defaults(IntRRates='')
    parser.set_defaults(target='')
    parser.set_defaults(NodeColor={})
    parser.set_defaults(NormTotalFlux=False)
    parser.set_defaults(NormOutGoing=False)
    parser.set_defaults(DThickness=True)
    parser.set_defaults(single=False)
    # Production rates
    parser.set_defaults(PRates_1='')
    parser.set_defaults(PRates_2='')
    parser.set_defaults(PRates_3='')
    parser.set_defaults(PRates_4='')
    # Precursor analysis
    parser.set_defaults(PrecursorAnalysis=False)

    # parse
    args = parser.parse_args(args)

    # execute
    if args.i != '':
        # calculate element flux
        df = pd.read_csv(args.i, sep=r'\s+', low_memory=False)
        ComputeElementFluxes(args.element, df, args.tstart,
                             args.tend, args.DeacFileSave, outdir, args.species)
    elif args.L_ROPA_1 != '':
        # rate of production analysis
        L_ROPA_1 = pd.read_csv(args.L_ROPA_1, sep=r'\s+',
                               header=0, low_memory=False)

        if args.L_ROPA_2 != '':
            L_ROPA_2 = pd.read_csv(
                args.L_ROPA_2, sep=r'\s+', header=0, low_memory=False)
        else:
            L_ROPA_2 = ''

        if args.L_ROPA_3 != '':
            L_ROPA_3 = pd.read_csv(
                args.L_ROPA_3, sep=r'\s+', header=0, low_memory=False)
        else:
            L_ROPA_3 = ''

        if args.L_ROPA_4 != '':
            L_ROPA_4 = pd.read_csv(
                args.L_ROPA_4, sep=r'\s+', header=0, low_memory=False)
        else:
            L_ROPA_4 = ''
        ropa.GeneratePlot(args.f, args.fs, L_ROPA_1, L_ROPA_2, L_ROPA_3, L_ROPA_4, args.species, args.limit,
                          outdir, args.label_1, args.label_2, args.label_3, args.label_4, args.legend_position,
                          args.rcs, args.xlabel, args.num_reac, args.cons, args.prod)

    elif args.L_RPA != '':
        # reaction path analysis
        if args.IntRRates == '':
            sys.exit('\n"-IntRRates" flag required!')
        if args.target == '':
            sys.exit('\n"-target <species>" flag required!')
        L_RPA = pd.read_csv(args.L_RPA, sep=r'\s+', low_memory=False)
        q = pd.read_csv(args.IntRRates, sep='\t', low_memory=False)
        rpa.GenerateGraphic(L_RPA, args.target, args.species, args.limit, args.f,
                            args.fs, args.NodeColor, q, args.NormTotalFlux, args.NormOutGoing, args.DThickness, args.single, outdir, args.PrecursorAnalysis)

    elif args.PRates_1 != '':
        # production rates
        prates.CreateProductionRatesFigures(args.PRates_1, args.PRates_2, args.PRates_3, outdir,
                                            args.species, args.fs, args.label_1, args.label_2, args.label_3, args.legend_position)
    else:
        sys.exit('\nNo input specified!')

    return


if __name__ == '__main__':
    main()
