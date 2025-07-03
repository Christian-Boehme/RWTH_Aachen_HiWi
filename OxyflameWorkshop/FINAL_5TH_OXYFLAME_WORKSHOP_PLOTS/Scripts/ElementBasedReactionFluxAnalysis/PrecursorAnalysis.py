#!/usr/bin/env python3

import sys
import argparse


def find_paths(fpath, tnode, snode, prec, path, visited, pathways):

    visited.add(tnode)
    path.append(tnode)

    if tnode == snode:
        pathways.append(path.copy())
    else:
        with open(fpath, 'r') as file:
            for line in file:
                if '->' in line:
                    line = line.replace('\t', '')
                    nodes = line.strip().split('->')
                    start_node = nodes[0].strip()
                    end_node = nodes[1].strip().split()[0]
                    if end_node in prec:
                        continue
                    label = nodes[1].strip().split()[1] if len(
                        nodes[1].strip().split()) > 1 else None
                    if start_node == tnode and end_node not in visited:
                        new_path = path.copy()
                        new_path.append(f"{tnode}->{end_node}")

                        if label:
                            new_path.append(label)

                        find_paths(fpath, end_node, snode, prec,
                                   new_path, visited, pathways)

    path.pop()
    visited.remove(tnode)

    return pathways


def find_all_pathways(file_path, target_node, start_node, prec):

    pathways = find_paths(file_path, target_node,
                          start_node, prec, [], set(), [])

    return pathways


def calculate_pathway_product(pathway):

    product = 1

    for item in pathway:
        if 'label=' in item:
            try:
                per = item.split('=')[1][1:-2]
                if 'e' not in per:
                    sys.exit(
                        '\nLabel has a percentage value which is not in scientific notation!\nChange line 101 and 103 in core/RPA.py')
                product *= float(per) / 100  # [%]
            except ValueError:
                continue

    return product


def main(args=None):

    # parser: description
    parser = argparse.ArgumentParser(
        description='Calculates the product of all edges (weight) from initial nodes to a end node,vto identify the dominant formation/desctruction pathways.')

    # parser: options
    parser.add_argument('-file', type=str, required=True,
                        help='Dot input file containing all pathways.')
    parser.add_argument('-start', type=str, required=True,
                        help='Start node(s), i.e., -start:A,B,C')
    parser.add_argument('-end', type=str, required=True, help='End node.')

    # parse
    args = parser.parse_args(args)

    file_path = args.file
    precursors = (args.start).split(',')
    node_end = args.end

    glob = []
    for node in precursors:
        global_product = 0
        prec = [x for x in precursors if x != node]
        pathways = find_all_pathways(file_path, node, node_end, prec)
        if pathways:
            for pathway in pathways:
                product = calculate_pathway_product(pathway)
                global_product += product
            print('Global-product for {:10s} -> {:10s}: {:.5E}'.format(node,
                  node_end, global_product))
            glob.append(global_product)
        else:
            print('No pathway from {:10s} to {:10s} found.'.format(
                node, node_end))
            glob.append(0)

    tot = sum(glob)
    for i in range(len(precursors)):
        print('Contribution from {:7s} -> {}: {:.5f}%'.format(
            precursors[i], node_end, float(glob[i])/tot))


if __name__ == '__main__':
    main()
