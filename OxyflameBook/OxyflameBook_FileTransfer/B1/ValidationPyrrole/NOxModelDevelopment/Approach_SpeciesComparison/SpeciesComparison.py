#!usr/bin/env python3

import sys


def read(fname):
    with open(fname, 'r') as inp:
        return [line.rstrip() for line in inp]


spec1 = read(sys.argv[1])
spec1 = spec1[1:]
spec2 = read(sys.argv[2])
spec2 = spec2[1:]
diff = list(set(spec1) - set(spec2))
print(diff)
print(len(diff))

print('Duplicated: ', list(set(spec1) - set(diff)))
