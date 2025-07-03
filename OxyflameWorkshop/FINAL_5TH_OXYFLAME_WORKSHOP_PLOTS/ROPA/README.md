# Comparison coal vs biomass
-> different kinetic models
(-> different reaction numbers!)
=> can't use FluxAnalysis script (only for one kinetic model)

# How to compare two or more simulations with different kinetic models?
-> write dominant reactions to a file
    Add these three lines ton core/ROPA.py - line 258:
    df_print = pd.DataFrame(zip(reactions, Data1), columns=['Reactions', 'Percentage'])
    df_print.to_csv('Output/Data_' + species  + '.csv', sep='\t', index=False)
    sys.exit()
-> run all cases (use small tolerance AND only one input file for ROPA!)
    bash OxyflameWorkshop_DataPreperation.sh
    => creates files in Data/
    # NOTE checked the script with the JET MIS AIR simulation - validation
    #=> script returns the same percentages and reactions as the 'original/full' script
-> create figures
    => bash OxyflameWorkshop_CreateAllFigures.sh
