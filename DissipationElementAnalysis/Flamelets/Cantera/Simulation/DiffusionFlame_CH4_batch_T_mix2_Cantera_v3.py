#!/usr/bin/env python3

"""
This script simulates a batche of volatile counterflow diffusion flames using Cantera.
"""

import os
import sys
import string
import numpy as np
import cantera as ct
import matplotlib.pyplot as plt

# mix_char/(mix_vol+mix_char)
ratioF = 0.0

# Create directory for output data files
data_directory = 'Vol_diffusion_flame_batch_Cantera_v3_' + str(ratioF) + '/'
if not os.path.exists(data_directory):
    os.makedirs(data_directory)


class MyF(string.Formatter):
    def format_field(self, value, format_spec):
        ss = string.Formatter.format_field(self, value, format_spec)
        if format_spec.endswith('E'):
            if 'E' in ss:
                mantissa, exp = ss.split('E')
                return mantissa + 'E' + exp[0] + '{:03d}'.format(int(exp[1:]))
        return ss


# PART 1: INITIALIZATION
oxidizer = 'O2:0.27, CO2:0.73'
reaction_mechanism = '../../KineticModel/Base.yaml'
gas = ct.Solution(reaction_mechanism)
m = gas.n_species

species_indices = {
    name: gas.species_index(name) for name in [
        'N2', 'O2', 'H2O', 'CO', 'CO2', 'CH4', 'CH2O', 'C2H2'
    ]
}
speciesNames = gas.species_names

Vol = np.zeros(m)
Vol[species_indices['H2O']] = 0.0856
Vol[species_indices['CO2']] = 0.1042
Vol[species_indices['O2']] = 0.2242
Vol[species_indices['N2']] = 0.586

Char = np.zeros(m)
Char[species_indices['H2O']] = 0.268
Char[species_indices['CO2']] = 0.072
Char[species_indices['CO']] = 0.057
Char[species_indices['CH4']] = 0.087
Char[species_indices['C2H2']] = 0.516

width = 150e-3  # 150mm wide
f = ct.CounterflowDiffusionFlame(gas, width=width)

# Define operating pressure and boundary conditions
p = ct.one_atm  # pressure [Pa]
f.P = p  # 1 bar
f.transport_model = 'unity-Lewis-number' #'UnityLewis'
f.fuel_inlet.mdot = 0.8  # kg/m^2/s
f.fuel_inlet.Y = Char
f.fuel_inlet.T = 1100  # K
f.oxidizer_inlet.mdot = 0.8  # kg/m^2/s
f.oxidizer_inlet.Y = Vol
f.oxidizer_inlet.T = 1100  # K

if ratioF != 1:
    tempL = [1500 + x * 50 for x in range(0, 1)]
else:
    tempL = [1000 + x * 50 for x in range(0, 11)]

# Set refinement parameters
f.set_refine_criteria(ratio=4, slope=0.2, curve=0.3, prune=0.04)

# Define the extinction temperature limit
temperature_limit_extinction = f.oxidizer_inlet.T + 100  # K


def write_header(fid, f, t):
    fid.write('[Cantera_DATAFILE_VERSION]\n\n\n')
    fid.write('[NUMBER_OF_GRIDPOINTS]\n')
    fid.write(' {:d}\n'.format(len(f.grid)))
    fid.write('[FILECONTENT]\n')
    fid.write('Massfractions ( - ) SOURCETERMS (kmol/m^3/s)\n')
    fid.write('[NUMBER_OF_SPECIES]\n')
    fid.write(' {:d}\n'.format(m))
    fid.write('[NUMBER_OF_VARIABLES]\n')
    fid.write(' {:d}\n\n'.format(2 * m + 5))
    fid.write('[TIME]\n')
    fid.write(' 0.0\n')
    fid.write('[INLET]\n')
    fid.write('Tinlet =  {:6.2f} K'.format(t) +
              ', Pinlet =  {:7.2f} Pa.\n'.format(p))
    fid.write('[StrainRate]\na = {}\n\n'.format(f.strain_rate('mean')))
    fid.write('[COMMENT]\n')
    fid.write(
        'CounterflowDiffusionFlame, Stationary solution, Constant Lewis numbers diffusion, '
        'Detailed chemistry, No radiation model.\n'
    )
    fid.write('[USER_COMMENT]\n')
    fid.write(' -\n\n')
    fid.write('[FILE_STRUCTURE_COLUMNS_CONTAINING]\n')
    fid.write(
        '{:22}'.format('x') +
        ('{:22}' * m).format(*speciesNames) +
        ('s{:21}' * m).format(*speciesNames) +
        ('{:22}' * 7).format('Temp', 'Enthalpy', 'Density', 'HeatRelease', 'MixtureFraction', 'Dcoeff', 'DissipRate')
    )


def comp_DissRate(flame, Z):
   
    # details: https://cantera.org/dev/python/onedim.html#counterflowdiffusionflame
    dZdx = np.gradient(Z, flame.grid)
   
    Y = f.Y # same data structure as Dcoeff!
    #X = f.X
    #print(len(Y))
    Dcoeff = flame.mix_diff_coeffs_mass # data structure: [spec 1 all grid points], [spec 2 all grid points], ...] so Dcoeff[0] has 88 elements = number of grid points => len(Dcoeff) = 68 number of species!
    #print(Y[0])
    #print('-> ', len(Y[0]))
    #print(Dcoeff[0])
    D = np.sum(Y * Dcoeff, axis=0)
    #print(D)
    #print(len(D))
    chi = 2 * D * dZdx**2
    #sys.exit(chi)

    return chi, D


def output_chem1dstyle(f, z, t):
    fid = open(data_directory +
               'yiend.{:04d}'.format(int(t)) + '.{:03d}'.format(z), 'w')
    write_header(fid, f, t)
    MixFrac = f.mixture_fraction('C')   # option: C, H, or 'Bilger'
    chi, dcoeff = comp_DissRate(f, MixFrac)
    for i in range(len(f.grid)):
        fid.write(
            '\n{:+20.13E} '.format(f.grid[i]) +
            ('{:+20.13E} ' * m).format(*f.Y[:, i]) +
            ('{:+20.13E} ' * m).format(*f.net_production_rates[:, i]) +
            ('{:+20.13E} ' * 7).format(
                f.T[i], f.enthalpy_mass[i], f.density[i], f.heat_release_rate[i], MixFrac[i], dcoeff[i], chi[i]
            )
        )
    fid.close()


def interrupt_extinction(t):
    if np.max(f.T) < temperature_limit_extinction:
        raise Exception('Flame extinguished')
    return 0.


# PART 2: STRAIN RATE LOOP
strain_factor = 1.25 #1.10 # 1.25
strainratemaxtemp = 0

# Exponents for the initial solution variation with changes in strain rate
# Taken from Fiala and Sattelmayer (2014)
exp_d_a = - 1. / 2.
exp_u_a = 1. / 2.
exp_V_a = 1.
exp_lam_a = 2.
exp_mdot_a = 1. / 2.

# Compute flames at increasing strain rates
for i in tempL:
    width = 300e-3  # 300mm wide
    strainratemaxtemp += 0.5
    f = ct.CounterflowDiffusionFlame(gas, width=width)
    f.fuel_inlet.mdot = 0.01  # kg/m^2/s
    f.fuel_inlet.Y = Char
    f.fuel_inlet.T = min(i, 800)  # K
    f.oxidizer_inlet.mdot = 0.01  # kg/m^2/s
    f.oxidizer_inlet.Y = Vol
    f.oxidizer_inlet.T = i  # K

    f.set_refine_criteria(ratio=4, slope=0.2, curve=0.3, prune=0.04)
    temperature_limit_extinction = max(f.oxidizer_inlet.T + 600, 900)  # K

    print('Creating the initial solution for t={0:04d}'.format(i))
    f.solve(loglevel=2, auto=True)
    f.set_interrupt(interrupt_extinction)

    # Save to data directory
    file_name = 'initial_solution_{0:04d}.yaml'.format(i)
    f.save(data_directory + file_name, name='solution',
           description='Updated for Cantera v3.x')
    # Restore initial solution
    f.restore(filename=data_directory + file_name, name='solution', loglevel=0)
    print(np.max(f.T))

    n = 1
    while np.max(f.T) > temperature_limit_extinction:
        print('Strain rate iteration', n)
        # Update grid
        f.flame.grid *= strain_factor ** exp_d_a
        normalized_grid = f.grid / (f.grid[-1] - f.grid[0])
        # Update mass fluxes
        f.fuel_inlet.mdot *= strain_factor ** exp_mdot_a
        f.oxidizer_inlet.mdot *= strain_factor ** exp_mdot_a

        # Update velocities
        #f.set_profile('u', normalized_grid, f.u * strain_factor ** exp_u_a)
        #f.set_profile('V', normalized_grid, f.V * strain_factor ** exp_V_a)
        # Update pressure curvature
        f.set_profile('lambda', normalized_grid, f.L * strain_factor ** exp_lam_a)

        try:
            f.solve(loglevel=0)
            #file_name = 'Temp_'+format(i, '04d')+'strain_loop_' + format(n, '02d') + '.xml'
            file_name = 'initial_solution_{0:04d}.yaml'.format(i)
            output_chem1dstyle(f, n, i)
            a_max = f.strain_rate('mean')
            print('strain rate a ={0:.2e}'.format(a_max))
            if a_max>strainratemaxtemp:
                print('SaveData!')
                #file_name = 'initial_solution_{0:04d}.yaml'.format(i)
                #f.save(data_directory + file_name, name='solution',
                #       description='Updated for Cantera v3.x')
            #    f.save(data_directory + file_name, name='solution', loglevel=1,
            #           description='Cantera version ' + ct.__version__ +
            #           ', reaction mechanism ' + reaction_mechanism)
            n += 1
        except Exception as e:
            if str(e) == 'Flame extinguished':
                print('Flame extinguished')
            else:
                print('Error:', e)
            break
