#!usr/bin/env python3

import os
import re
import sys
import argparse


def remove_space(string):
    return "".join(string.split())


def find_species(line):
    return line[line.find('S') + 1: line.find(')')]


def read_file(inp):
    with open(inp, 'r') as input:
        return [line.rstrip() for line in input]


def read_data_header(inp):

    # F90.h file
    buf = read_file(inp)
    for i in range(len(buf)):
        if 'SEND' in buf[i]:
            s_idx = i + 1
        elif 'REND' in buf[i]:
            r_idx = i + 1
        elif 'MEND' in buf[i]:
            tb_idx = i + 1
            break

    s = buf[4:s_idx]        # species
    r = buf[s_idx:r_idx]    # reactions
    tb = buf[r_idx:tb_idx]  # third-bodies
    # total number of species
    n_spec = remove_space(s[-1]).split('=')
    n_spec = int(n_spec[1]) - 1
    # total number of reactions
    n_reac = remove_space(r[-1]).split('=')
    n_reac = int(n_reac[1]) - 1

    return s, r, tb, n_spec, n_reac


def read_data_f90(inp, n_species):

    # F.f90 file
    buf = read_file(inp)
    tbc_idx = 0
    for i in range(len(buf)):
        # third-body concentration
        if 'RT_inv = 1.0_DP' in buf[i] and tbc_idx == 0:
            tbc_idx = i + 3
        # rate coefficients
        elif buf[i - 2] == buf[i - 1] == '' and buf[i].startswith('      K(R'):
            k_idx = i
        # reaction rates
        elif buf[i - 1] == '' and buf[i].startswith('      W(R'):
            w_idx = i
        # production rates
        elif buf[i - 2] == buf[i - 1] == '' and buf[i].startswith('      CDOT(S'):
            cdot_idx = i
        elif '      END' == buf[i]:
            end_idx = i
        elif 'RT_2_inv = 1.0_DP' in buf[i]:
            mm_idx = i + 1
            break

    tbc = buf[tbc_idx:k_idx - 2]        # third-body concentration
    k = buf[k_idx:w_idx - 1]            # rate coefficient
    w = buf[w_idx:cdot_idx - 2]         # reaction rate
    cdot = buf[cdot_idx:end_idx]        # production rate
    mm = buf[mm_idx:mm_idx+n_species]   # molar mass

    return tbc, k, w, cdot, mm


def read_kinetic_file(inp):

    data = read_file(inp)
    search_for_end = False
    for line in data:
        if line == 'Reactions' or line == 'REACTIONS':
            start = data.index(line)
            search_for_end = True
        if search_for_end:
            if line == 'end' or line == 'END':
                rdata = data[start:]
                end = start + rdata.index(line)

    kin = data[start:end]
    fw_reac = []
    for i in range(len(kin)):
        if kin[i].startswith('!'):
            continue
        if '=>' in kin[i] and not '<=>' in kin[i]:
            fw_reac.append(kin[i])

    return fw_reac


def write_in_matlab_format(n, l, ml, f, conv):

    # matlab can have 75 elements in one line (code formatting)
    l = l.split(' ')
    l1 = l[0] + ' '
    if len(l) == 2:
        l2 = l[1] + ' '
    else:
        l2 = ''
    if n + len(l1) >= 75:
        if conv:
            ml = re.sub('X', '-', ml)
        f.write(ml + '\n')
        ml = l1 + l2
        n = len(ml)
    elif n + len(l1) + len(l2) >= 75:
        if conv:
            ml = re.sub('X', '-', ml)
        f.write(ml + l1 + '\n')
        ml = l2
        n = len(ml)
    else:
        ml += l1 + l2
        n = len(ml)

    return n, ml


def write_numbering(out, mode, data, head, total, SpecX):

    num = 0
    ele = 0
    mline = ''
    with open(out, mode) as output:
        counter = 0
        output.write("\n\n% {0} numbering\n".format(head))
        for line in data:
            counter += 1
            if counter == len(data):
                if total:
                    if SpecX:
                        mline = re.sub('X', '-', mline)
                    output.write(
                        mline + '\n\nn_{0} = {1};\n'.format(head, num))
                else:
                    if SpecX:
                        mline = re.sub('X', '_', mline)
                    output.write(mline)
                break
            line = remove_space(line)
            # same line structure for each line
            if line.startswith(','):
                line = line[1:]
            if line.startswith('integer,parameter::'):
                line = line[19:]
            if not line.endswith('&'):
                line = line + '&'
            num += line.count('=')
            line = re.sub(r",", "; ", line)
            line = re.sub(r"&", ";", line)
            ele, mline = write_in_matlab_format(
                ele, line, mline, output, SpecX)


def write_species_array(out, data, SpecX):

    num = 0
    ele = 0
    mline = ''
    with open(out, 'a+') as output:
        counter = 0
        output.write("\n\n% species array\nspecies = {\n")
        for line in data:
            counter += 1
            line = "'" + line.upper() + "';"
            ele, mline = write_in_matlab_format(
                ele, line, mline, output, SpecX)
            if counter == len(data):
                output.write(mline[:-1] + '\n};')
                break


def write_mm(out, mm):

    with open(out, 'a+') as output:
        output.write('\n\n% allocate memory\nMM = zeros(n_species,1);\n\
                \n% molar masses according to mechanism\n')
        for line in mm:
            output.write(line[6:] + ';\n')


def write_tb_concentration(out, tb, mode):

    with open(out, mode) as output:
        output.write('\n\n\n% third-body concentration\n')
        for line in tb:
            if '&' in line:
                line = line.replace('&', '...\n')
            else:
                line += ';\n'
            if line.startswith('      M(MM'):
                line = line[6:]
            else:
                line = '    ' + line[5:]
            output.write(line)


def write_rate_coefficients(out, k, mode):

    with open(out, mode) as output:
        output.write('\n\n\n% rate coefficents\n')
        for line in k:
            if '&' in line:
                line = line.replace('&', '...\n')
            else:
                line += ';\n'
            if line.startswith('      K'):
                line = line[6:]
            elif line.startswith('      F'):
                line = line[6:]
            else:
                line = '    ' + line[4:]

            if 'mM' in line:
                line = line.replace('mM', 'MM')
            if 'EXP' in line:
                line = line.replace('EXP', 'exp')
            output.write(line)


def write_reaction_rates(out, w, mode):

    with open(out, mode) as output:
        output.write('\n\n\n% reaction rates\n')
        for line in w:
            output.write(line[6:] + ';\n')


def prod_rates_head(rrates, s, idx):

    oline = '\nCDOT' + idx + '(S' + s + ')'
    if len(rrates) != 0:
        oline = oline + ' = ' + rrates[0]
    else:
        # no production reaction for this species!
        oline = oline + ' = 0'
    if len(rrates) > 2:
        return oline + ' + ' + rrates[1] + ' ...\n' + prod_rates_tail(rrates)
    elif len(rrates) == 2:
        return oline + ' + ' + rrates[1] + ';\n'
    else:
        return oline + ';\n'


def prod_rates_tail(rrates):

    rrates_lines = ''
    for i in range(2, len(rrates)):
        if i % 2:
            rrates_lines += rrates[i] + ' ...\n'
        else:
            rrates_lines += '        + ' + rrates[i] + ' + '
        if i == len(rrates) - 1:
            if i % 2:
                return rrates_lines[:-5] + ';\n'
            else:
                return rrates_lines[:-3] + ';\n'


def create_species_production_rate(output, data, ini):

    prod = []
    cons = []
    if len(data) >= 2:
        for line in data:
            if '=' in line:
                split_line = line.split('=')
                if ') = CDOT(' not in line:
                    # start
                    species = find_species(line)
                    prod, cons = sort_line(split_line[1], prod, cons)
                else:
                    # restart
                    prod, cons = sort_line(split_line[1], prod, cons)
            else:
                prod, cons = sort_line(line, prod, cons)
    else:
        species = find_species(data[0])
        split_line = data[0].split('=')
        if remove_space(split_line[1]) == '0.0_DP':
            prod.append('0.0')
            cons.append('0.0')
        else:
            prod, cons = sort_line(split_line[1], prod, cons)

    #if ini:
    #    output.write('\nif strcmp(SPEC, "{0}")'.format(species))
    #else:
    #    output.write('\nelseif strcmp(SPEC, "{0}")'.format(species))

    output.write(prod_rates_head(prod, species, 'p'))
    output.write(prod_rates_head(cons, species, 'd'))
    output.write('\nCDOT(S{0}) = CDOTp(S{0}) - CDOTd(S{0});\n\n'.format(species))


def sort_line(line, production, consumption):

    rrates = remove_space(line)
    rrates = rrates.replace(')', '')
    rrates = line.split('W(')
    for i in range(len(rrates) - 1):
        rate = 'W(' + rrates[i + 1][:rrates[i + 1].index(')') + len(')')]
        if '+' in rrates[i]:
            production.append(
                get_production_rate_factor(rrates[i], '+') + rate)
        elif '-' in rrates[i]:
            consumption.append(
                get_production_rate_factor(rrates[i], '-') + rate)
        else:
            # start
            production.append(
                get_production_rate_factor(rrates[i], ' ') + rate)

    return production, consumption


def get_production_rate_factor(cdot, symbol):

    fac = cdot.split(symbol)
    if len(fac) > 1:
        if '*' in fac[1]:
            return fac[1][1:]
    return ''


def write_production_rates(out, data, mode):

    counter = 0
    species_data = []
    with open(out, mode) as output:
        output.write('\n\n\n% compute production rates')
        output.write('\nCDOTp = zeros(n_species, 1);')
        output.write('\nCDOTd = zeros(n_species, 1);')
        output.write('\nCDOT  = zeros(n_species, 1);\n\n')
        for line in data:
            counter += 1
            if line.startswith('      CDOT(S'):
                if line.count('CDOT(S') != 2:
                    species_data.append(counter)

        for i in range(len(species_data) - 1):
            if i == 0:
                initial = True
            else:
                initial = False
            create_species_production_rate(
                output, data[species_data[i] - 1:species_data[i + 1] - 1], initial)
            if i == len(species_data) - 2:
                create_species_production_rate(
                    output, data[species_data[i + 1] - 1:], initial)


def extract_species(r_num, reaction, line):

    number_of_species = line.count("C(S")
    line = line[line.index("S"):]

    spec = find_species(line)
    reaction = reaction + spec
    line = line[line.index(")"):]

    for i in range(1, number_of_species):
        line = line[line.index("S"):]
        add_spec = find_species(line)
        reaction += "+" + add_spec
        line = line[2:]
    if "M" in line:
        # third-body
        reaction += "(+M)"
    if r_num[-1] == "F":
        reaction += "="

    return reaction


def matlab_format(r):

    rm = []
    for i in r:
        if i[0].isalpha():
            rm.append(i)
        else:
            for num in range(int(i[0])):
                rm.append(i[1:])

    return rm


def rename_species(sl):

    for ele in range(len(sl)):
        if '-' in sl[ele]:
            sl[ele] = sl[ele].replace('-', 'X')

    return sl


def find_products(r, kin):
    # use chemkin mechanism to extract product species
    # elementary reaction
    if '+M' in kin and '+M' not in r:
        # remove +M in kin
        if '(+M)' in kin:
            kin = kin.replace('(+M)', '')
        else:
            # +M in kin
            kin = kin.replace('+M', '')
    r = r.split(' ')
    #r_num = int(r[0][2:-1])
    reac = r[1]
    reac = reac.split('+')

    # clipping Arrhenius parameters
    if kin.count('.') <= 3:
        kin = remove_space(kin)
        kin = kin[:kin.index('.') - 1]
    else:
        # floating point stoichiometic coefficents
        kin = kin.split('=>')
        kin = kin[1]
        n = kin.count('.') - 2
        kin = '.'.join(kin.split('.', n)[:n])
        if kin[-1].isnumeric():  # TODO ...(?)
            kin = kin[:-1]
        kin = remove_space(kin)
        return kin

    kin = kin.split('=>')
    kin_r = kin[0].split('+')
    kin_p = kin[1].split('+')
    kin_r.sort()
    reac.sort()
    # Fortran files: X instead of -
    kin_r = rename_species(kin_r)
    kin_p = rename_species(kin_p)
    kin_r = [x.upper() for x in kin_r]
    kin_p = [x.upper() for x in kin_p]
    reac = [x.upper() for x in reac]
    # e.g. 2CO -> CO+CO
    if len(kin_r) == 1 and kin_r[0].startswith('2'):
        kin_r = [kin_r[0][1:], kin_r[0][1:]]
    if kin_r == reac:
        kin_p = matlab_format(kin_p)  # e.g. 2CO -> CO + CO
        return '+'.join(kin_p)
    else:
        kin_r = matlab_format(kin_r)
        return '+'.join(kin_r)


def write_reactions(out, data, mode, kinetic, n_spec, n_reac):

    fw_reac = 0
    with open(out, mode) as output:
        output.write('\n\n\n% total number of species and rections\nn_species   = {0};\
                \nn_reaction = {1};'.format(n_spec, n_reac))
        output.write('\n\nreactions = [\n')
        for line in data:
            line = remove_space(line)
            # get reaction number
            r_num = line[line.find('(') + 1: line.find(')')]
            if r_num[-1] == 'F' or r_num[-1] == 'B':
                if r_num[-1] == "F":
                    reaction = '"' + r_num + ': '
                    reactants = extract_species(r_num, reaction, line)
                else:
                    products = extract_species(r_num, '', line)
                    reaction = '    ' + reactants + products + '", ...\n'
                    output.write(reaction)
                    backward_reaction = reaction.replace("F:", "B:")
                    bw_rnum = backward_reaction.split(': ')
                    bw = bw_rnum[1].split('=')
                    backward_reaction = bw_rnum[0] + ': ' + \
                        bw[1][:-7] + '=' + bw[0] + '", ...\n'
                    output.write(backward_reaction)
            else:
                # without backward reaction
                reaction = '"' + r_num + ": "
                reactants = extract_species(r_num, reaction, line)
                products = find_products(reactants, kinetic[fw_reac])
                output.write('    ' + reactants + '=' + products + '", ...\n')
                fw_reac += 1
        output.write('];')


def extract_species_list(kin):

    species = []
    start_search = False

    # read data
    data = read_file(kin)

    # species list
    for line in data:
        if start_search:
            if remove_space(line.upper()) == 'END':
                break
            if remove_space(line).startswith('!'):
                continue
            if ' ' in line:
                line = line.replace(' ', '\t')
            s = line.split('\t')
            for i in s:
                if i != '':
                    species.append(i)
        elif remove_space(line.upper()) == 'SPECIES':
            start_search = True

    return species


def write_manually(out, code, mode):

    with open(out, mode) as output:
        if code == 'end':
            output.write('\n\nend')
        elif code == 'ReactionRates':
            output.write(
                'function [W] = Compute_ReactionRates(Y_vec,RHO,TEMP,PRESSURE)\n')
        elif code == 'Cvector':
            output.write('\n\n% compute concentration: C_vec\nC_vec = zeros(n_species,1);\
                    \nfor i = 1:n_species\n    C_vec(i) = Y_vec(i) * RHO / MM(i);\nend')
        elif code == 'W':
            output.write('\n\n% compute reaction rates\
                    \n[W] = Compute_ReactionRatesFromMechanism(TEMP,PRESSURE,C_vec);')
        elif code == 'ReactionRatesFromMechanism':
            output.write('function [W] = Compute_ReactionRatesFromMechanism(TEMP,PRESSURE,C)\
                    \n\n\n% define constants\nRGAS = 8314.34;\nLT = log( TEMP );\
                    \nRT_inv = 1.0 ./ (RGAS * TEMP);\n')
        elif code == 'memory':
            output.write('\n\n% allocate memory\nK = zeros(n_reaction,1);\
                    \nW = zeros(n_reaction,1);\nM = zeros(n_thirdbody,1);')
        elif code == 'ProductionRates':
            output.write(
                'function [CDOTp, CDOTd, CDOT] = Compute_ProductionRate(W)\n\n')
        elif code == 'getreactions':
            output.write(
                'function [n_species,n_reaction,reactions] = Get_Reactions()')
        elif code == 'VolAvData':
            output.write(
                'function [n_species,species,MM] = VolumetricAveragedDataTools()\n\n')


def main(args=None):

    # -----
    # subdir name
    subdir = 'MechanismDependentFunctions'
    # -----

    parser = argparse.ArgumentParser(
        description='Generate mechanism-dependent matlab functions for ROPA/RFA/VolumetricAverageDataFromCIAO.')

    # options
    parser.add_argument('-fh', type=str, required=True, help='mechanismF90.h')
    parser.add_argument('-f', type=str, required=True, help='mechanismF.f90')
    parser.add_argument('-k', type=str, required=True, help='mechanism.mech')
    args = parser.parse_args(args)

    inp_F90_h = args.fh
    inp_F_f90 = args.f
    inp_kin = args.k

    if not os.path.exists(subdir):
        os.makedirs(subdir)

    # matlab filenames
    out_rr = os.path.join(subdir, 'Compute_ReactionRates.m')
    out_rrfm = os.path.join(subdir, 'Compute_ReactionRatesFromMechanism.m')
    out_pr = os.path.join(subdir, 'Compute_ProductionRate.m')
    out_gr = os.path.join(subdir, 'Get_Reactions.m')
    out_vadt = os.path.join(subdir, 'VolumetricAveragedDataTools.m')

    # execute scipt
    s, r, tb, nspec, nreac = read_data_header(inp_F90_h)
    m, k, w, cdot, mm = read_data_f90(inp_F_f90, nspec)

    # write reaction rates file
    write_manually(out_rr, 'ReactionRates', 'w')
    write_numbering(out_rr, 'a+', s, 'species', True, False)
    write_numbering(out_rr, 'a+', r, 'reaction', False, False)
    write_numbering(out_rr, 'a+', tb, 'thirdbody', False, False)
    write_mm(out_rr, mm)
    write_manually(out_rr, 'Cvector', 'a+')
    write_manually(out_rr, 'W', 'a+')
    write_manually(out_rr, 'end', 'a+')

    # write reaction rates from mechanism file
    write_manually(out_rrfm, 'ReactionRatesFromMechanism', 'w')
    write_numbering(out_rrfm, 'a+', s, 'species', False, False)
    write_numbering(out_rrfm, 'a+', r, 'reaction', True, False)
    write_numbering(out_rrfm, 'a+',  tb, 'thirdbody', True, False)
    write_manually(out_rrfm, 'memory', 'a+')
    write_tb_concentration(out_rrfm, m, 'a+')
    write_rate_coefficients(out_rrfm, k, 'a+')
    write_reaction_rates(out_rrfm, w, 'a+')
    write_manually(out_rrfm, 'end', 'a+')

    # write production rates file
    write_manually(out_pr, 'ProductionRates', 'w')
    write_numbering(out_pr, 'a+', s, 'species', True, False)
    write_numbering(out_pr, 'a+', r, 'reaction', False, False)
    write_production_rates(out_pr, cdot, 'a+')
    write_manually(out_pr, 'end', 'a+')

    # write get_reactions
    kinetic_data = read_kinetic_file(inp_kin)
    write_manually(out_gr, 'getreactions', 'w')
    write_reactions(out_gr, w, 'a+', kinetic_data, nspec, nreac)
    write_manually(out_gr, 'end', 'a+')

    # write VolumetricAveragedDataTools.m
    # NOTE: data.out files A1- == mechanism A1X
    # TODO here s from kinetic file
    s_mech = extract_species_list(inp_kin)
    write_manually(out_vadt, 'VolAvData', 'w')
    write_numbering(out_vadt, 'a+', s, 'species', True, False)
    write_mm(out_vadt, mm)
    write_species_array(out_vadt, s_mech, False)
    write_manually(out_vadt, 'end', 'a+')


if __name__ == '__main__':
    main()
