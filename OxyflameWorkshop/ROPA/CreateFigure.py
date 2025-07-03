#!usr/bin/env python3

import re
import sys
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# figure environment
font = {'size': 20}
plt.rcParams['font.family'] = 'serif'
plt.rcParams['font.serif'] = [
        'Times New Roman'] + plt.rcParams['font.serif']
plt.rc('font', **font)
plt.rc('axes', unicode_minus=False, linewidth=1.0)
#plt.rcParams["figure.figsize"] = (6,8) #(20,3)


class StoreDictKeyPair(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        my_dict = {}
        for kv in values.split(','):
            k, v = kv.split(":")
            my_dict[k] = v
        setattr(namespace, self.dest, my_dict)


def MergeData(df_c, df_data, pos):
    
    #print(df_data)
    r_data = df_data['Reactions'].to_list()

    for i in range(df_c.shape[0]):
        r_c = df_c.iat[i, 0]
        if r_c in r_data:
            df_c.iat[i, pos] = float(df_data['Percentage'][r_data.index(r_c)])

    return df_c


def SplitSpeciesFromCoefficient(cs):

    res_idx = []
    species = []
    elements = ['H', 'C', 'N', 'O']
    if cs[0] == '.':
        cs = '0' + cs
    for spec in cs:
        idx = [spec.index(x) for x in spec if x.isalpha()]
        if len(idx) == 0:
            idx.append(0)
        species.append(spec[min(idx):])
        if spec[:min(idx)] == '':
            res_idx.append(1)
        else:
            if spec[:min(idx)][-1] == '.':
                res_idx.append(float(spec[:min(idx)-1]))
            else:
                res_idx.append(float(spec[:min(idx)]))

    return res_idx, species


def MergeSpeciesAndCoefficients(c, s):

    found_duplicate = True
    while found_duplicate:
        for i in range(len(s)):
            if s.count(s[i]) > 1:
                dup_s = s[i]
                dup_c = c[i]
                del s[i]
                del c[i]
                c[s.index(dup_s)] += dup_c
                break
        if len([x for x in s if s.count(x) > 1]) == 0:
            found_duplicate = False

    return c, s


def SpeciesInReaction(r):

    # determine reactants and products
    rs = r.split('=')
    lhs = rs[0]
    rhs = rs[1]
    # remove third-body
    if '+M' in lhs:
        if '(+M)' in lhs:
            lhs = lhs.split('(+M)')
            lhs = lhs[0]
            rhs = rhs.split('(+M)')
            rhs = rhs[0]
        else:
            lhs = lhs.split('+M')
            lhs = lhs[0]
            rhs = rhs.split('+M')
            rhs = rhs[0]
    # determine species
    lhs_spec = lhs.split('+')
    rhs_spec = rhs.split('+')
    # split stoichiometric coefficient (integer or floating point)
    lhs_coeff, lhs_spec = SplitSpeciesFromCoefficient(lhs_spec)
    rhs_coeff, rhs_spec = SplitSpeciesFromCoefficient(rhs_spec)
    # check if a species occurs more than one time on a reaction-side
    if len([x for x in lhs_spec if lhs_spec.count(x) > 1]) != 0:
        lhs_coeff, lhs_spec = MergeSpeciesAndCoefficients(lhs_coeff, lhs_spec)
    if len([x for x in rhs_spec if rhs_spec.count(x) > 1]) != 0:
        rhs_coeff, rhs_spec = MergeSpeciesAndCoefficients(rhs_coeff, rhs_spec)
    # check if species occurs on both sides -> not reacting species!
    # if len(list(set(lhs_spec) & set(rhs_spec))) != 0:
    #    duplicate = list(set(lhs_spec) & set(rhs_spec))
    #    lhs_idx = list(map(lhs_spec.index, duplicate))
    #    rhs_idx = list(map(rhs_spec.index, duplicate))
    #    rhs_idx = list(map(rhs_spec.index, duplicate))
    #    if len(lhs_idx) != 1 or len(rhs_idx) != 1:
    #        # should normally not be the case ...
    #        sys.exit('\nSpecies occurs more than two times in recation!?!')
    #    if lhs_coeff[lhs_idx[0]] == rhs_coeff[rhs_idx[0]]:
    #        del lhs_spec[lhs_idx[0]]
    #        del lhs_coeff[lhs_idx[0]]
    #        del rhs_spec[rhs_idx[0]]
    #        del rhs_coeff[rhs_idx[0]]

    return lhs_spec, lhs_coeff, rhs_spec, rhs_coeff


def DetermineReactantAndProductSpecies(r, p, s):

    # O+NO+NO=X returns for lhs_species: [O, NO] with lc (coeff): [1, 2]
    lhs_species, lc, rhs_species, rc = SpeciesInReaction(r)
     
    if p > 0 and s in rhs_species:
        reactants = lhs_species
        products = rhs_species
        coeff_reac = lc
        coeff_prod = rc
    elif p > 0 and s in lhs_species:
        reactants = rhs_species
        products = lhs_species
        coeff_reac = rc
        coeff_prod = lc
    elif p < 0 and s in rhs_species:
        reactants = rhs_species
        products = lhs_species
        coeff_reac = rc
        coeff_prod = lc
    elif p < 0 and s in lhs_species:
        reactants = lhs_species
        products = rhs_species
        coeff_reac = rc
        coeff_prod = lc

    return reactants, products, coeff_reac, coeff_prod


def calculate_ticks(xmin, xmax, step):

    # Calculate the start and end ticks based on the range
    # Round down to the nearest multiple of step
    x_start = np.floor(xmin / step) * step
    # Round up to the nearest multiple of step
    x_end = np.ceil(xmax / step) * step
    
    ticks = np.arange(x_start, x_end + step, step)
    # ensure that '0' is included
    if 0 not in ticks:
        if ticks[0] < 0:
            ticks = np.append(ticks, 0)
        else:
            ticks = np.append(0, ticks)

    return ticks


def CreateFigure(cases, limit, outdir, f1, f2, f3, f4, f5, f6, label1, label2, label3, label4, label5, label6, legend_pos, reac_color, x_label, species, cons, prod):

    # read data
    df1 = pd.read_csv(f1, sep='\t')
    r1 = df1['Reactions'].to_list()
    r1 = [x.split(': ')[1] for x in r1]
    df1['Reactions'] = r1
    reac = r1
    if cases >= 2:
        df2 = pd.read_csv(f2, sep='\t')
        r2 = df2['Reactions'].to_list()
        r2 = [x.split(': ')[1] for x in r2]
        df2['Reactions'] = r2
        for r in r2:
            if r not in reac:
                reac.append(r)
    if cases >= 3:
        df3 = pd.read_csv(f3, sep='\t')
        r3 = df3['Reactions'].to_list()
        r3 = [x.split(': ')[1] for x in r3]
        df3['Reactions'] = r3
        for r in r3:
            if r not in reac:
                reac.append(r)
    if cases >= 4:
        df4 = pd.read_csv(f4, sep='\t')
        r4 = df4['Reactions'].to_list()
        r4 = [x.split(': ')[1] for x in r4]
        df4['Reactions'] = r4
        for r in r4:
            if r not in reac:
                reac.append(r)
    if cases >= 5:
        df5 = pd.read_csv(f5, sep='\t')
        r5 = df5['Reactions'].to_list()
        r5 = [x.split(': ')[1] for x in r5]
        df5['Reactions'] = r5
        for r in r5:
            if r not in reac:
                reac.append(r)
    if cases >= 6:
        df6 = pd.read_csv(f6, sep='\t')
        r6 = df6['Reactions'].to_list()
        r6 = [x.split(': ')[1] for x in r6]
        df6['Reactions'] = r6
        for r in r6:
            if r not in reac:
                reac.append(r)


    # empty global df
    df_complete = pd.DataFrame(float(0.0), columns=['Reactions', 'Case1', 'Case2', 'Case3', 'Case4', 'Case5', 'Case6'], index=np.arange(len(reac)))
    df_complete['Reactions'] = reac
    #print(df_complete)

    if cases >= 1:
        df_complete = MergeData(df_complete, df1, 1)
    if cases >= 2:
        df_complete = MergeData(df_complete, df2, 2)
    if cases >= 3:
        df_complete = MergeData(df_complete, df3, 3)
    if cases >= 4:
        df_complete = MergeData(df_complete, df4, 4)
    if cases >= 5:
        df_complete = MergeData(df_complete, df5, 5)
    if cases >= 6:
        df_complete = MergeData(df_complete, df6, 6)

    # remove reaction if all "cases"(percentage for all cases) are below the limit
    RemoveReaction = []
    for i in range(df_complete.shape[0]):
        KeepReaction = False
        for j in range(1, df_complete.shape[1]):
            if abs(df_complete.iat[i, j]) > limit:
                KeepReaction = True
        if not KeepReaction:
            RemoveReaction.append(i)
    if len(RemoveReaction) != 0:
        df_complete = df_complete.drop(RemoveReaction)
        #df_complete.index(np.arange)
    #print(df_complete)

    # sort df
    col = list(df_complete.columns)
    df_complete = df_complete.sort_values(by=col[1], key=lambda x: x.abs())

    # data set for figure
    if cases >= 1:
        Data1 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case1'].values]))
    if cases >= 2:
        Data2 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case2'].values]))
    if cases >= 3:
        Data3 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case3'].values]))
    if cases >= 4:
        Data4 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case4'].values]))
    if cases >= 5:
        Data5 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case5'].values]))
    if cases >= 6:
        Data6 = list(np.concatenate([arr.flatten()
                     for arr in df_complete['Case6'].values]))

    reactions = df_complete['Reactions'].to_list()
    reactions_ = df_complete['Reactions'].to_list()
    N = len(reactions)
    
    # dashed line at x=0
    plt.axvline(0, color='black', linestyle='-')
    
    # grid
    y_ticks_positions = np.arange(N)
    grid_positions = y_ticks_positions + 0.5
    plt.yticks(y_ticks_positions, reactions)
    for pos in grid_positions:
        plt.axhline(pos, color='black', linestyle=':', linewidth=0.5)
    plt.grid(False, axis='y')

    # horizontal bars
    ind = np.arange(N)
    width = 0.25
    if cases == 1:
        width = 0.85
        bwidth = width
        for i in range(len(Data1)):
            if Data1[i] >= 0:
                plt.barh(ind[i], Data1[i], width, color='green')
            else:
                plt.barh(ind[i], Data1[i], width, color='red')
        xmin = min(Data1)
        xmax = max(Data1)
    elif cases == 2:
        bwidth = width * 2 * 0.85
        bar1 = plt.barh(ind+width, Data1, bwidth,
                        color='red', edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind-width, Data2, bwidth,
                        color='green', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2), ('{0}'.format(label1), '{0}'.format(
            label2)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2))
        xmax = max(max(Data1), max(Data2))
    elif cases == 3:
        width = 0.3
        bwidth = width
        bar1 = plt.barh(ind+width, Data1, bwidth, color='black',
                        edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind, Data2, bwidth, color='red',
                        edgecolor='white', linewidth=1)
        bar3 = plt.barh(ind-width, Data3, bwidth,
                        color='blue', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2, bar3), ('{0}'.format(label1), '{0}'.format(
            label2), '{0}'.format(label3)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2), min(Data3))
        xmax = max(max(Data1), max(Data2), max(Data3))
    elif cases == 4:
        plt.rcParams['hatch.linewidth'] = 1.5
        width = 0.25
        bwidth = width * 0.5
        bar1 = plt.barh(ind+width, Data1, bwidth, color='black',
                        edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind+width/2, Data2, bwidth, color='red',
                        edgecolor='white', linewidth=1)
        bar3 = plt.barh(ind-width/2, Data3, bwidth,
                        color='black', hatch='//', edgecolor='white', linewidth=1)
        bar4 = plt.barh(ind-width, Data4, bwidth,
                        color='red', hatch='//', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2, bar3, bar4), ('{0}'.format(label1), '{0}'.format(
            label2), '{0}'.format(label3), '{0}'.format(label4)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2), min(Data3), min(Data4))
        xmax = max(max(Data1), max(Data2), max(Data3), max(Data4))
#    elif cases == 5:
#        plt.rcParams['hatch.linewidth'] = 1.5
#        bwidth = width * 0.9
#        bar1 = plt.barh(ind+width, Data1, bwidth, color='black',
#                        edgecolor='white', linewidth=1)
#        bar2 = plt.barh(ind+width/2, Data2, bwidth, color='#e31a1c',
#                        edgecolor='white', linewidth=1)
#        bar3 = plt.barh(ind, Data3, bwidth,
#                        color='#1f78b4', hatch='//', edgecolor='white', linewidth=1)
#        bar4 = plt.barh(ind-width/2, Data4, bwidth,
#                        color='#e31a1c', hatch='//', edgecolor='white', linewidth=1)
#        bar5 = plt.barh(ind-width, Data5, bwidth,
#                        color='#e31a1c', hatch='//', edgecolor='white', linewidth=1)
#        plt.legend((bar1, bar2, bar3, bar4, bar5), ('{0}'.format(label1), '{0}'.format(
#            label2), '{0}'.format(label3), '{0}'.format(label4), '{0}'.format(label5)), loc=legend_pos, edgecolor='white')
#        xmin = min(min(Data1), min(Data2), min(Data3), min(Data4), min(Data5))
#        xmax = max(max(Data1), max(Data2), max(Data3), max(Data4), max(Data5))
    elif cases == 6:
        plt.rcParams['hatch.linewidth'] = 1.5
        width = 0.25
        bwidth = width * 0.5
        bar1 = plt.barh(ind+width*3/2, Data1, bwidth, color='black',
                        edgecolor='white', linewidth=1)
        bar2 = plt.barh(ind+width, Data2, bwidth, color='red',
                        edgecolor='white', linewidth=1)
        bar3 = plt.barh(ind+width/2, Data3, bwidth,
                        color='blue', edgecolor='white', linewidth=1)
        bar4 = plt.barh(ind-width/2, Data4, bwidth,
                        color='black', hatch='//', edgecolor='white', linewidth=1)
        bar5 = plt.barh(ind-width, Data5, bwidth,
                        color='red', hatch='//', edgecolor='white', linewidth=1)
        bar6 = plt.barh(ind-width*3/2, Data6, bwidth,
                        color='blue', hatch='//', edgecolor='white', linewidth=1)
        plt.legend((bar1, bar2, bar3, bar4, bar5, bar6), ('{0}'.format(label1), '{0}'.format(
            label2), '{0}'.format(label3), '{0}'.format(label4), '{0}'.format(label5), '{0}'.format(label6)), loc=legend_pos, edgecolor='white')
        xmin = min(min(Data1), min(Data2), min(Data3), min(Data4), min(Data5), min(Data6))
        xmax = max(max(Data1), max(Data2), max(Data3), max(Data4), max(Data5), max(Data6))


    # rename reactions: species is consumed => species as reactant & species produced => species as product
    symb = '='
    #symb = '$\\rightleftarrows$'
    for i in range(len(reactions)):
        #print('Reaction: ', reactions[i])
        rename = False
        #print('reaction: ' + str(reactions[i]) + '\tW=' + str(W[reactions[i]][0]))
        reactants, products, a, b = DetermineReactantAndProductSpecies(reactions[i], Data1[i], species)
        if '+M' in reactions[i]:
            reactants[-1] += '(+M)'
            products[-1] += '(+M)'
        if cons and species not in reactants:
            rename = True
        elif prod and species not in products:
            rename = True
        elif prod is False and cons is False and species in reactants:
            rename = True
        #print('rename...: ', rename)
        # i.e.C5H4NO2 = CO+CO+C2H3+HCN function returns 2CO+...
        if sum(a) / len(a) != 1:
            if len(reactants) == 1:
                reactants.append(reactants[0])
            else:
                products.insert(0, products[0])
        if sum(b) / len(b) != 1:
            if len(products) == 1:
                products.append(products[0])
            else:
                products.insert(0, products[0])
        # consider index: H2O to H_2O
        reactants = [re.sub("([0-9])", "_\\1", x) for x in reactants]
        reactants = [r'$\mathregular{'+x+'}$' for x in reactants]
        products = [re.sub("([0-9])", "_\\1", x) for x in products]
        products = [r'$\mathregular{'+x+'}$' for x in products]
        #if rename:
        #    reactions[i] = reactions[i].split(
        #        ': ')[0] + ': ' + '+'.join(products) + symb + '+'.join(reactants)
        #else:
        #    reactions[i] = reactions[i].split(
        #        ': ')[0] + ': ' + '+'.join(reactants) + symb + '+'.join(products)
        if rename:
            reactions[i] = '+'.join(products) + symb + '+'.join(reactants)
        else:
            reactions[i] = '+'.join(reactants) + symb + '+'.join(products)

    # specify xticks
    step = 5
    while ((xmax - xmin)/step > 8):
        step = step*2
    xticks = calculate_ticks(xmin, xmax, step)
    plt.xticks(xticks)

    plt.xlim(min(xticks), max(xticks))
    plt.grid(True, axis='x', linestyle=':', color='black',
             linewidth=0.5)
   
    # modify reaction name color
    color = plt.gca().get_yticklabels()
    for i in range(len(reactions_)):
        r = reactions_[i]
        if r in reac_color.keys():
            color[i].set_color(reac_color[r])
            #reactions[i] = '$\\Longrightarrow $' + reactions[i]
    plt.yticks(ind, reactions)

    plt.xlabel(x_label)

    if cons:
        plt.savefig(outdir + '/ROPA_' + species + '_cons.pdf',
            format="pdf", bbox_inches='tight')
    elif prod:
        plt.savefig(outdir + '/ROPA_' + species + '_prod.pdf',
            format="pdf", bbox_inches='tight')
    else:
        plt.savefig(outdir + '/ROPA_' + species + '.pdf',
                    format="pdf", bbox_inches='tight')

    return


def main(args=None):

    # parser description
    parser = argparse.ArgumentParser(
        description='Rate of production analysis based on input files.')

    # parser options
    parser.add_argument('-i1', type=str, required=True, help='First input file.')
    parser.add_argument('-i2', type=str, required=False, help='Second input file.')
    parser.add_argument('-i3', type=str, required=False, help='Third input file.')
    parser.add_argument('-i4', type=str, required=False, help='Fourth input file.')
    parser.add_argument('-i5', type=str, required=False, help='Fifth input file.')
    parser.add_argument('-i6', type=str, required=False, help='Sixth input file.')
    parser.add_argument('-lim', type=float, required=False, help='Limit/Tolerance for the ROPA.')
    parser.add_argument('-outdir', type=str, required=True, help='Name of output - directory.')
    parser.add_argument('-l1', type=str, required=False, help='Label for input file one.')
    parser.add_argument('-l2', type=str, required=False, help='Label for input file two.')
    parser.add_argument('-l3', type=str, required=False, help='Label for input file three.')
    parser.add_argument('-l4', type=str, required=False, help='Label for input file four.')
    parser.add_argument('-l5', type=str, required=False, help='Label for input file five.')
    parser.add_argument('-l6', type=str, required=False, help='Label for input file six.')
    parser.add_argument('-legend_pos', type=str, required=False, help='Legend position.')
    parser.add_argument('-rcs', action=StoreDictKeyPair, required=False,
            help='Changes color of (net) reaction. Usage: A+B=C+D:red,A+C=B+D:blue,...')
    parser.add_argument('-xlabel', type=str, required=False,
                        help="x-axis label for the ROPA plot. Default: 'N element flux [%%]'")
    parser.add_argument('-species', type=str, required=False,
                        help='Species for the ROPA.')
    parser.add_argument('-cons', action='store_true', required=False,
                        help='Consider only consumption pathways.')
    parser.add_argument('-prod', action='store_true',
                        required=False, help='Consider only production pathways.')
    
    # parser defaults settings
    parser.set_defaults(i2='')
    parser.set_defaults(i3='')
    parser.set_defaults(i4='')
    parser.set_defaults(i5='')
    parser.set_defaults(i6='')
    parser.set_defaults(lim=1)
    parser.set_defaults(l1='')
    parser.set_defaults(l2='')
    parser.set_defaults(l3='')
    parser.set_defaults(l4='')
    parser.set_defaults(l5='')
    parser.set_defaults(l6='')
    parser.set_defaults(legend_pos='best')
    parser.set_defaults(rcs={})
    parser.set_defaults(xlabel='N element flux [%]')
    parser.set_defaults(species='')
    parser.set_defaults(cons=False)
    parser.set_defaults(prod=False)
    
    # parse
    args = parser.parse_args(args)

    # create ROPA figure
    cases = 1
    if args.i2 != '':
        cases += 1
    if args.i3 != '':
        cases += 1
    if args.i4 != '':
        cases += 1
    if args.i5 != '':
        cases += 1
    if args.i6 != '':
        cases += 1
    CreateFigure(cases, args.lim, args.outdir, args.i1, args.i2, args.i3, args.i4, args.i5, args.i6, args.l1, args.l2, args.l3, args.l4, args.l5, args.l6, args.legend_pos, args.rcs, args.xlabel, args.species, args.cons, args.prod)

    return


if __name__ == "__main__":
    main()
