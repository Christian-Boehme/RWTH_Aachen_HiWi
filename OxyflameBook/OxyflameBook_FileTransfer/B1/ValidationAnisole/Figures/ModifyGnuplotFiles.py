#!/usr/bin/env python3

import sys
import argparse


def file_modification(filename, oldStr, newStr):

    data = read_file(filename)

    mod_data = []
    for line in data:
        if oldStr in line:
            line = line.replace(oldStr, newStr)
        mod_data.append(line)

    write_file(filename, mod_data)


def read_file(filename):

    with open(filename, 'r') as in_file:
        data = in_file.readlines()

    return data


def write_file(filename, data):

    with open(filename, 'w') as out_file:
        for line in data:
            out_file.write(line)


def main(args=None):

    parser = argparse.ArgumentParser(description='')

    # parser option
    parser.add_argument('-f', type=str, required=False, help='Filename')
    parser.add_argument('-l', type=str, nargs='+',
                        required=False, help='list of filenames')
    parser.add_argument('-old', type=str, required=True,
                        help='String to replace')
    parser.add_argument('-new', type=str, required=True, help='New string')

    # parser default settings
    parser.set_defaults(f='')
    parser.set_defaults(l='')

    # parse
    args = parser.parse_args(args)

    if args.f != '':
        # modify single file
        file_modification(args.f, args.old, args.new)

    if args.l != '':
        # modify multiple files
        for f in args.l:
            file_modification(f, args.old, args.new)

    return


if __name__ == '__main__':
    main()
