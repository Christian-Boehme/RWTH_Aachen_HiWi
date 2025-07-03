#!usr/bin/env python3

import sys
import argparse
import pandas as pd


# NOTE:species names must be the same

def read_mechanism(mech):
    with open(mech, "r") as inp:
        return [line.rstrip() for line in inp]


def remove_space(string):
    return "".join(string.split())


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

    # delete '<' and '>' from reaction => all reactionw have the same structure
    r = r.replace('<', '')
    r = r.replace('>', '')
    # determine reactants and products
    rs = r.split('=')
    lhs = rs[0]
    rhs = rs[1]
    # remove third-body
    app = ''
    if '+M' in lhs and '+M' in rhs:
        if '(+M)' in lhs and '(+M)':
            lhs = lhs.split('(+M)')
            lhs = lhs[0]
            rhs = rhs.split('(+M)')
            rhs = rhs[0]
            app = '(+M)'
        else:
            lhs = lhs.split('+M')
            lhs = lhs[0]
            rhs = rhs.split('+M')
            rhs = rhs[0]
            app = '+M'
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

    return lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, app


def extract_reactions(mech):

    reac = []
    for line in mech:
        if remove_space(line).startswith('!'):
            continue
        if '=' in line:
            reac.append(line)

    return reac


def extract_data(reac, s):

    #
    df = pd.DataFrame(columns=['Reaction', 'A', 'n', 'E'])

    for line in reac:
        if '\t' in line:
            line = line.replace('\t', ' ')
        sline = line.split(' ')
        sline = [x for x in sline if len(x) != 0]
        r = sline[0]
        lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, tb = SpeciesInReaction(r)
        species = list(set(lhs_spec + rhs_spec))
        if s in species:
            df.loc[len(df.index)] = sline

    return df


def filter_reaction(df_full, s, s2):

    #
    df = pd.DataFrame(columns=['Reaction', 'A', 'n', 'E'])

    for i in range(df_full.shape[0]):
        r = df_full.iat[i, 0]
        lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, tb = SpeciesInReaction(r)
        if (s in lhs_spec and s2 in lhs_spec) or (s in rhs_spec and s2 in rhs_spec):
            continue
        species = list(set(lhs_spec + rhs_spec))
        if s2 in species:
            df.loc[len(df.index)] = df_full.loc[i, :].values.flatten().tolist()

    return df


def sort_reactions(df_ref, df_mod):

    #
    found = False
    identical_reactions = []
    df = pd.DataFrame(columns=['Reaction', 'A', 'n', 'E'])

    for i in range(df_ref.shape[0]):
        ref_r = df_ref.iat[i, 0]
        ref_lhs_spec, lhs_coeff, ref_rhs_spec, rhs_coeff, tb = SpeciesInReaction(
            ref_r)
        ref_species = sorted(list(set(ref_lhs_spec + ref_rhs_spec)))
        for j in range(df_mod.shape[0]):
            r = df_mod.iat[j, 0]
            lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, tb = SpeciesInReaction(r)
            species = sorted(list(set(lhs_spec + rhs_spec)))
            if ref_species == species:
                if sorted(ref_lhs_spec) == sorted(lhs_spec) or sorted(ref_lhs_spec) == sorted(rhs_spec):
                    identical_reactions.append(j)
                    df.loc[len(df.index)] = df_mod.iloc[j,
                                                        :].values.flatten().tolist()
                    found = True
                    break
        if found:
            found = False
        else:
            df.loc[len(df.index)] = ['-', '-', '-', '-']

    for i in range(df_mod.shape[0]):
        if i not in identical_reactions:
            df_ref.loc[len(df_ref.index)] = ['-', '-', '-', '-']
            df.loc[len(df.index)] = df_mod.iloc[i, :].values.flatten().tolist()

    return df_ref, df


def main(args=None):

    parser = argparse.ArgumentParser(description='')

    # parser options
    parser.add_argument('-i', type=str, required=True, help='')
    parser.add_argument('-j', type=str, required=True, help='')
    parser.add_argument('-s', type=str, required=True, help='')
    parser.add_argument('-p', type=str, required=True, help='')
    parser.add_argument('-sort', action='store_true', required=False, help='')

    # parser default settings
    parser.set_defaults(sort=False)

    #
    args = parser.parse_args(args)

    ref_mech = read_mechanism(args.i)
    mod_mech = read_mechanism(args.j)

    # consider only reactions (remove all comments, pressure dependencies, ...)
    ref_reac = extract_reactions(ref_mech)
    mod_reac = extract_reactions(mod_mech)

    # df: reaction, A, n, E
    df_ref = extract_data(ref_reac, args.s)
    df_mod = extract_data(mod_reac, args.s)

    # get reactions with second species of interest
    df_ref_filtered = filter_reaction(df_ref, args.s, args.p)
    df_mod_filtered = filter_reaction(df_mod, args.s, args.p)

    if args.sort:
        # sort filtered reactions according to reference mechanism
        df_ref_filtered, df_mod_filtered = sort_reactions(
            df_ref_filtered, df_mod_filtered)
        print('\n', pd.concat([df_ref_filtered, df_mod_filtered], keys=[
              '-i mechanism', '-j mechanism'], axis=1))
    else:
        print('Reference mechanism:\n', df_ref_filtered)
        print('\nSecond mechanism:\n', df_mod_filtered)

    print('\n\nNote: pressure dependence is not considered!')
    return


if __name__ == '__main__':
    main()
