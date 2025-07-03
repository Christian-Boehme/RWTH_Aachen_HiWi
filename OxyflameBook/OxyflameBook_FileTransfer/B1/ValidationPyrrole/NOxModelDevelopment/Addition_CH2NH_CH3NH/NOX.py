#!/usr/bin/env python3

import os
import sys
import pandas as pd


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


def read_mechanism(mech):
    with open(mech, "r") as inp:
        return [line.rstrip() for line in inp]


def write_mechanism(fname, submech):

    with open(fname, "w") as out:
        for line in submech:
            out.write(line + '\n')


def rename_species(s, df):

    renamed_spec = []
    for i in s:
        if i in list(df[df.columns[0]]):
            renamed_spec.append(
                list(df[df.columns[1]].iloc[df.index[df[df.columns[0]] == i]])[0])
        else:
            renamed_spec.append(i)
    return renamed_spec


def extract_submechanism(mech, species, comment_spec):

    # comment all reactions containing this certain species
    comment_spec = comment_spec[:-1]

    # allocate memory
    commented_mech = []
    species_submech = []
    tot_submech = []
    reaction_part = False
    press_dep = False

    # prefix
    cline = '! ' + str(species) + ' containing reaction: '

    for line in mech:
        # if len(remove_space(line)) == 0:
        #    continue
        wrote_to_file = False
        if remove_space(line).upper() == 'REACTIONS':
            reaction_part = True
        if remove_space(line).upper() == 'END':
            reaction_part = False
        if press_dep:
            if '=' not in line:
                species_submech.append(line)
                if len(comment_spec) > 0:
                    if len(list(set(comment_spec) & set(spec))) == 0:
                        tot_submech.append(line)
                else:
                    tot_submech.append(line)
                commented_mech.append(cline + line)
                wrote_to_file = True
            else:
                press_dep = False
        if reaction_part:
            # if condition: is this ok?
            if '=' in line and not remove_space(line).startswith('!') and not remove_space(line).startswith('PLOG') and not remove_space(line).startswith('LOW'):
                reac = line.split(' ')
                lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, a = SpeciesInReaction(
                    reac[0])
                if '\t' in rhs_spec[-1]:
                    rhs_spec[-1] = rhs_spec[-1].replace('\t', '')
                spec = lhs_spec + rhs_spec
                if species in spec:
                    species_submech.append(line)
                    if len(comment_spec) > 0:
                        if len(list(set(comment_spec) & set(spec))) == 0:
                            tot_submech.append(line)
                    else:
                        tot_submech.append(line)
                    press_dep = True
                    commented_mech.append(cline + line)
                    wrote_to_file = True
        if wrote_to_file is False:
            commented_mech.append(line)

    return commented_mech, species_submech, tot_submech


# run/execute
BaseMech = sys.argv[1] 
#needed_all = ['C5H5N', 'C5H4N', 'C5H5NO', 'C5H4NO', 'C5H4NO2', 'PYRLYL', 'bNC4H4CO', 'C3H3ONCO', 
#        'C4H4CN', 'CHCHCN', 'C4H5N', 'PYRLNE', 'CH2CHCN', 'HNCN', 'C2N2', 'HOCN', 'CH3CN', 'CH2CN', 
#        'HCNO', 'N2H2', 'NNH', 'NH2', 'NH', 'HNO', 'HONO', 'N', 'H2NO', 'N2O', 'NH3', 'NO',     
#        'NO2', 'N2H3', 'HCN', 'HNC', 'CN', 'HNCO', 'NCO', 'NCN', 'CH3NH2', 'H2CN'] # all

needed = ['CH2NH', 'CH3CN']
#print('Remove ' + str(len(needed_all) - len(needed)) + ' N-species')

mech = read_mechanism(BaseMech)
press_active = False
req = False
with open('SubMech.mech', 'w') as o:
    for line in mech:
        #print(line)
        if line.startswith(' ') or line.startswith('\t') or line.startswith('TROE') or line.count('/') > 1 or line.startswith('!') or len(remove_space(line)) == 0:
            if press_active:
                print(line) # write
                o.write('\n' + line)
            continue
        press_active = False
        #print('Reaction: ', line.split(' ')[0])
        lhs_spec, lhs_coeff, rhs_spec, rhs_coeff, app = SpeciesInReaction(line.split(' ')[0])
        species = list(set(lhs_spec + rhs_spec))
        #print('Species: ', species)
        req = True
        for i in species:
            if i not in needed:
                print('=> REMOVE: ' + str(i) + ': ', line)
                req = False
                break
        if req:
            press_active = True
            # write
            o.write('\n' + line)
            

