#!/usr/bin/env python3

import pandas as pd

# species numbering
SN2=0;
SH=1;
SO2=2;
SO=3;
SOH=4;
SH2=5;
SH2O=6;
SAR=7;
SHE=8;
SHO2=9;
SH2O2=10;
SCO=11;
SCO2=12;
SHCO=13;
SC=14;
SCH=15;
STXCH2=16;
SCH3=17;
SCH2O=18;
SHCCO=19;
SC2H=20;
SCH2CO=21;
SC2H2=22;
SSXCH2=23;
SCH3OH=24;
SCH2OH=25;
SCH3O=26;
SCH4=27;
SCH3O2=28;
SC2H3=29;
SC2H4=30;
SC2H5=31;
SHCCOH=32;
SCH2CHO=33;
SCH3CHO=34;
SH2C2=35;
SC2H5O=36;
SNXC3H7=37;
SC2H6=38;
SC3H8=39;
SC3H6=40;
SC3H3=41;
SPXC3H4=42;
SAXC3H4=43;
SSXC3H5=44;
SNXC4H3=45;
SC2H3CHO=46;
SAXC3H5=47;
SC2O=48;
SC4H4=49;
SC3H2=50;
SC3H2O=51;
SC4H2=52;
SIXC4H3=53;
STXC3H5=54;
SC3H5O=55;
SC4H=56;
SC8H2=57;
SC6H2=58;
SC4H6=59;
SNXC4H5=60;
SIXC4H5=61;
SA1XC6H6=62;
SC5H4CH2=63;
SA1XXC6H5=64;
SA1C2H2=65;
SA1C2H3=66;
SA1C2H=67;
SA1C2HY=68;
SA1C2H3Y=69;
SC5H6=70;
SC5H5=71;
STXC5H5O=72;
SC5H4O=73;
SSXC5H5O=74;
SC9H8=75;
SC9H7=76;
SA1CH2=77;
SC9H6O=78;
SOXC6H4=79;
SA1CH3=80;
SA1OH=81;
SHOA1CH3=82;
SOA1CH3=83;
SA1CH2O=84;
SA1CH2OH=85;
SA1CHO=86;
SA1OXC6H5O=87;
SA1CH3Y=88;
SA1C2H4=89;
SA1C2H5=90;
SC8H9O2=91;
SC8H8OOH=92;
SOC8H7OOH=93;
SA1CH3CH3=94;
SA1CH3CH2=95;
SA1CH3CHO=96;
SA1CHOCH2=97;
SA1CHOCHO=98;
SOC6H4O=99;
n_species = 100


def Species():

    species = [
        'N2',
        'H',
        'O2',
        'O',
        'OH',
        'H2',
        'H2O',
        'AR',
        'HE',
        'HO2',
        'H2O2',
        'CO',
        'CO2',
        'HCO',
        'C',
        'CH',
        'TXCH2',
        'CH3',
        'CH2O',
        'HCCO',
        'C2H',
        'CH2CO',
        'C2H2',
        'SXCH2',
        'CH3OH',
        'CH2OH',
        'CH3O',
        'CH4',
        'CH3O2',
        'C2H3',
        'C2H4',
        'C2H5',
        'HCCOH',
        'CH2CHO',
        'CH3CHO',
        'H2C2',
        'C2H5O',
        'NXC3H7',
        'C2H6',
        'C3H8',
        'C3H6',
        'C3H3',
        'PXC3H4',
        'AXC3H4',
        'SXC3H5',
        'NXC4H3',
        'C2H3CHO',
        'AXC3H5',
        'C2O',
        'C4H4',
        'C3H2',
        'C3H2O',
        'C4H2',
        'IXC4H3',
        'TXC3H5',
        'C3H5O',
        'C4H',
        'C8H2',
        'C6H2',
        'C4H6',
        'NXC4H5',
        'IXC4H5',
        'A1XC6H6',
        'C5H4CH2',
        'A1XXC6H5',
        'A1C2H2',
        'A1C2H3',
        'A1C2H',
        'A1C2HY',
        'A1C2H3Y',
        'C5H6',
        'C5H5',
        'TXC5H5O',
        'C5H4O',
        'SXC5H5O',
        'C9H8',
        'C9H7',
        'A1CH2',
        'C9H6O',
        'OXC6H4',
        'A1CH3',
        'A1OH',
        'HOA1CH3',
        'OA1CH3',
        'A1CH2O',
        'A1CH2OH',
        'A1CHO',
        'A1OXC6H5O',
        'A1CH3Y',
        'A1C2H4',
        'A1C2H5',
        'C8H9O2',
        'C8H8OOH',
        'OC8H7OOH',
        'A1CH3CH3',
        'A1CH3CH2',
        'A1CH3CHO',
        'A1CHOCH2',
        'A1CHOCHO',
        'OC6H4O'
    ]

    return species

def MolecularWeight():

    # allocate memory
    MM = [0] * n_species                

    # molar mass according to mechanism
    MM[SN2] = 28.02
    MM[SH] = 1.008
    MM[SO2] = 32.0
    MM[SO] = 16.0
    MM[SOH] = 17.008
    MM[SH2] = 2.016
    MM[SH2O] = 18.016
    MM[SAR] = 39.948
    MM[SHE] = 4.0
    MM[SHO2] = 33.008
    MM[SH2O2] = 34.016
    MM[SCO] = 28.01
    MM[SCO2] = 44.01
    MM[SHCO] = 29.018
    MM[SC] = 12.01
    MM[SCH] = 13.018
    MM[STXCH2] = 14.026
    MM[SCH3] = 15.034
    MM[SCH2O] = 30.026
    MM[SHCCO] = 41.028
    MM[SC2H] = 25.028
    MM[SCH2CO] = 42.036
    MM[SC2H2] = 26.036
    MM[SSXCH2] = 14.026
    MM[SCH3OH] = 32.042
    MM[SCH2OH] = 31.034
    MM[SCH3O] = 31.034
    MM[SCH4] = 16.042
    MM[SCH3O2] = 47.034
    MM[SC2H3] = 27.044
    MM[SC2H4] = 28.052
    MM[SC2H5] = 29.06
    MM[SHCCOH] = 42.036
    MM[SCH2CHO] = 43.044
    MM[SCH3CHO] = 44.052
    MM[SH2C2] = 26.036
    MM[SC2H5O] = 45.06
    MM[SNXC3H7] = 43.086
    MM[SC2H6] = 30.068
    MM[SC3H8] = 44.094
    MM[SC3H6] = 42.078
    MM[SC3H3] = 39.054
    MM[SPXC3H4] = 40.062
    MM[SAXC3H4] = 40.062
    MM[SSXC3H5] = 41.07
    MM[SNXC4H3] = 51.064
    MM[SC2H3CHO] = 56.062
    MM[SAXC3H5] = 41.07
    MM[SC2O] = 40.02
    MM[SC4H4] = 52.072
    MM[SC3H2] = 38.046
    MM[SC3H2O] = 54.046
    MM[SC4H2] = 50.056
    MM[SIXC4H3] = 51.064
    MM[STXC3H5] = 41.07
    MM[SC3H5O] = 57.07
    MM[SC4H] = 49.048
    MM[SC8H2] = 98.096
    MM[SC6H2] = 74.076
    MM[SC4H6] = 54.088
    MM[SNXC4H5] = 53.08
    MM[SIXC4H5] = 53.08
    MM[SA1XC6H6] = 78.108
    MM[SC5H4CH2] = 78.108
    MM[SA1XXC6H5] = 77.1
    MM[SA1C2H2] = 103.136
    MM[SA1C2H3] = 104.144
    MM[SA1C2H] = 102.128
    MM[SA1C2HY] = 101.12
    MM[SA1C2H3Y] = 103.136
    MM[SC5H6] = 66.098
    MM[SC5H5] = 65.09
    MM[STXC5H5O] = 81.09
    MM[SC5H4O] = 80.082
    MM[SSXC5H5O] = 81.09
    MM[SC9H8] = 116.154
    MM[SC9H7] = 115.146
    MM[SA1CH2] = 91.126
    MM[SC9H6O] = 130.138
    MM[SOXC6H4] = 76.092
    MM[SA1CH3] = 92.134
    MM[SA1OH] = 94.108
    MM[SHOA1CH3] = 108.134
    MM[SOA1CH3] = 107.126
    MM[SA1CH2O] = 107.126
    MM[SA1CH2OH] = 108.134
    MM[SA1CHO] = 106.118
    MM[SA1OXC6H5O] = 93.1
    MM[SA1CH3Y] = 91.126
    MM[SA1C2H4] = 105.152
    MM[SA1C2H5] = 106.16
    MM[SC8H9O2] = 137.152
    MM[SC8H8OOH] = 137.152
    MM[SOC8H7OOH] = 152.144
    MM[SA1CH3CH3] = 106.16
    MM[SA1CH3CH2] = 105.152
    MM[SA1CH3CHO] = 120.144
    MM[SA1CHOCH2] = 119.136
    MM[SA1CHOCHO] = 134.128
    MM[SOC6H4O] = 108.092

    return MM


def ElementalComposition(species):

    # supported elements and structure: dict = {'species': [H, C, N, O]}

    elements = ['H', 'C', 'N', 'O']

    # dictionary
    ecomp = {
            'N2': [ 0, 0, 2, 0],
            'H': [ 1, 0, 0, 0],
            'O2': [ 0, 0, 0, 2],
            'O': [ 0, 0, 0, 1],
            'OH': [ 1, 0, 0, 1],
            'H2': [ 2, 0, 0, 0],
            'H2O': [ 2, 0, 0, 1],
            'AR': [ 0, 0, 0, 0],
            'HE': [ 0, 0, 0, 0],
            'HO2': [ 1, 0, 0, 2],
            'H2O2': [ 2, 0, 0, 2],
            'CO': [ 0, 1, 0, 1],
            'CO2': [ 0, 1, 0, 2],
            'HCO': [ 1, 1, 0, 1],
            'C': [ 0, 1, 0, 0],
            'CH': [ 1, 1, 0, 0],
            'TXCH2': [ 2, 1, 0, 0],
            'CH3': [ 3, 1, 0, 0],
            'CH2O': [ 2, 1, 0, 1],
            'HCCO': [ 1, 2, 0, 1],
            'C2H': [ 1, 2, 0, 0],
            'CH2CO': [ 2, 2, 0, 1],
            'C2H2': [ 2, 2, 0, 0],
            'SXCH2': [ 2, 1, 0, 0],
            'CH3OH': [ 4, 1, 0, 1],
            'CH2OH': [ 3, 1, 0, 1],
            'CH3O': [ 3, 1, 0, 1],
            'CH4': [ 4, 1, 0, 0],
            'CH3O2': [ 3, 1, 0, 2],
            'C2H3': [ 3, 2, 0, 0],
            'C2H4': [ 4, 2, 0, 0],
            'C2H5': [ 5, 2, 0, 0],
            'HCCOH': [ 2, 2, 0, 1],
            'CH2CHO': [ 3, 2, 0, 1],
            'CH3CHO': [ 4, 2, 0, 1],
            'H2C2': [ 2, 2, 0, 0],
            'C2H5O': [ 5, 2, 0, 1],
            'NXC3H7': [ 7, 3, 0, 0],
            'C2H6': [ 6, 2, 0, 0],
            'C3H8': [ 8, 3, 0, 0],
            'C3H6': [ 6, 3, 0, 0],
            'C3H3': [ 3, 3, 0, 0],
            'PXC3H4': [ 4, 3, 0, 0],
            'AXC3H4': [ 4, 3, 0, 0],
            'SXC3H5': [ 5, 3, 0, 0],
            'NXC4H3': [ 3, 4, 0, 0],
            'C2H3CHO': [ 4, 3, 0, 1],
            'AXC3H5': [ 5, 3, 0, 0],
            'C2O': [ 0, 2, 0, 1],
            'C4H4': [ 4, 4, 0, 0],
            'C3H2': [ 2, 3, 0, 0],
            'C3H2O': [ 2, 3, 0, 1],
            'C4H2': [ 2, 4, 0, 0],
            'IXC4H3': [ 3, 4, 0, 0],
            'TXC3H5': [ 5, 3, 0, 0],
            'C3H5O': [ 5, 3, 0, 1],
            'C4H': [ 1, 4, 0, 0],
            'C8H2': [ 2, 8, 0, 0],
            'C6H2': [ 2, 6, 0, 0],
            'C4H6': [ 6, 4, 0, 0],
            'NXC4H5': [ 5, 4, 0, 0],
            'IXC4H5': [ 5, 4, 0, 0],
            'A1XC6H6': [ 6, 6, 0, 0],
            'C5H4CH2': [ 6, 6, 0, 0],
            'A1XXC6H5': [ 5, 6, 0, 0],
            'A1C2H2': [ 7, 8, 0, 0],
            'A1C2H3': [ 8, 8, 0, 0],
            'A1C2H': [ 6, 8, 0, 0],
            'A1C2HY': [ 5, 8, 0, 0],
            'A1C2H3Y': [ 7, 8, 0, 0],
            'C5H6': [ 6, 5, 0, 0],
            'C5H5': [ 5, 5, 0, 0],
            'TXC5H5O': [ 5, 5, 0, 1],
            'C5H4O': [ 4, 5, 0, 1],
            'SXC5H5O': [ 5, 5, 0, 1],
            'C9H8': [ 8, 9, 0, 0],
            'C9H7': [ 7, 9, 0, 0],
            'A1CH2': [ 7, 7, 0, 0],
            'C9H6O': [ 6, 9, 0, 1],
            'OXC6H4': [ 4, 6, 0, 0],
            'A1CH3': [ 8, 7, 0, 0],
            'A1OH': [ 6, 6, 0, 1],
            'HOA1CH3': [ 8, 7, 0, 1],
            'OA1CH3': [ 7, 7, 0, 1],
            'A1CH2O': [ 7, 7, 0, 1],
            'A1CH2OH': [ 8, 7, 0, 1],
            'A1CHO': [ 6, 7, 0, 1],
            'A1OXC6H5O': [ 5, 6, 0, 1],
            'A1CH3Y': [ 7, 7, 0, 0],
            'A1C2H4': [ 9, 8, 0, 0],
            'A1C2H5': [ 10, 8, 0, 0],
            'C8H9O2': [ 9, 8, 0, 2],
            'C8H8OOH': [ 9, 8, 0, 2],
            'OC8H7OOH': [ 8, 8, 0, 3],
            'A1CH3CH3': [ 10, 8, 0, 0],
            'A1CH3CH2': [ 9, 8, 0, 0],
            'A1CH3CHO': [ 8, 8, 0, 1],
            'A1CHOCH2': [ 7, 8, 0, 1],
            'A1CHOCHO': [ 6, 8, 0, 2],
            'OC6H4O': [ 4, 6, 0, 2],
            }

    # convert dict to df
    comp = pd.DataFrame.from_dict(ecomp)

    # rename index
    for i in range(len(elements)):                
        comp = comp.rename(index={i: str(elements[i])})

    return comp


def DiffusionCoefficients():
    
    df = pd.read_csv('core/DiffusionCoefficients.txt', sep='\t')
    
    return df

