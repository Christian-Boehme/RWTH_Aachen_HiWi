#!usr/bin/env python3

import sys
import numpy as np
import pandas as pd
from scipy import integrate
from . import MechanismDependentFunctions as mdf


def remove_space(string):
    return "".join(string.split())


def DetermineStartAndEndIteration(df, st, et):

    time = [round(x * 1000, 1) for x in df['time[ms]'].to_list()]  # [ms]

    if st in time:
        start = time.index(st)
    else:
        start = time.index(time[((np.abs(np.asarray(time) - st)).argmin())])
    if et in time:
        end = time.index(et)
    else:
        end = time.index(time[((np.abs(np.asarray(time) - et)).argmin())])

    if start > end:
        sys.exit('\nStart time > End time!')

    return start, end


def ElementContainingReactions(nr, elements, idx):

    # allocate memory
    df_ele = pd.DataFrame(False, columns=nr, index=np.arange(0, 1))

    for i in nr:
        ls, lc, rs, rc = SpeciesInReaction(i)
        species = ls + rs
        for j in species:
            if elements[j].iloc[idx] != 0:
                df_ele.loc[0, i] = True
                break

    return df_ele


def SplitSpeciesFromCoefficient(cs):

    res_idx = []
    species = []
    elements = ['H', 'C', 'N', 'O']
    if cs[0] == '.':
        cs = '0' + cs
    for spec in cs:
        idx = [spec.index(x) for x in spec if x.isalpha()]
        if len(idx) == 0:
            idx.append(0)
        species.append(spec[min(idx):])
        if spec[:min(idx)] == '':
            res_idx.append(1)
        else:
            if spec[:min(idx)][-1] == '.':
                res_idx.append(float(spec[:min(idx)-1]))
            else:
                res_idx.append(float(spec[:min(idx)]))

    return res_idx, species


def MergeSpeciesAndCoefficients(c, s):

    found_duplicate = True
    while found_duplicate:
        for i in range(len(s)):
            if s.count(s[i]) > 1:
                dup_s = s[i]
                dup_c = c[i]
                del s[i]
                del c[i]
                c[s.index(dup_s)] += dup_c
                break
        if len([x for x in s if s.count(x) > 1]) == 0:
            found_duplicate = False

    return c, s


def SpeciesInReaction(r):

    # remove reaction number
    r = r.split(': ')
    # determine reactants and products
    rs = r[1].split('=')
    lhs = rs[0]
    rhs = rs[1]
    # remove third-body
    if '+M' in lhs:
        if '(+M)' in lhs:
            lhs = lhs.split('(+M)')
            lhs = lhs[0]
            rhs = rhs.split('(+M)')
            rhs = rhs[0]
        else:
            lhs = lhs.split('+M')
            lhs = lhs[0]
            rhs = rhs.split('+M')
            rhs = rhs[0]
    # determine species
    lhs_spec = lhs.split('+')
    rhs_spec = rhs.split('+')
    # split stoichiometric coefficient (integer or floating point)
    lhs_coeff, lhs_spec = SplitSpeciesFromCoefficient(lhs_spec)
    rhs_coeff, rhs_spec = SplitSpeciesFromCoefficient(rhs_spec)
    # check if a species occurs more than one time on a reaction-side
    if len([x for x in lhs_spec if lhs_spec.count(x) > 1]) != 0:
        lhs_coeff, lhs_spec = MergeSpeciesAndCoefficients(lhs_coeff, lhs_spec)
    if len([x for x in rhs_spec if rhs_spec.count(x) > 1]) != 0:
        rhs_coeff, rhs_spec = MergeSpeciesAndCoefficients(rhs_coeff, rhs_spec)
    # check if species occurs on both sides -> not reacting species!
    # if len(list(set(lhs_spec) & set(rhs_spec))) != 0:
    #    duplicate = list(set(lhs_spec) & set(rhs_spec))
    #    lhs_idx = list(map(lhs_spec.index, duplicate))
    #    rhs_idx = list(map(rhs_spec.index, duplicate))
    #    if len(lhs_idx) != 1 or len(rhs_idx) != 1:
    #        # should normally not be the case ...
    #        sys.exit('\nSpecies occurs more than two times in recation!?!')
    #    if lhs_coeff[lhs_idx[0]] == rhs_coeff[rhs_idx[0]]:
    #        del lhs_spec[lhs_idx[0]]
    #        del lhs_coeff[lhs_idx[0]]
    #        del rhs_spec[rhs_idx[0]]
    #        del rhs_coeff[rhs_idx[0]]

    return lhs_spec, lhs_coeff, rhs_spec, rhs_coeff


def ComputeReactionRateAndProductionRate(r, sl, tstart, tend, df):

    # allocate memory
    inp = True
    df_W = pd.DataFrame(columns=r)
    df_CDOTp = pd.DataFrame(columns=sl)
    df_CDOTd = pd.DataFrame(columns=sl)
    df_CDOT = pd.DataFrame(columns=sl)

    # compute reaction rate and production rate for each time-step
    # NOTE: input data = volumetric averaged data
    c = df.columns
    MM = mdf.MolecularWeight()

    # reaction rates as input?
    if list(df.columns)[1] == 'T[K]':
        inp = False

    if inp:
        df_time = df['time[ms]']
        df = df.drop('time[ms]', axis=1)

    t = []
    for row in range(tstart, tend):
        if inp is False:
            t.append(float(df['time[ms]'][row]))
            T = float(df['T[K]'][row])
            rho = float(df['density[kg/m^3]'][row])
            P = float(df['Pressure'][row])
            Y = df.loc[row, c[4]:].values.flatten().tolist()
            # compute molar concentration
            C = [0] * (len(Y))
            for i in range(len(C)):
                C[i] = rho * float(Y[i]) / MM[i]

            W_timestep = mdf.ReactionRates(T, P, C)
        else:
            W_timestep = df.iloc[row].to_list()
            t.append(df_time[row])

        df_W.loc[len(df_W)] = W_timestep
        CDOTp, CDOTd, CDOT = mdf.ProductionRates(W_timestep)
        df_CDOTp.loc[len(df_CDOTp)] = CDOTp
        df_CDOTd.loc[len(df_CDOTd)] = CDOTd
        df_CDOT.loc[len(df_CDOT)] = CDOT

    # add time to CDOT df
    df_CDOTp.insert(0, 'time[ms]', t)
    df_CDOTd.insert(0, 'time[ms]', t)
    df_CDOT.insert(0, 'time[ms]', t)

    return df_W, df_CDOTp, df_CDOTd, df_CDOT


def NetReactionRate(r, sl, tstart, tend, df, nr):

    # allocate memory
    df_net = pd.DataFrame()

    W, CDOTp, CDOTd, CDOT = ComputeReactionRateAndProductionRate(
        r, sl, tstart, tend, df)

    i = 0
    for num in range(len(W.columns)):
        if 'B: ' not in r[num]:
            if num == len(W.columns) - 1:
                df_net = pd.concat([df_net, W[r[num]]], axis=1)
            elif 'B: ' in r[num + 1]:
                df_net = pd.concat([df_net, pd.DataFrame(
                    W[r[num]] - W[r[num + 1]], columns=[nr[i]])], axis=1)
            else:
                df_net = pd.concat([df_net, W[r[num]]], axis=1)
            i += 1

    return df_net, CDOTp, CDOTd, CDOT


# def Integration(y, x):
#
#    I = [0]*len(x)
#    I[0] = 0.0
#    I[1] = I[0] + y[1]*(x[1]-x[0])
#    for j in range(2,len(x)):
#        h1 = x[j] - x[j-1]
#        h2 = x[j-1] - x[j-2]
#        if (h1 <= 1.0e-16 or h2 <= 1.0e-16):
#            I[j] = I[j-1] + y[j]*(x[j] - x[j-1])
#        else :
#            fac = (h1 + h2)/h1
#            N = y[j]*fac*h2 + I[j-1]*fac*fac - I[j-2]
#            D = fac*fac-1
#            I[j] = N/D
#    return I


def TimeIntegratedNetReactionRate(df, df_inp):

    # allocate memory
    df_int = pd.DataFrame(columns=df.columns, index=np.arange(0, 1))

    # using trapzodial function for integration (other options: simpson rule, ... )
    # for i in df.columns:
    #    df_int = pd.concat([df_int, pd.DataFrame([integrate.trapz(df[i], x=df_inp['time[ms]'])], columns=[i])], axis=1)
    # for i in df.columns:
    #    df_int[i][0] = df[i].sum() / df.shape[0]  # div by shape[0]

    # integration based on simpson rule
    time = df_inp['time[ms]'].to_list()
    for i in df.columns:
        df_int.loc[0, i] = float(integrate.simpson(df[i].tolist(), x=time))

    # integrated average net reaction rate
    endt = time[-1]
    for i in df.columns:
        df_int.loc[0, i] = float(df_int.loc[0, i] / endt)

    # rename index
    df_int = df_int.rename(index={0: 'ReactionRate'})

    return df_int


def DetermineReactantAndProductSpecies(r, W):

    # O+NO+NO=X returns for lhs_species: [O, NO] with lc (coeff): [1, 2]
    lhs_species, lc, rhs_species, rc = SpeciesInReaction(r)
    
    if W.loc['ReactionRate', r] < 0:
        reactants = rhs_species
        products = lhs_species
        coeff_reac = rc
        coeff_prod = lc
    else:
        reactants = lhs_species
        products = rhs_species
        coeff_reac = lc
        coeff_prod = rc

    return reactants, products, coeff_reac, coeff_prod


def FilterSpecies(species, coeff, idx, ele):

    # allocate memory
    s = []
    c = []

    for i in range(len(species)):
        if ele.loc[idx, species[i]] != 0:
            s.append(species[i])
            c.append(coeff[i])

    return s, c


def SpeciesMassFlux(sl, nr, element, idx, MM_ele, df_ele, ele_in_reac, W_net, save, subdir):
    """
    Flux calculation for the ROPA.
    """

    # allocate memory
    ele_species = []

    # determine species that contain the element
    for i in range(len(sl)):
        if df_ele.loc[element, sl[i]] != 0:
            ele_species.append(sl[i])

    # allocate memory
    df = pd.DataFrame(float(0.0), columns=ele_species,
                      index=np.arange(len(nr)))

    # rename index
    for i in range(len(nr)):
        df = df.rename(index={i: str(nr[i])})
    
    # compute flux
    for j in nr:
        if ele_in_reac[j][0]:
            reactants, products, coeff_reac, coeff_prod = DetermineReactantAndProductSpecies(
                j, W_net)
            # determine species that contain the element
            ele_reactants, coeff_reac = FilterSpecies(
                reactants, coeff_reac, element, df_ele)
            ele_products, coeff_prod = FilterSpecies(
                products, coeff_prod, element, df_ele)
            tot_N = float(
                sum([df_ele.loc[element, x] * coeff_reac[ele_reactants.index(x)] for x in ele_reactants]))
            #print('\n\nReaction: {0}\nreactants: {1}\nproducts: {2}\ncoeff_reac: {3}\ncoeff_prod: {4}\ntot_N: {5}'.format(j, ele_reactants, ele_products, coeff_reac, coeff_prod, tot_N))
            for rs in ele_reactants:
                cr = coeff_reac[ele_reactants.index(rs)]
                n_r = df_ele.loc[element, rs]
                for ps in ele_products:
                    cp = coeff_prod[ele_products.index(ps)]
                    n_p = df_ele.loc[element, ps] * cp
                    if rs == ps and cr == cp:
                        continue
                    # compute flux according to X.Wen
                    #flux = n_r * n_p * MM_ele * cr * W_net[j][0] / tot_N
                    # compute flux according to A.Shamooni
                    flux = n_r * n_p / tot_N * W_net[j]['ReactionRate']
                    #print('RESULTING:\ntot_N={0}\nA={1}\nC={2}\nn_r={3}\nn_p={4}\nsc_A={5}\nsc_C={6}\nflux={7}'.format(tot_N, rs, ps, n_r, n_p, cr, cp, flux))
                    # add flux to df
                    if flux > 0:
                        df.iat[nr.index(j), ele_species.index(rs)] -= flux
                        df.iat[nr.index(j), ele_species.index(ps)] += flux
                    else:
                        df.iat[nr.index(j), ele_species.index(rs)] += flux
                        df.iat[nr.index(j), ele_species.index(ps)] -= flux

    # add (integrated) reaction rate to df
    df['ReactionRate'] = pd.Series(W_net.iloc[0])

    # save df to file
    if save:
        df.columns = list([col.rjust(20, ' ') for col in df.columns])
        df.to_csv(subdir + '/SpeciesElementFluxes' + str(element) +
                  '.csv', sep='\t', float_format='%20.6E', index=False)

    return df


def MassFluxOfElement(sl, nr, W_net, ele_in_reac, df_ele, idx, MM_ele, element, save, subdir):
    """
    Flux calculation for the RPA.
    """

    # allocate memory
    df_L = pd.DataFrame(float(0.0), columns=sl, index=np.arange(len(sl)))

    # rename index
    for i in range(len(sl)):
        df_L = df_L.rename(index={i: str(sl[i])})

    # compute flux
    for j in nr:
        if ele_in_reac[j][0]:
            reactants, products, coeff_reac, coeff_prod = DetermineReactantAndProductSpecies(
                j, W_net)
            # determine species that contain the element
            ele_reactants, coeff_reac = FilterSpecies(
                reactants, coeff_reac, element, df_ele)
            ele_products, coeff_prod = FilterSpecies(
                products, coeff_prod, element, df_ele)
            tot_N = float(
                sum([df_ele.loc[element, x] * coeff_reac[ele_reactants.index(x)] for x in ele_reactants]))
            #print('\n\nReaction: {0}\nreactants: {1}\nproducts: {2}\ncoeff_reac: {3}\ncoeff_prod: {4}\ntot_N: {5}'.format(j, ele_reactants, ele_products, coeff_reac, coeff_prod, tot_N))
            for rs in ele_reactants:
                cr = coeff_reac[ele_reactants.index(rs)]
                n_r = df_ele.loc[element, rs]
                for ps in ele_products:
                    cp = coeff_prod[ele_products.index(ps)]
                    n_p = df_ele.loc[element, ps] * cp
                    if rs == ps and cr == cp:
                        continue
                    # compute flux according to X.Wen
                    #flux = n_r * n_p * MM_ele * cr * W_net[j][0] / tot_N
                    # compute flux according to A.Shamooni
                    flux = n_r * n_p / tot_N * W_net[j]['ReactionRate']
                    #print('RESULTING:\ntot_N={0}\nA={1}\nC={2}\nn_r={3}\nn_p={4}\nsc_A={5}\nsc_C={6}\nflux={7}'.format(tot_N, rs, ps, n_r, n_p, cr, cp, flux))
                    # add flux to df_L
                    df_L.iat[sl.index(rs), sl.index(ps)] += abs(flux)

    # save df to file
    if save:
        df_L.columns = list([col.rjust(20, ' ') for col in df_L.columns])
        df_L.to_csv(subdir + '/ElementFluxes' + str(element) +
                    '.csv', sep='\t', float_format='%20.6E', index=False)

    return df_L


def NetFlux(df):

    col = df.columns

    # compute net flux: abs(L(A->C) - L(C->A))
    for i in range(len(col)):
        for j in range(len(col)):
            if (df.iat[i, j] == 0 and df.iat[j, i] == 0) or i == j:
                continue
            if df.iat[i, j] - df.iat[j, i] >= 0:
                df.iat[i, j] -= df.iat[j, i]
                df.iat[j, i] = 0
            else:
                df.iat[j, i] -= df.iat[i, j]
                df.iat[i, j] = 0

    return df


def FluxNormalization(df, save, subdir, element):

    norm = df.sum(axis=1)
    for row in range(df.shape[0]):
        n = norm[row]
        for col in range(df.shape[1]):
            if df.iat[row, col] == 0:
                continue
            df.iat[row, col] = df.iat[row, col] / n * 100  # [%]

    #if save:
    #    df.columns = list([col.rjust(20, ' ') for col in df.columns])
    #    df.to_csv(subdir + '/NormalizedMassFlux' + str(element) +
    #              '.csv', sep='\t', float_format='%20.6E', index=False)

    return df


def FluxNormalization_Column(df):

    columns = list(df.columns)
    for col in range(df.shape[1]):
        n = sum(df[columns[col]].to_list())
        for row in range(df.shape[0]):
            if df.iat[row, col] == 0:
                continue
            df.iat[row, col] = df.iat[row, col] / n * 100  # [%]

    return df


def NetProductionRate(sl, nr, W):

    # computes the net production rate for all species in the mechanism
    # => sum of all reaction rates where the species participates

    # allocate memory
    df = pd.DataFrame(0, columns=sl, index=np.arange(0, 1))

    # rename index
    df = df.rename(index={0: 'NetProductionRate'})

    for j in nr:
        reactant, product, coeff_reac, coeff_prod = DetermineReactantAndProductSpecies(
            j, W)
        species = reactant + product
        for i in sl:
            if i in species:
                df[i] += W[j][0]

    return df
