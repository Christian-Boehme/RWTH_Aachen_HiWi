#!/usr/bin/env python3

import sys


def find_all_pathways(file_path, target_node, starting_node, prec):

    def find_paths(current_node, path, visited, prec):
        visited.add(current_node)
        path.append(current_node)

        if current_node == starting_node:
            pathways.append(path.copy())
        else:
            with open(file_path, 'r') as file:
                for line in file:
                    if '->' in line:
                        line = line.replace('\t', '')
                        nodes = line.strip().split('->')
                        start_node = nodes[0].strip()
                        end_node = nodes[1].strip().split()[0]
                        if end_node in prec:
                            #print('NO: ', end_node)
                            continue
                        label = nodes[1].strip().split()[1] if len(
                            nodes[1].strip().split()) > 1 else None

                        if start_node == current_node and end_node not in visited:
                            new_path = path.copy()
                            new_path.append(f"{current_node}->{end_node}")

                            if label:
                                new_path.append(label)

                            find_paths(end_node, new_path, visited, prec)

        path.pop()
        visited.remove(current_node)

    pathways = []
    find_paths(target_node, [], set(), prec)

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


def main():

    file_path = sys.argv[1]

    # Inputs
    precursors = ['NH3', 'HCN', 'C5H5N', 'N2']
    node_end = 'NO'

    glob = []
    thermal = False
    pp_prompt = False
    for node in precursors:
        prec = [x for x in precursors if x != node]
        pathways = find_all_pathways(file_path, node, node_end, prec)

        global_product = 0

        if pathways:
            for pathway in pathways:
                product = calculate_pathway_product(pathway)
                global_product += product
            print('Global-product for {} -> {}: {:.5E}'.format(node,
                  node_end, global_product))
            glob.append(global_product)
        else:
            print('No pathway from {} to {} found.'.format(node, node_end))
            glob.append(0)

    tot = sum(glob)
    for i in range(len(precursors)):
        print('Contribution from {:7s} -> {}: {:.3f}%'.format(
            precursors[i], node_end, float(glob[i])/tot))


if __name__ == '__main__':
    main()
