#!usr/bin/env python3

import os
import sys
import graphviz
import numpy as np
import pandas as pd
import networkx as nx
from . import Utils as ut
from . import MechanismDependentFunctions as mdf


def remove_space(string):
    return "".join(string.split())


def dominant_reactions(h, t, W):

    r, netreactions = mdf.Reactions()

    W.columns = netreactions

    reactions = []
    for j in netreactions:
        r, p, cr, cp = ut.DetermineReactantAndProductSpecies(j, W)
        if t in r and h in p:
            reactions.append(j)

    if len(reactions) > 1:
        rrate = []
        reactant = ''
        for j in reactions:
            r, p, cr, cp = ut.DetermineReactantAndProductSpecies(j, W)
            if t in r:
                if len([x for x in r if x != t]) == 0:
                    # decomposition reaction
                    continue
                if reactant == '':
                    reactant = ''.join([x for x in r if x != t])
                else:
                    reactant = reactant + ',' + ','.join([x for x in r if x != t])
        return reactant

    if len(reactions) == 0:
        sys.exit('Something went wrong. Could not find reaction which produces ' +
                 str(h) + ' and consumes ' + str(t))


def IgnoreEndNodes(norm_df, species):

    # check if each pathway reaches target species (= remove all "end" nodes)
    cleaned_up = True
    number_of_zeros = 0
    while cleaned_up:
        zeros = []
        for row in range(norm_df.shape[0]):
            zeros.append((norm_df.iloc[row] != 0).sum())
        for row in range(norm_df.shape[0]):
            if zeros[row] == 0:
                norm_df.iloc[row].values[:] = 0
                norm_df[species[row]].values[:] = 0
        if zeros.count(0) == number_of_zeros:
            cleaned_up = False
        number_of_zeros = zeros.count(0)

    return norm_df


def detect_cycles(graph):
    try:
        cycles = list(nx.find_cycle(graph, orientation='original'))
        if cycles:
            print("Cycles detected:", cycles)
        else:
            print("No cycles detected.")
    except nx.NetworkXNoCycle:
        print("No cycles detected.")


def edges(tool, dfn, df, tail, lim, species, graph, open_nodes, closed_nodes, font, fsize, q, DTness):

    # open_nodes:   species is produced -> consumption must be considered
    # closed nodes: consumption of species is already considered

    # structure df
    # rows index:   species is consumed
    # column index: species is produced from this (row) species

    sl = list(dfn.columns)
    dfn = dfn.iloc[sl.index(tail)]
    df = df.iloc[sl.index(tail)]
    closed_nodes.append(tail)

    for i in range(1, dfn.shape[0]):
        if dfn.iat[i] <= lim:
            continue

        if DTness:
            size = int(dfn.iat[i] / 10)
            pw = str(size + 3)
        else:
            pw = str(3)
        per = dfn.iat[i]
        head = str(species[i])

        # label
        reactant = ''
        #reactant = dominant_reactions(head, tail, q) # adds reaction partner to the label
        if reactant == '':
            # decomposition reaction
            label = '{:.1f}%'.format(per)
        else:
            label = '+{}; {:.1f}%'.format(reactant, per)

        if head not in open_nodes and head not in closed_nodes:
            open_nodes.append(head)

        if tool == 'NETWORKX':
            graph.add_edge(tail, head, weight=str(dfn.iat[i]))
        elif tool == 'DOT':
            graph.edge(tail, head, label=label, penwidth=pw, fontcolor="black", fontname=font, fontsize=str(
                fsize))

    return graph, open_nodes, closed_nodes


def CreateGraphic(tool, target_spec, norm, df, ini, lim, spec, graph, f, fs, q, DTness): # TODO lim is senseless

    graph, s_to_p, pspec = edges(
        tool, norm, df, ini, lim, spec, graph, [], [], f, fs, q, DTness)
    if len(target_spec) != 0:
        s_to_p = list(set(s_to_p + target_spec))

    while len(s_to_p) != 0:
        graph, s_to_p, pspec = edges(
            tool, norm, df, s_to_p[0], lim, spec, graph, s_to_p, pspec, f, fs, q, DTness)
        del s_to_p[0]

    return graph, pspec


def GenerateGraphic(df, target_spec, initial_species, limit, font, fontsize, cnode, q, NormOutGoing, DThickness, single, odir):

    # allocate memory
    spec_to_plot = []

    # support multiple initial species
    if ',' in initial_species:
        spec_to_plot = list(initial_species.split(','))
    initial_species = target_spec

    # remove space
    df.columns = list([remove_space(col) for col in df.columns])

    # create graphic
    graph = nx.DiGraph()
    dot = graphviz.Digraph()

    # get species
    species = list(df.columns)

    # create normalization df
    df_n = df.copy(deep=True)
    df_n = ut.FluxNormalization_Column(df_n)

    # create graph: consider all fluxes
    graph, graph_nodes = CreateGraphic(
        'NETWORKX', spec_to_plot, df_n, df, initial_species, 0, species, graph, font, fontsize, q, DThickness)
    
    # TODO
    # double check everything nu, ...

    # Flux normalization
    if NormOutGoing is False:
        # normalize by ingoing flux
        df_norm = df.copy(deep=True)
        nodes = graph.nodes()
        for i in nodes:
            tot_weight = 0
            for e in graph.in_edges(i):
                tot_weight += float(graph.get_edge_data(e[0], e[1])['weight'])
            # renormalization
            for e in graph.in_edges(i):
                df_norm.iat[species.index(e[0]), species.index(e[1])] = float(
                    graph.get_edge_data(e[0], e[1])['weight']) / tot_weight * 100  # [%]

        # consider limit
        df_norm[df_norm < limit] = 0
        df_n = ut.FluxNormalization_Column(df_norm)
        df_norm[df_norm < limit] = 0 # muss vorher ABER NUR EINMAL!!!
        print('HERE')
        detect_cycles(graph)

        #
        df_norm = IgnoreEndNodes(df_norm, species)
        

    else:
        # normalize by outgoing flux
        df_norm = df.copy(deep=True)
        df_norm = ut.FluxNormalization(df_norm, False, 'Output', 'RPA')  # in utils wat unnötig?
        
        #
        df_norm = IgnoreEndNodes(df_norm, species)

        #
        df_norm[df_norm < limit] = 0

    # create final figure using dot
    dot, dot_nodes = CreateGraphic('DOT', spec_to_plot, df_norm, df, initial_species,
                                   0, species, dot, font, fontsize, q, DThickness)
    #detect_cycles(dot)

    # change font of nodes:
    for i in dot_nodes:
        dot.node(i, fontname=str(font), fontsize=str(fontsize))

    # change color of nodes:
    for i in cnode.keys():
        dot.node(i, style="filled", color=cnode[i], fillcolor=cnode[i])

    # save generated code
    dot.render(filename=odir + 'ElementReactionFluxGraph.dot')
    
    # remove pdf file
    if os.path.exists(odir + 'ElementReactionFluxGraph.dot.pdf'):
        os.remove(odir + 'ElementReactionFluxGraph.dot.pdf')

    if single:
        # consider only target species edges
        with open(odir + "ElementReactionFluxGraph.dot", "r") as inp:
            inp = [line.rstrip() for line in inp]

        with open(odir + "ElementReactionFluxGraph.dot", "w") as out:
            head = True
            relevant_nodes = [target_spec]
            for line in inp:
                if '->' in line:
                    head = False
                    line = line.replace('label="', 'label=" ')
                    if NormOutGoing:
                        if '\t{0} ->'.format(target_spec) in line:
                            out.write(line + '\n')
                            nline = remove_space(line.split('->')[1])
                            relevant_nodes.append(nline.split('[')[0])
                    else:
                        if '->{0}['.format(target_spec) in remove_space(line):
                            out.write(line + '\n')
                            relevant_nodes.append(remove_space(line.split('->')[0][1:]))
                if head:
                    out.write(line + '\n')
                # node features
                if '->' not in line and head is False:
                    for i in relevant_nodes:
                        if remove_space(line).startswith('{0}['.format(i)):
                            out.write(line + '\n')
            out.write(line)
    else:
        # add rank dependence to plot (species from flag -species are on top (=source))
        with open(odir + "ElementReactionFluxGraph.dot", "r") as inp:
            inp = [line.rstrip() for line in inp]

        with open(odir + "ElementReactionFluxGraph.dot", "w") as out:
            for i in range(len(inp) - 1):
                if i == 1:
                    out.write(
                        '    graph [b="0,0,1558,558", rankdir=TB, center=true, splines=True, size="3,5!", dpi=400, ratio="fill"];\n')
                if 'label=' in inp[i]:
                    # create more space between label and arrow (avoid overlapping)
                    inp[i] = inp[i].replace('label="', 'label=" ')
                out.write(inp[i] + '\n')
            rank = '\n    {rank="source"; ' + ','.join(spec_to_plot) + '}\n}'
            out.write(rank)
    
    # apply manual changes to png output file
    os.system('dot -Tpng ' + odir + 'ElementReactionFluxGraph.dot -o ' + odir + 'ElementReactionFluxGraph.png')
    
    # create eps file of reaction pathway graph
    os.system('dot -Tps2 ' + odir + 'ElementReactionFluxGraph.dot -o ' + odir + 'ElementReactionFluxGraph.eps')

    return dot
