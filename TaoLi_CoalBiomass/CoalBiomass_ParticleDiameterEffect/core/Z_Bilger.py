#!/usr/bin/env python3

import pandas as pd


def MixtureFractionCoal(df, YO2ox):
    '''
    Computes the mixture fraction for the coal composition (PoliMi model)
    according to Bilger's definition.
    '''

    # mass fraction - fuel side
    H2 = df['H2_max']
    CH2 = df['CH2_max']
    CH4 = df['CH4_max']
    # TETRALIN is not in the ITV-mechanism (gas phase)
    A2R5 = df['A2R5_max']
    CO = df['CO_max']
    A2CH3 = df['A2CH3_max']
    # BIN1B is not in the ITV-mechanism (gas phase)
    OC8H7OOH = df['OC8H7OOH_max']
    CH2O = df['CH2O_max']
    CH3O = df['CH3O_max']
    C6H5OCH3 = df['C6H5OCH3_max']
    C2H4 = df['C2H4_max']
    C3H6 = df['C3H6_max']
    C6H6 = df['C6H6_max']

    # mass fraction - oxygen
    O2 = df['O2_max']

    # molecular weight: elements
    W_H = 1.008
    W_C = 12.011
    W_O = 15.999
    #W_N = 14.010

    # molecular weight: fuel side species
    W_H2 = 2 * W_H
    W_CH2 = W_C + 2 * W_H
    W_CH4 = W_C + 4 * W_H
    #W_TETRALIN  = 10*W_C + 12*W_H
    W_A2R5 = 12 * W_C + 8 * W_H
    W_CO = W_C + W_O
    W_A2CH3 = 11 * W_C + 10 * W_H
    #W_BIN1B     = 20*W_C + 10*W_H
    W_OC8H7OOH = 8 * W_C + 8 * W_H + 3 * W_O
    W_CH2O = W_C + 2 * W_H + W_O
    W_CH3O = W_C + 3 * W_H + W_O
    W_C6H5OCH3 = 7 * W_C + 8 * W_H + W_O
    W_C2H4 = 2 * W_C + 4 * W_H
    W_C3H6 = 3 * W_C + 6 * W_H
    W_C6H6 = 6 * W_C + 6 * W_H

    # molecular weight: oxygen
    W_O2 = 2 * W_O

    # Allocate memory
    Z = []

    for i in range(len(df.index)):
        # mixture fraction based on Bilger's definition
        # get fuel side composition
        Y_Fu = H2[i] + CH2[i] + CH4[i] + A2R5[i] + CO[i] \
            + A2CH3[i] + OC8H7OOH[i] + CH2O[i] + CH3O[i] \
            + C6H5OCH3[i] + C2H4[i] + C3H6[i] + C6H6[i]
        # calculate molecular weight for fuel side
        # normalize mass fraction fuel side -> equal to one
        H2n = H2[i] / Y_Fu
        CH2n = CH2[i] / Y_Fu
        CH4n = CH4[i] / Y_Fu
        #TETRALINn = TETRALIN[i] / Y_Fu
        A2R5n = A2R5[i] / Y_Fu
        COn = CO[i] / Y_Fu
        A2CH3n = A2CH3[i] / Y_Fu
        #BIN1Bn    = BIN1B[i] / Y_Fu
        OC8H7OOHn = OC8H7OOH[i] / Y_Fu
        CH2On = CH2O[i] / Y_Fu
        CH3On = CH3O[i] / Y_Fu
        C6H5OCH3n = C6H5OCH3[i] / Y_Fu
        C2H4n = C2H4[i] / Y_Fu
        C3H6n = C3H6[i] / Y_Fu
        C6H6n = C6H6[i] / Y_Fu
        W_F = 1 / (H2n / W_H2 + CH2n / W_CH2 + CH4n / W_CH4
                   + A2R5n / W_A2R5 + COn / W_CO + A2CH3n / W_A2CH3
                   + OC8H7OOHn / W_OC8H7OOH + CH2On / W_CH2O
                   + CH3On / W_CH3O + C6H5OCH3n / W_C6H5OCH3
                   + C2H4n / W_C2H4 + C3H6n / W_C3H6 + C6H6n / W_C6H6)
        # oxygen content in unburnt
        Y_O2u = O2[i]

        # stoichiometric coefficent: O2
        X_H2n = H2n * W_F / W_H2
        X_CH2n = CH2n * W_F / W_CH2
        X_CH4n = CH4n * W_F / W_CH4
        #X_TETRALINn = TETRALINn * W_F / W_TETRALIN
        X_A2R5n = A2R5n * W_F / W_A2R5
        X_COn = COn * W_F / W_CO
        X_A2CH3n = A2CH3n * W_F / W_A2CH3
        #X_BIN1Bn    = BIN1Bn * W_F / W_BIN1B
        X_OC8H7OOHn = OC8H7OOHn * W_F / W_OC8H7OOH
        X_CH2On = CH2On * W_F / W_CH2O
        X_CH3On = CH3On * W_F / W_CH3O
        X_C6H5OCH3n = C6H5OCH3n * W_F / W_C6H5OCH3
        X_C2H4n = C2H4n * W_F / W_C2H4
        X_C3H6n = C3H6n * W_F / W_C3H6
        X_C6H6n = C6H6n * W_F / W_C6H6

        nu_co2 = X_CH2n + X_CH4n + 12 * X_A2R5n + X_COn \
            + 11 * X_A2CH3n + 8 * X_OC8H7OOHn + X_CH2On \
            + X_CH3On + 7 * X_C6H5OCH3n + 2 * X_C2H4n \
            + 3 * X_C3H6n + 6 * X_C6H6n

        nu_h2o = 2 * X_H2n + 2 * X_CH2n + 4 * X_CH4n + 12 * X_A2R5n \
            + 0 * X_A2CH3n + 8 * X_OC8H7OOHn + 2 * X_CH2On \
            + 3 * X_CH3On + 8 * X_C6H5OCH3n + 4 * X_C2H4n \
            + 6 * X_C3H6n + 6 * X_C6H6n

        nu_O2 = 0.5 * (2 * nu_co2 + nu_h2o - X_COn - 3 * X_OC8H7OOHn
                       - X_CH2On - X_CH3On - X_C6H5OCH3n)

        # caluclate mixture fraction based on Bilger's definition
        Z.append((Y_Fu + W_F * (YO2ox - Y_O2u) / (nu_O2 * W_O2)) /
                 (1 + W_F * YO2ox / (nu_O2 * W_O2)))

    df['Z'] = Z

    return df


def MixtureFractionBiomass(df, YO2ox):
    '''
    Computes the mixture fraction for the biomass composition (PoliMi model)
    according to Bilger's definition.
    '''

    # mass fraction - fuel side
    H2 = df['H2_max']
    CH4 = df['CH4_max']
    CO = df['CO_max']
    CH3CHO = df['CH3CHO_max']
    CH3OH = df['CH3OH_max']
    CH2O = df['CH2O_max']
    HOCHO = df['HOCHO_max']
    C2H4 = df['C2H4_max']
    C2H5OH = df['C2H5OH_max']
    C2H6 = df['C2H6_max']
    VANILLIN = df['OC8H7OOH_max']
    C6H5OCH3 = df['C6H5OCH3_max']
    CRESOL = df['HOA1CH3_max']
    C2H3CHO = df['C2H3CHO_max']
    C6H5OH = df['A1OH_max']

    # mass fraction - oxygen
    O2 = df['O2_max']

    # molecular weight: elements
    W_H = 1.008
    W_C = 12.011
    W_O = 15.999
    #W_N = 14.010

    # molecular weight: fuel side species
    W_H2 = 2 * W_H
    W_CH4 = W_C + 4 * W_H
    W_CO = W_C + W_O
    W_CH3CHO = 2 * W_C + 4 * W_H + W_O
    W_CH3OH = W_C + 4 * W_H + W_O
    W_CH2O = W_C + 2 * W_H + W_O
    W_HOCHO = W_C + 2 * W_H + 2 * W_O
    W_C2H4 = 2 * W_C + 4 * W_H
    W_C2H5OH = 2 * W_C + 6 * W_H + W_O
    W_C2H6 = 2 * W_C + 6 * W_H
    W_VANILLIN = 8 * W_C + 8 * W_H + 3 * W_O
    W_C6H5OCH3 = 7 * W_C + 8 * W_H + W_O
    W_CRESOL = 7 * W_C + 8 * W_H + W_O
    W_C2H3CHO = 3 * W_C + 4 * W_H + W_O
    W_C6H5OH = 6 * W_C + 6 * W_H + W_O

    # molecular weight: oxygen
    W_O2 = 2 * W_O

    # Allocate memory
    Z = []

    for i in range(len(df.index)):
        # mixture fraction based on Bilger's definition
        # get fuel side composition
        Y_Fu = H2[i] + CH4[i] + CO[i] \
            + CH3CHO[i] + CH3OH[i] + CH2O[i] \
            + HOCHO[i] + C2H4[i] + C2H5OH[i] \
            + C2H6[i] + VANILLIN[i] + C6H5OCH3[i] \
            + CRESOL[i] + C2H3CHO[i] + C6H5OH[i]
        # calculate molecular weight for fuel side
        # normalize mass fraction fuel side -> equal to one
        H2n = H2[i] / Y_Fu
        CH4n = CH4[i] / Y_Fu
        COn = CO[i] / Y_Fu
        CH3CHOn = CH3CHO[i] / Y_Fu
        CH3OHn = CH3OH[i] / Y_Fu
        CH2On = CH2O[i] / Y_Fu
        HOCHOn = HOCHO[i] / Y_Fu
        C2H4n = C2H4[i] / Y_Fu
        C2H5OHn = C2H5OH[i] / Y_Fu
        C2H6n = C2H6[i] / Y_Fu
        VANILLINn = VANILLIN[i] / Y_Fu
        C6H5OCH3n = C6H5OCH3[i] / Y_Fu
        CRESOLn = CRESOL[i] / Y_Fu
        C2H3CHOn = C2H3CHO[i] / Y_Fu
        C6H5OHn = C6H5OH[i] / Y_Fu
        W_F = 1 / (H2n / W_H2 + CH4n / W_CH4 + COn / W_CO
                   + CH3CHOn / W_CH3CHO + CH3OHn / W_CH3OH + CH2On / W_CH2O
                   + HOCHOn / W_HOCHO + C2H4n / W_C2H4
                   + C2H5OHn / W_C2H5OH + C2H6n / W_C2H6
                   + VANILLINn / W_VANILLIN + C6H5OCH3n / W_C6H5OCH3
                   + CRESOLn / W_CRESOL + C2H3CHOn / W_C2H3CHO
                   + C6H5OHn / W_C6H5OH)
        # oxygen content in unburnt
        Y_O2u = O2[i]

        # stoichiometric coefficent: O2
        X_H2n = H2n * W_F / W_H2
        X_CH4n = CH4n * W_F / W_CH4
        X_COn = COn * W_F / W_CO
        X_CH3CHOn = CH3CHOn * W_F / W_CH3CHO
        X_CH3OHn = CH3OHn * W_F / W_CH3OH
        X_CH2On = CH2On * W_F / W_CH2O
        X_HOCHOn = HOCHOn * W_F / W_HOCHO
        X_C2H4n = C2H4n * W_F / W_C2H4
        X_C2H5OHn = C2H5OHn * W_F / W_C2H5OH
        X_C2H6n = C2H6n * W_F / W_C2H6
        X_VANILLINn = VANILLINn * W_F / W_VANILLIN
        X_C6H5OCH3n = C6H5OCH3n * W_F / W_C6H5OCH3
        X_CRESOLn = CRESOLn * W_F / W_CRESOL
        X_C2H3CHOn = C2H3CHOn * W_F / W_C2H3CHO
        X_C6H5OHn = C6H5OHn * W_F / W_C6H5OH

        nu_co2 = X_CH4n + X_COn + 2 * X_CH3CHOn + X_CH3OHn \
            + X_CH2On + X_HOCHOn + 2 * X_C2H4n + 2 * X_C2H5OHn \
            + 2 * X_C2H6n + 8 * X_VANILLINn + 7 * X_C6H5OCH3n \
            + 7 * X_CRESOLn + 3 * X_C2H3CHOn + 6 * X_C6H5OHn

        nu_h2o = 2 * X_H2n + 4 * X_CH4n + 4 * X_CH3CHOn + 4 * X_CH3OHn \
            + 2 * X_CH2On + 2 * X_HOCHOn + 4 * X_C2H4n + 6 * X_C2H5OHn \
            + 6 * X_C2H6n + 8 * X_VANILLINn + 8 * X_C6H5OCH3n \
            + 8 * X_CRESOLn + 4 * X_C2H3CHOn + 6 * X_C6H5OHn

        nu_O2 = 0.5 * (2 * nu_co2 + nu_h2o - X_COn - 3 * X_CH3CHOn
                       - X_CH3OHn - X_CH2On - 2 * X_HOCHOn - X_C2H5OHn
                       - 3 * X_VANILLINn - X_C6H5OCH3n - X_CRESOLn - X_C2H3CHOn
                       - X_C6H5OHn)

        # caluclate mixture fraction based on Bilger's definition
        Z.append((Y_Fu + W_F * (YO2ox - Y_O2u) / (nu_O2 * W_O2))
                 / (1 + W_F * YO2ox / (nu_O2 * W_O2)))

    df['Z'] = Z

    return df
