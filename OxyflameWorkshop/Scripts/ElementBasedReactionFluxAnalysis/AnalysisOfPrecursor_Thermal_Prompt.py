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
                        label = nodes[1].strip().split()[1] if len(nodes[1].strip().split()) > 1 else None

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
                    sys.exit('\nLabel has a percentage value which is not in sceintific notation!')
                product *= float(per) / 100 # [%]
            except ValueError:
                continue

    return product


def main():

    file_path = sys.argv[1] 
    
    precursors = ['NH3', 'HCN', 'C5H5N', 'N2', 'N2']
    node_end = 'NO'
    
    glob = []
    thermal = False
    pp_prompt = False
    for node in precursors:
        #print('\nnode: ', node)
        prec = [x for x in precursors if x != node]
        if node == 'N2':
            prec = ['NH3', 'HCN', 'C5H5N']
            if thermal:
                prec.append('NCN') # ignore prompt
                pp_prompt = True
            thermal = True
        print(prec)
        #prec.remove(node)
        #print('prec: ', prec)
        #prec = []
        pathways = find_all_pathways(file_path, node, node_end, prec)

        global_product = 0

        if pathways:
            #print(f"All pathways from {node} to {node_end} found:")
            for pathway in pathways:
                #print(' ==> '.join(pathway))
                product = calculate_pathway_product(pathway)
                #print(f"Product of labels along the pathway: {product}")
                global_product += product
            print('Global-product for {} -> {}: {:.5E}'.format(node, node_end, global_product))
            glob.append(global_product)
            if pp_prompt:
                glob[-2] -= glob[-1]
        else:
            print('No pathway from {} to {} found.'.format(node, node_end))
            glob.append(0)
    
    print('glob: ', glob)
    precursors = ['NH3', 'HCN', 'C5H5N', 'Prompt', 'Thermal']
    tot = sum(glob)
    for i in range(len(precursors)):
        print('Contribution from {:7s} -> {}: {:.3f}%'.format(precursors[i], node_end, float(glob[i])/tot))
    
    print('\n')

if __name__ == '__main__':
    main()


