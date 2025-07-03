#!usr/bin/env python3

import sys


inp = sys.argv[1]

def rms(string):
    return "".join(string.split())

with open(inp, 'r') as input:
    data = [line.rstrip() for line in input]

found = False
for i in range(len(data)):
    if found:
        if rms(data[i]).upper() == 'END':
            print(data[i])
            break
        if rms(data[i]).startswith('!'):
            continue
        if not '=' in data[i]:
            continue
        line = rms(data[i].split(' ')[0])
        for j in range(i + 1, len(data)):
            if rms(data[j].split(' ')[0]) == line:
                print('\nReaction:     ', data[i])
                print('DUPLICATED:   ', data[j])
                if data[j] != data[i]:
                    print('DIFFERENT RATES!')
                    if data[j+1] == data[i+1] == 'DUPLICATE':
                        print('DUPLICATE KEYWORD IS PRESENT')
                else:
                    print('PROBLEM!\n')
        #print(data[i])
    if rms(data[i]).upper() == 'REACTIONS':
        print(data[i])
        found = True

