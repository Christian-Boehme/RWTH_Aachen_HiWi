#!/usr/bin/env python3

import sys
import pandas as pd

# How to run this script?
# python3 ReduceTransportFile.py kinetic-file transport-file True
if len(sys.argv) != 3:
    sys.exit(
        '\npython3 ReduceThermoFile.py kinetic-file transport-file')


def remove_space(string):
    return "".join(string.split())


def read_mechanism(mech):
    with open(mech, "r") as inp:
        return [line.rstrip() for line in inp]


# Get species list
search_end = False
s_in_m = []
basemech = read_mechanism(sys.argv[1])
for line in basemech:
    if line.startswith('!'):
        continue
    if line.upper() == 'SPECIES':
        search_end = True
        continue
    if search_end and line.upper() == 'END':
        break
    if search_end:
        sl = line.split(' ')
        s_in_m.append([x for x in sl if x != ''])

# 2D list -> 1D list
species_in_mech = sum(s_in_m, [])
for i in range(len(species_in_mech)):
    species_in_mech[i] = remove_space(species_in_mech[i])
print('Could detect ' + str(len(species_in_mech)) + ' species.')

# Transport data
trans = read_mechanism(sys.argv[2])
output = sys.argv[2].split('.')

with open(output[0] + '_compact.trans', 'w') as out:
    out.write('!Transport data for: ' + sys.argv[1])
    for line in trans:
        if line.startswith('!'):
            continue
        spec = line.split(' ')[0]
        for i in species_in_mech:
            if spec == i:
                out.write('\n' + line)
                # no duplicates
                species_in_mech.remove(i)
                break
