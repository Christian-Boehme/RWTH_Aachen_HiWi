#/usr/bin/env python3

import sys
from collections import Counter


def DetectDuplicated(l, dup):
    
    Additional = False
    if len(dup) != 0:
        l = [x for x in l if x not in dup]
    d = Counter(l)
    for i in d.keys():
        if d[i] != 1:
            print('=> Element "' + str(i) + '"\tocurres ' + str(d[i]) + ' times!')
            Additional = True

    return Additional


def JournalDictionary():
   
    # This dictionary contains all journal names and the respective abbreviation
    # The comment 'NEW' at the end is my suggestion (journal not present in the draft bib file)
    JAbbrev = {'ACM Transactions on Graphics': 'ACMTG',                                         # NEW
            'Air, Soil and Water Research': 'ASWR',                                             # NEW
            'Applications in Energy and Combustion Science': 'AECS',
            'Agricultural and Forest Meteorology': 'AFM',                                       # NEW
            'Advanced Materials Research': 'AMR',                                               # NEW
            'AFZ Der Wald': 'AFZ',                                                              # NEW   ???
            'Annals of Forest Science': 'AFS',                                                  # NEW
            'Applied Energy': 'AE',                                                             # NEW
            'Atmosphere': 'A',                                                                  # NEW
            'Bundesministerium für Wirtschaft und Energie': 'BMWi',                             # NEW
            'Bundesministerium Land- und Forstwirtschaft Regionen und Wasserwirtschaft': 'BML', # NEW
            'Case Studies in Thermal Engineering': 'CSTE',                                      # NEW
            'Combustion and Flame': 'CF',
            'Combustion Science and Technology': 'CST',                                         # NEW
            'Conference: 13th U.S. National Combustion Meeting': 'USNCM',                       # NEW
            'Current Forestry Reports': 'CFR',                                                  # NEW
            'Current Opinion in Environmental Science & Health': 'COESH',                       # NEW
            'De Gruyter': 'DeGruyter',                                                          # NEW
            "Earth's Future": 'EF',                                                             # NEW
            'Earthquake Engineering & Structural Dynamics': 'EESD',                             # NEW
            'Experiments in Fluids': 'EiF',                                                     # NEW
            'Encyclopedia of Wildfires and Wildland-Urban Interface (WUI) Fires': 'EWWUIF',     # NEW
            'Energy & Fuels': 'EaF',                                                            # NEW
            'European Combustion Meeting': 'ECM',                                               # NEW
            'European Union': 'EU',                                                             # NEW
            'Fire': 'F',                                                                        # NEW
            'Fire and Materials': 'FM',                                                         # NEW
            'Frontiers in Mechanical Engineering': 'Front',
            'Fire Safety Journal': 'FSJ',
            'Fire Safety Science': 'FSS',                                                       # NEW
            'Fire Science and Technology': 'FST',                                               # NEW
            'Fire Technology': 'FT',
            'Flow, Turbulence and Combustion': 'FTC',                                           # NEW
            'Fuel': 'FUEL',
            'Holzforschung': 'Holzforschung',                                                   # NEW
            'IBHS Research': 'IBHS',                                                            # NEW
            'International Journal of Disaster Risk Reduction': 'IJDRR',                        # NEW
            'International Journal of Engine Research': 'IJER',                                 # NEW
            'International Journal of Heat and Mass Transfer': 'IJHMT',
            'International Journal of Multiphase Flow': 'IJMF',                                 # NEW
            'International Journal of Thermal Sciences': 'IJTS',                                # NEW
            'International Journal of Wildland Fire': 'IJWF',                                   # NEW
            'IOP Conference Series Earth and Environmental Science': 'EES',                     # NEW
            'Journal of Analytical and Applied Pyrolysis': 'JAAP',                              # NEW
            'Journal of Combustion': 'JoC',                                                     # NEW
            'Journal of Computational Physics': 'JoCP',                                         # NEW
            'Journal of Fire Sciences': 'JFS',                                                  # NEW
            'Journal of Forestry Research': 'JFR',                                              # NEW
            'Journal of Safety Science and Resilience': 'JSSR',                      	        # NEW
            'Journal of Scientific Computing': 'JSC',                                           # NEW
            'Journal of Wind Engineering and Industrial Aerodynamics': 'JWEIA',      	        # NEW
            'Korean Journal of Remote Sensing': 'KJRS',                                         # NEW
            'Landesfeuerwehr- und Katastrophenschutzschule': 'LKSS',                            # NEW   ???
            'National Institute of Standards and Technology': 'NIST',                           # NEW
            'Mathematics and Computers in Simulation': 'MCS',                                   # NEW
            'Palaeobiodiversity and Palaeoenvironments': 'PaP',                                 # NEW
            'Procedia Engineering': 'PE',                                                       # NEW
            'Physics of Fluids': 'PF',
            'Proceedings of the Combustion Institute': 'CI',
            'Proceedings of the European Combustion Meeting': 'PECM',                           # NEW   ???? ECM ???
            'Proceedings of the National Academy of Sciences': 'PNAS',                          # NEW
            'Progress in Energy and Combustion Science': 'PECS',
            'Process Safety and Environmental Protection': 'PSEP',                              # NEW
            'Renewable Energy': 'RE',                                                           # NEW
            'Safety Science': 'SaSc',	                                                        # NEW
            'Science of The Total Environment': 'STE',                                          # NEW
            'SAE International Journal of Advances and Current Practices in Mobility': 'SAE',   # NEW
            'Springer': 'Springer',                                                             # NEW
            'Springer International Publishing' : 'Springer',                                   # NEW
            'Ständige Konferenz der Innenminister und -senatoren der Länder': 'SKISL',          # NEW   ???
            'Symposium (International) on Combustion': 'CI',
            'Thesis': 'Thesis',                                                                 # NEW
            'US Department of Agriculture forest service': 'USAFS',                             # NEW
            'United States Department of Agriculture': 'USDA',                                  # NEW
            'Wiley': 'Wiley',
            'Wood Science and Technology': 'WST'                                                # NEW
            }

    # unique journal and abbreviations
    abbrev_k = list(JAbbrev.keys())
    abbrev_v = list(JAbbrev.values())
    if len(abbrev_k) != len(set(abbrev_k)):
        flag = DetectDuplicated(abbrev_k, [])
        if flag:
            sys.exit('\nDuplicated journal name in dictionary!')
    if len(abbrev_v) != len(set(abbrev_v)):
        Allowed = ['CI', 'Springer'] # allowed duplicated abbreviations
        flag = DetectDuplicated(abbrev_v, Allowed)
        if flag:
            sys.exit('\nDuplicated abbreviation in dictionary!')

    return JAbbrev

