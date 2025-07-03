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


def python_format(line):

    line = line.replace('(', '[')
    line = line.replace(')', ']')
    line = '    ' + line

    return line


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
    k_idx = -1
    w_idx = -1
    codt_idx = -1
    mm_idx = -1
    dcoeff = -1
    found = False
    for i in range(len(buf)):
        # third-body concentration
        if 'RT_inv = 1.0_DP' in buf[i] and tbc_idx == 0:
            tbc_idx = i + 3
        # rate coefficients
        elif buf[i - 2] == buf[i - 1] == '' and buf[i].startswith('      K(R'):
            if not found:
                k_idx = i
        # reaction rates
        elif buf[i - 1] == '' and buf[i].startswith('      W(R'):
            if not found:
                w_idx = i
        # production rates
        elif buf[i - 2] == buf[i - 1] == '' and buf[i].startswith('      CDOT(S'):
            if not found:
                cdot_idx = i
        elif '      END' == buf[i]:
            if not found:
                end_idx = i
                found = True
        elif 'RT_2_inv = 1.0_DP' in buf[i]:
            mm_idx = i + 1
        elif buf[i] == "      SUBROUTINE GETDCOEFF( DCOEFF )":
            dcoeff = i + 11
            break
    
    if k_idx == -1 or w_idx == -1 or cdot_idx == -1 or mm_idx == -1 or dcoeff == -1:
        sys.exit('\nCould not read data! F.f90 file correct generated?')

    tbc = buf[tbc_idx:k_idx - 2]        # third-body concentration
    k = buf[k_idx:w_idx - 1]            # rate coefficient
    w = buf[w_idx:cdot_idx - 2]         # reaction rate
    cdot = buf[cdot_idx:end_idx]        # production rate
    mm = buf[mm_idx:mm_idx+n_species]   # molar mass
    dc = buf[dcoeff:dcoeff+2*((n_species)**2)]    # diffusion coefficient

    return tbc, k, w, cdot, mm, dc


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


def read_thermo_file(inp):
    with open(inp, 'r') as input:
        return [line.rstrip() for line in input]


def write_in_python_format(n, l, ml, f):

    l = l.split(' ')
    l1 = l[0] + ' '
    if len(l) == 2:
        l2 = l[1] + ' '
    else:
        l2 = ''
    if n + len(l1) >= 75:
        f.write(ml + '\n')
        ml = l1 + l2
        n = len(ml)
    elif n + len(l1) + len(l2) >= 75:
        f.write(ml + l1 + '\n')
        ml = l2
        n = len(ml)
    else:
        ml += l1 + l2
        n = len(ml)

    return n, ml


def python_index(l):

    splitted = l.split('=')
    ssplit = splitted[1].split(';')
    idx1 = str(int(ssplit[0]) - 1)
    python_line = splitted[0] + '=' + idx1 + ';'
    if len(splitted) == 3:
        ssplit2 = splitted[2].split(';')
        python_line += ssplit[1] + '=' + str(int(ssplit2[0]) - 1) + ';'

    return python_line


def write_numbering(out, mode, data, head, total):

    num = 0
    ele = 0
    mline = ''
    with open(out, mode) as output:
        counter = 0
        output.write("\n\n# {0} numbering\n".format(head))
        for line in data:
            counter += 1
            if counter == len(data):
                if total:
                    output.write(
                        mline + '\n\n# total number of {0}\nn_{0} = {1}\n'.format(head, num))
                else:
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
            line = python_index(line)
            ele, mline = write_in_python_format(ele, line, mline, output)


def write_species_array(out, data):

    num = 0
    ele = 0
    mline = ''
    with open(out, 'a+') as output:
        counter = 0
        output.write("\n\ndef Species():\n\n    species = [\n")
        for line in data:
            counter += 1
            if counter == len(data):
                output.write(mline + '    ]\n\n    return species')
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
            line = re.sub(r"&", "',", line)
            # remove S
            line = "'" + line[1:]
            line = re.sub(r"; S", "', '", line)
            line = re.sub(r"=\d*", "", line)
            output.write('        ' + line + '\n')


def write_mm(out, mm):

    with open(out, 'a+') as output:
        output.write('\n\n\ndef MolecularWeight():\n\n    # allocate memory\n    MM = [0] * n_species\n\
                \n    # molar masses according to mechanism\n')
        for line in mm:
            output.write(python_format(line[6:]) + '\n')
        output.write('\n    return MM')


def write_tb_concentration(out, tb, mode):

    # write function header
    with open(out, mode) as output:
        output.write('\n\n\ndef ReactionRates(TEMP, PRESSURE, C):\n\n    # allocate memory\n    M = [0] * n_thirdbody\
            \n    K = [0] * n_reaction\n    W = [0] * n_reaction\n\n    # define constants\n    RGAS = 8314.34\
            \n    LT = np.log(TEMP)\n    RT_inv = 1.0 / (RGAS * TEMP)')

    with open(out, mode) as output:
        output.write('\n\n\n    # third-body concentration\n')
        for line in tb:
            if '&' in line:
                line = line.replace('&', '\\\n')
            else:
                line += '\n'
            if line.startswith('      M(MM'):
                line = line[6:]
            else:
                line = '    ' + line[5:]
            line = python_format(line)
            output.write(line)


def write_rate_coefficients(out, k, mode):

    with open(out, mode) as output:
        output.write('\n\n    # rate coefficents\n')
        for line in k:
            if '&' in line:
                line = line.replace('&', '\\\n')
            else:
                line += '\n'
            if line.startswith('      K'):
                line = line[6:]
            elif line.startswith('      F'):
                line = line[6:]
            else:
                line = '    ' + line[4:]
            # fortran -> python
            if 'mM' in line:
                line = line.replace('mM', 'MM')
            if 'EXP' in line:
                line = line.replace('EXP', 'exp')
            if 'exp' in line:
                line = line.replace('exp', 'np.exp')
            if 'D+' in line:
                line = line.replace('D+', 'E+')
            if 'D-' in line:
                line = line.replace('D-', 'E-')
            # python format
            if '=' in line:
                lsplit = line.split('=')
                line = python_format(lsplit[0])
                line = line + '=' + lsplit[1]
            if 'M(MM' in line:
                line = line.replace('M(MM', 'M[MM')
                line = line.replace(') )', '] )')
            if 'GETLINDRATECOEFF' in line:
                line = line.replace('GETLINDRATECOEFF', 'lh.GETLINDRATECOEFF')
            output.write(line)


def write_reaction_rates(out, w, mode):

    with open(out, mode) as output:
        output.write('\n\n    # reaction rates\n')
        for line in w:
            line = python_format(line)
            output.write(line[6:] + '\n')
        output.write('\n    return W')


def prod_rates_head(rrates, s, idx):

    oline = '\n    CDOT' + idx + '_' + s + ' = ' + rrates[0]
    if len(rrates) > 2:
        return oline + ' + ' + rrates[1] + ' \\\n' + prod_rates_tail(rrates)
    elif len(rrates) == 2:
        return oline + ' + ' + rrates[1] + '\n'
    else:
        return oline + '\n'


def prod_rates_tail(rrates):

    rrates_lines = ''
    for i in range(2, len(rrates)):
        if i % 2:
            rrates_lines += rrates[i] + ' \\\n'
        else:
            rrates_lines += '        + ' + rrates[i] + ' + '
        if i == len(rrates) - 1:
            if i % 2:
                return rrates_lines[:-3] + '\n'
            else:
                return rrates_lines[:-3] + '\n'


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
    # if ini:
    #    output.write('\nif strcmp(SPEC, "{0}")'.format(species))
    # else:
    #    output.write('\nelseif strcmp(SPEC, "{0}")'.format(species))
    if len(prod) != 0:
        output.write(python_format(prod_rates_head(prod, species, 'p')))
    else:
        output.write('\n    CDOTp_' + species + ' = 0\n')
    if len(cons) != 0:
        output.write(python_format(prod_rates_head(cons, species, 'd')))
    else:
        output.write('\n    CDOTd_' + species + ' = 0\n')

    output.write('\n    CDOTp[S{0}] = CDOTp_{0}'.format(species))
    output.write('\n    CDOTd[S{0}] = -CDOTd_{0}'.format(species))
    output.write('\n    CDOT[S{0}] = CDOTp_{0} - CDOTd_{0}\n'.format(species))


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

    fac = remove_space(cdot).split(symbol)
    if len(fac) >= 1:
        for i in range(len(fac)):
            if '*' in fac[i]:
                return fac[i]
    return ''


def write_production_rates(out, data, mode):

    # write function name
    with open(out, mode) as output:
        output.write(
            '\n\n\ndef ProductionRates(W):\n\n    # allocate memory\n    CDOTp = [0] * n_species\n    CDOTd = [0] * n_species\n    CDOT = [0] * n_species')

    counter = 0
    species_data = []
    with open(out, mode) as output:
        output.write('\n\n    # compute production rates')
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

        output.write('\n\n    return CDOTp, CDOTd, CDOT')


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
        if kin[-1].isnumeric():  # TODO (?)
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
        output.write('\n\n\ndef Reactions():')
        output.write('\n\n    reactions = [\n')
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
                    reaction = '        ' + reactants + products + '",\n'
                    output.write(reaction)
                    backward_reaction = reaction.replace("F:", "B:")
                    bw_rnum = backward_reaction.split(': ')
                    bw = bw_rnum[1].split('=')
                    backward_reaction = bw_rnum[0] + ': ' + \
                        bw[1][:-3] + '=' + bw[0] + '",\n'
                    output.write(backward_reaction)
            else:
                # without backward reaction
                reaction = '"' + r_num + ": "
                reactants = extract_species(r_num, reaction, line)
                products = find_products(reactants, kinetic[fw_reac])
                output.write('        ' + reactants + '=' + products + '",\n')
                fw_reac += 1
        # net reactions
        output.write('    ]\n\n    # net reactions: forward - backward reaction\n    net_reactions = []\
                \n    for i in reactions:\n        if "B: " not in i:\
                \n            net_reactions.append(re.sub("F: ", ": ", i))\n\n    return reactions, net_reactions')


def get_species_list(inp):
    species = []
    for line in inp:
        if not line.startswith('!') and (line.endswith('1') or '1!' in remove_space(line)):
            species.append(find_species_thermo(line))
    return species


def extract_element(x, ele):

    comp_EleFree = x.split(ele)
    if comp_EleFree != '':
        comp = comp_EleFree[0]
    else:
        comp = ''
    m = comp_EleFree[1]
    return comp, int(m)


def find_species_thermo(line):
    return line[: line.find(' ')]


def alpha_position(s):
    for i, c in enumerate(s):
        if c.isalpha():
            return i


def write_composition(output, data, mod):

    species_list = get_species_list(data)
    # allocate memory for elements
    N = []
    O = []
    H = []
    C = []

    species_ = 0
    exit = False
    with open(output, mod) as out:
        for lines in data:
            if not lines.startswith('!') and (lines.endswith('1') or '1!' in remove_space(lines)):
                species = species_list[species_]
                line = remove_space(lines)
                if '1!' in line:
                    # delete comment at the end of the line
                    comm = line.index('!')
                    line = line[:comm]
                sline = line[len(species_list[species_]):]
                # remove temperature ranges from line
                if 'G' in sline:
                    sline = sline.split('G')
                    sline = sline[0]
                    if '0' == sline[-1]:
                        zeros = 0
                        for zero in sline[::-1]:
                            if zero == '0':
                                zeros += 1
                            else:
                                break
                        if zeros == 1:
                            if sline[-2].isnumeric():
                                num = int(sline[-2:])
                                lines_ = lines[len(species_list[species_]):]
                                if '!' in lines_:
                                    lines_ = lines_[:lines_.index('!')]
                                n = lines_.count('.') - 2
                                lines_ = '.'.join(lines_.split('.', n)[:n])
                                lines_ = lines_[:-3]
                                if not str(num) in lines_:
                                    sline = sline[:-1]
                        if zeros != 1:
                            sline = sline[:len(sline) - zeros]
                            if sline[-1].isalpha():
                                sline = sline[:-1]
                else:
                    n = sline.count('.') - 2
                    sline = '.'.join(sline.split('.', n)[:n])
                    sline = sline[:-3]

                ele_pos = alpha_position(sline)
                sline = sline[ele_pos:]
                comp = sline

                rev_comp = comp[::-1]
                elements = ['C', 'H', 'O', 'N']
                idx = 0
                for ele in rev_comp:
                    if ele.isalpha() and ele not in elements:
                        idx = rev_comp.index(ele)
                        break

                if idx != 0:
                    rev_comp = rev_comp[:idx]
                    comp = rev_comp[::-1]

                # reset number of atoms
                Natoms = 0
                Oatoms = 0
                Hatoms = 0
                Catoms = 0
                # extract elements
                elements = []
                for j in comp:
                    if j.isalpha():
                        elements.append(j)
                elements = list(reversed(elements))
                for ele in elements:
                    if ele == 'N':
                        comp, Natoms = extract_element(comp, 'N')
                    if ele == 'H':
                        comp, Hatoms = extract_element(comp, 'H')
                    if ele == 'O':
                        comp, Oatoms = extract_element(comp, 'O')
                    if ele == 'C':
                        comp, Catoms = extract_element(comp, 'C')
                N.append(Natoms)
                O.append(Oatoms)
                H.append(Hatoms)
                C.append(Catoms)
                species_ += 1
        # output as list
        #out.write("\n\n\ndef ElementalComposition(species):\n\n    # supported elements\
        #        \n    elements = ['H', 'C', 'N', 'O']\n\n    H = {0}\n    C = {1}\
        #        \n    N = {2}\n    O = {3}".format(H, C, N, O))
        #out.write('\n\n    # create df\n    comp = pd.DataFrame(columns=species)\n\
        #        \n    comp.loc[len(comp)] = H\n    comp.loc[len(comp)] = C\
        #        \n    comp.loc[len(comp)] = N\n    comp.loc[len(comp)] = O\
        #        \n\n    # rename index\n    for i in range(len(elements)):\
        #        \n        comp = comp.rename(index={i: str(elements[i])})\n\n    return comp')
        # output as dictionary
        out.write("\n\n\ndef ElementalComposition(species):\n\n    # supported elements and structure: dict = {'species': [H, C, N, O]}")
        out.write("\n\n    elements = ['H', 'C', 'N', 'O']\n\n    # dictionary\n    ecomp = {\n")
        for i in range(species_):
            out.write("            '{0}': [{1}, {2}, {3}, {4}],\n".format(species_list[i], H[i], C[i], N[i], O[i]))
        out.write("            }\n\n    # convert dict to df\n    comp = pd.DataFrame.from_dict(ecomp)")
        out.write('\n\n    # rename index\n    for i in range(len(elements)):\
                \n        comp = comp.rename(index={i: str(elements[i])})\n\n    return comp\n')


def diff_coeff_to_python_file(dcoeff_s, out, spec, species):

    Dcoeff = [float(x) for x in dcoeff_s]
    out.write("    DCOEFF_{} = [".format(spec))
    Dcoeff_format = "\n            "
    for i in Dcoeff:
        if len(Dcoeff_format) >= 60:
            Dcoeff_format += "\n"
            out.write(Dcoeff_format)
            Dcoeff_format = "            "
        Dcoeff_format += "{:.8E}, ".format(i)
    Dcoeff_format = Dcoeff_format[:-2] + '\n            ]\n'
    out.write(Dcoeff_format)
    #out.write("    zip_.append(DCOEFF_{})\n\n".format(spec))
    #out.write("    zip_.append('DCOEFF_{}')\n\n".format(spec))
    spec = species[0]

    return spec


def write_diffusion_coeff(outfile, data, mode):
    
    #
    #with open(outfile, mode) as o:
    #    o.write("\n\ndef DiffusionCoefficients(species):\n\n    # allocate memory\n    df = pd.DataFrame(0, columns=species, index=np.arange(0, len(species))\
    #            \n\n    # rename index\n    df.index = species\n\n    #\n")
    #    for line in data:
    #        if line == '':
    #            continue
    #        l = line.split('=')
    #        idx = l[0].split('(')[1][:-1]
    #        idx = idx.split(',')
    #        ridx = idx[0]
    #        cidx = idx[1][:-1]
    #        val = l[1]
    #        o.write("    df.iloc[{0}, {1}] = {2}\n".format(ridx, cidx, val)) # TODO efficient /dictionary ...
    #    o.write("\n    return df\n")

    #
    with open(outfile, mode) as out:
        out.write("\n\ndef DiffusionCoefficients(species):\n\n    # alocate memory\n    zip_ = []\n\n    # Diffusion coefficients [M2/S]\n")
        dcoeff_s = []
        spec = re.search(r'DCOEFF\((.*?),(.*?)\)=', remove_space(data[0])).groups()[0]
        species_list = [spec]
        for line in data:
            if line == '':
                continue
            sline = remove_space(line).split('=')
            species = re.search(r'DCOEFF\((.*?),(.*?)\)', sline[0]).groups()
            if species == '':
                sys.exit('\nFailed to detect species - diffusion coefficients.')
            if species[0] != spec:
                spec = diff_coeff_to_python_file(dcoeff_s, out, spec, species)
                dcoeff_s = []
                species_list.append(spec)
            dcoeff_s.append(sline[1])
        if dcoeff_s != []:
            spec = diff_coeff_to_python_file(dcoeff_s, out, spec, species)
        #
        out.write("\n    # create df\n    df = pd.DataFrame({\n")
        for i in species_list:
            if i == species_list[-1]:
                out.write("       '{0}': DCOEFF_{1}\n".format(i[1:], i))
            else:
                out.write("       '{0}': DCOEFF_{1},\n".format(i[1:], i))
        out.write("        }, index=species)\n\n    return df\n")

    return


def write_manually(out, code, mode):

    with open(out, mode) as output:
        if code == 'header':
            output.write(
                '#!/usr/bin/env python3\n\nimport re\nimport numpy as np\nimport pandas as pd\nfrom . import LindemannHinshelwood as lh\n')


def main(args=None):

    parser = argparse.ArgumentParser(
        description='Generates a mechanism-dependent file which contains functions to compute the kinetics required for the ROPA or RPA.')

    # options
    parser.add_argument('-fh', type=str, required=True, help='mechanismF90.h')
    parser.add_argument('-f', type=str, required=True, help='mechanismF.f90')
    parser.add_argument('-k', type=str, required=True, help='mech file')
    parser.add_argument('-t', type=str, required=True, help='chthermo file')
    args = parser.parse_args(args)

    # input files
    inp_F90_h = args.fh
    inp_F_f90 = args.f
    inp_kin = args.k
    inp_thermo = args.t

    # output filename
    output = os.path.join('MechanismDependentFunctions.py')

    # read input files
    s, r, tb, nspec, nreac = read_data_header(inp_F90_h)
    m, k, w, cdot, mm, dcoeff = read_data_f90(inp_F_f90, nspec)
    kinetic_data = read_kinetic_file(inp_kin)

    # generate functions
    write_manually(output, 'header', 'w')
    write_numbering(output, 'a+', s, 'species', True)
    write_numbering(output, 'a+', r, 'reaction', True)
    write_numbering(output, 'a+',  tb, 'thirdbody', True)
    write_species_array(output, s)
    write_reactions(output, w, 'a+', kinetic_data, nspec, nreac)
    write_mm(output, mm)
    write_tb_concentration(output, m, 'a+')
    write_rate_coefficients(output, k, 'a+')
    write_reaction_rates(output, w, 'a+')
    write_production_rates(output, cdot, 'a+')
    thermo_data = read_thermo_file(inp_thermo)
    write_composition(output, thermo_data, 'a+')
    #write_diffusion_coeff(output, dcoeff, 'a+')

if __name__ == '__main__':
    main()
