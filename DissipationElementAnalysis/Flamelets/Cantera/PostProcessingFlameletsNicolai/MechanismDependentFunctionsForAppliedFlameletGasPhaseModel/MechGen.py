#!/usr/bin/env python3

import sys
from SUB import MechanismDependentFunctions as mdf

ofile = 'TEST.py'

# task
index = True
SpeciesList = True
MolecularWeight = True
Compo = True
Diffusion = True

species = ['N2', 'H', 'O2', 'O', 'OH', 'H2', 'H2O', 'AR', 'HE', 'HO2', 'H2O2', 'CO', 
        'CO2', 'HCO', 'C', 'CH', 'TXCH2', 'CH3', 'CH2O', 'HCCO', 'C2H', 'CH2CO', 
        'C2H2', 'SXCH2', 'CH3OH', 'CH2OH', 'CH3O', 'CH4', 'CH3O2', 'C2H3', 'C2H4', 
        'C2H5', 'HCCOH', 'CH2CHO', 'CH3CHO', 'H2C2', 'C2H5O', 'NXC3H7', 'C2H6', 
        'C3H8', 'C3H6', 'C3H3', 'PXC3H4', 'AXC3H4', 'SXC3H5', 'NXC4H3', 'C2H3CHO', 
        'AXC3H5', 'C2O', 'C4H4', 'C3H2', 'C3H2O', 'C4H2', 'IXC4H3', 'TXC3H5', 
        'C3H5O', 'C4H', 'C8H2', 'C6H2', 'C4H6', 'NXC4H5', 'IXC4H5', 'A1XC6H6', 
        'C5H4CH2', 'A1XXC6H5', 'A1C2H2', 'A1C2H3', 'A1C2H', 'A1C2HY', 'A1C2H3Y', 
        'C5H6', 'C5H5', 'TXC5H5O', 'C5H4O', 'SXC5H5O', 'C9H8', 'C9H7', 'A1CH2', 
        'C9H6O', 'OXC6H4', 'A1CH3', 'A1OH', 'HOA1CH3', 'OA1CH3', 'A1CH2O', 'A1CH2OH', 
        'A1CHO', 'A1OXC6H5O', 'A1CH3Y', 'A1C2H4', 'A1C2H5', 'C8H9O2', 'C8H8OOH', 
        'OC8H7OOH', 'A1CH3CH3', 'A1CH3CH2', 'A1CH3CHO', 'A1CHOCH2', 'A1CHOCHO', 'OC6H4O']
  
# index
if index:
    with open(ofile, 'w') as out:
        out.write("#!/usr/bin/env python3\n\nimport pandas as pd\n\n# species numbering")
        for i in range(len(species)):
            out.write("\nS{0}={1};".format(species[i], i))
        out.write("\nn_species = {0}\n".format(len(species)))

if SpeciesList:
    with open(ofile, 'a+') as out:
        out.write("\n\ndef Species():\n\n    species = [\n")
        for i in species:
            out.write("            '{0}',\n".format(i))
        out.write("        ]\n\n    return species")


if MolecularWeight:
    with open(ofile, 'a+') as out:
        out.write("\n\ndef MolecularWeight():\n\n    # allocate memory\n    MM = [0] * n_species\
                \n\n    # molar mass according to mechanism\n")
        ref_data = mdf.MolecularWeight()
        ref_spec = mdf.Species()
        for i in range(len(species)):
            mw = '???'
            if species[i] in ref_spec:
                idx = ref_spec.index(species[i])
                mw = ref_data[idx]
                #print('Species: ' + str(species[i]) +  '; mw = ' + str(mw))
            else:
                print('Species not found: ', species[i])
            out.write("    MM[S{0}] = {1}\n".format(species[i], mw))
        out.write("\n    return MM\n")

if Compo:
    with open(ofile, 'a+') as out:
        out.write("\n\ndef ElementalComposition(species):\n\n    # supported elements and structure: dict = {'species': [H, C, N, O]}")
        out.write("\n\n    elements = ['H', 'C', 'N', 'O']\n\n    # dictionary\n    ecomp = {\n")
        # reference
        ref_spec = mdf.Species()
        ref_data = mdf.ElementalComposition(ref_spec)
        for i in range(len(species)):
            H = '?'
            C = '?'
            N = '?'
            O = '?'
            if species[i] in ref_data.columns:
                comp = ref_data[species[i]].tolist()
                H = comp[0]
                C = comp[1]
                N = comp[2]
                O = comp[3]
            else:
                print('Species not found: ', species[i])
            out.write("            '{0}': [ {1}, {2}, {3}, {4}],\n".format(species[i], H, C, N, O))
        out.write("            }\n\n    # convert dict to df\n    comp = pd.DataFrame.from_dict(ecomp)")
        out.write('\n\n    # rename index\n    for i in range(len(elements)):\
                \n        comp = comp.rename(index={i: str(elements[i])})\n\n    return comp\n')


if Diffusion:
    Spec = mdf.Species()
    data = mdf.DiffusionCoefficients(Spec)
    print('data: \n', data)
    df = data[species]
    print('new data:\n', data[species])
    df = df.loc[species]
    print(df)
    #with open(ofile, 'a+') as out:
    #   out.write("\n\ndef DiffusionCoefficients():\n\n    # ...")
        #for i in species:
        #    out.write("    DCOEFF_{0} = [{2}]".format(i, df))
    df.columns = list([col.rjust(20, ' ') for col in df.columns])
    df.to_csv('test.txt', sep='\t', float_format='%20.8E', index=False)

