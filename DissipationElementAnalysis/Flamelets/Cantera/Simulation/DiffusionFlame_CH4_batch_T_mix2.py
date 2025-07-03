"""
This example creates a batches of Volatile counterflow diffusion flame simulations.
"""
import cantera as ct
import numpy as np
import os
import string
import matplotlib.pyplot as plt

# mix_char/(mix_vol+mix_char)
ratioF = 0.0

# Create directory for output data files
data_directory = 'Vol_diffusion_flame_batch_'+str(ratioF)+'/'
if not os.path.exists(data_directory):
    os.makedirs(data_directory)

class MyF(string.Formatter): 
    def format_field(self, value, format_spec):
        ss = string.Formatter.format_field(self,value,format_spec)
        if format_spec.endswith('E'):
            if ( 'E' in ss):
                mantissa, exp = ss.split('E')
                return mantissa + 'E'+ exp[0] + '{:03d}'.format(int(exp[1:]))
        return ss
        
# PART 1: INITIALIZATION
oxidizer = 'O2:0.27, CO2:0.73'
# Set up an initial methane-oxygen counterflow flame at 1 bar and low strain
reaction_mechanism = 'ITV.cti'
gas = ct.Solution(reaction_mechanism)
m = gas.n_species
iN2 = gas.species_index('N2')
iO2 = gas.species_index('O2')
iH2O = gas.species_index('H2O')
iCO = gas.species_index('CO')
iCO2 = gas.species_index('CO2')
#iCH2 = gas.species_index('TXCH2')
iCH2 = gas.species_index('CH4')
iCH4 = gas.species_index('CH4')
iCH2O = gas.species_index('CH2O')
#iCH3O = gas.species_index('CH3O')
iCH3O = gas.species_index('CH2O')
iC2H2 = gas.species_index('C2H2')
speciesNames = gas.species_names

Vol = np.zeros(m)
Vol[iH2O] = 0.0856
Vol[iCO2] = 0.1042
Vol[iO2] = 0.2242
Vol[iN2] = 0.586

Char = np.zeros(m)
Char[iH2O] = 0.268
Char[iCO2] = 0.072
Char[iCO] = 0.057
Char[iCH4] = 0.087
Char[iC2H2] = 0.516


width = 150e-3 # 50mm wide
f = ct.CounterflowDiffusionFlame(gas, width=width)

# Define the operating pressure and boundary conditions
p = ct.one_atm  # pressure [Pa]<<<<<<
f.P = p  # 1 bar
f.transport_model = 'UnityLewis'
#f.fuel_inlet.mdot = 0.08  # kg/m^2/s
f.fuel_inlet.mdot = 0.8  # kg/m^2/s
f.fuel_inlet.Y = Char
f.fuel_inlet.T = 1100  # K
f.oxidizer_inlet.mdot = 0.8  # kg/m^2/s
f.oxidizer_inlet.Y = Vol
f.oxidizer_inlet.T = 1100  # K
if ratioF != 1:
    tempL = [300+x*100 for x in range(0,13)]
else:
    tempL = [800+x*100 for x in range(0,17)]

# Set refinement parameters, if used
f.set_refine_criteria(ratio=4, slope=0.2, curve=0.3, prune=0.04)

# Define a limit for the maximum temperature below which the flame is
# considered as extinguished and the computation is aborted
# This increases the speed of refinement is enabled
temperature_limit_extinction = f.oxidizer_inlet.T+100  # K
def write_header(fid,f,t):
    fid.write('[Cantera_DATAFILE_VERSION]\n\n\n')
    fid.write('[NUMBER_OF_GRIDPOINTS]\n')
    fid.write(' {:d}\n'.format(len(f.grid)))
    fid.write('[FILECONTENT]\n')
    fid.write('Massfractions ( - ) SOURCETERMS (kmol/m^3/s)\n')                                                                         
    fid.write('[NUMBER_OF_SPECIES]\n')
    fid.write(' {:d}\n'.format(m))
    fid.write('[NUMBER_OF_VARIABLES]\n')
    fid.write(' {:d}\n\n'.format(2*m+5))
    fid.write('[TIME]\n')
    fid.write(' 0.0\n')
    fid.write('[INLET]\n')
    fid.write('Tinlet =  {:6.2f} K'.format(t)+', Pinlet =  {:7.2f} Pa.\n'.format(p))
    fid.write('[COMMENT]\n')
    fid.write('CounterflowDiffusionFlame, Stationary solution, Constant Lewis numbers diffusion, Detailed chemistry,  No radiation model.\n')
    fid.write('[USER_COMMENT]\n')
    fid.write(' -\n\n')                                                      
    fid.write('[FILE_STRUCTURE_COLUMNS_CONTAINING]\n')
    fid.write('{:22}'.format('x')+('{:22}'*m).format(*speciesNames)+('s{:21}'*m).format(*speciesNames)
    +('{:22}'*4).format('Temp','Enthalpy','Density','HeatRelease'))

def output_chem1dstyle(f,z,t):
    fid = open(data_directory+'yiend.{:04d}'.format(int(t))+'.{:03d}'.format(z),'w')
    write_header(fid,f,t)
    for i in range(0,len(f.grid)-1):
        #fid.write(MyF().format('\n{:+20.13E} ',f.grid[i])+MyF().format(('{:+20.13E} '*m),(*f.Y[:,i]))+MyF().format(('{:+20.13E} '*m),(*f.net_production_rates[:,i]))
        #+MyF().format(('{:+20.13E} '*4),(*[f.T[i], f.enthalpy_mass[i], f.density[i], f.heat_release_rate[i]])))
        fid.write('\n{:+20.13E} '.format(f.grid[i])+('{:+20.13E} '*m).format(*f.Y[:,i])+('{:+20.13E} '*m).format(*f.net_production_rates[:,i])
        +('{:+20.13E} '*4).format(*[f.T[i], f.enthalpy_mass[i], f.density[i], f.heat_release_rate[i]]))
    
    fid.close()

def interrupt_extinction(t):
    if np.max(f.T) < temperature_limit_extinction:
        raise Exception('Flame extinguished')
    return 0.
       
# PART 2: STRAIN RATE LOOP

# Compute counterflow diffusion flames at increasing strain rates at 1 bar
# The strain rate is assumed to increase by 25% in each step until the flame is
# extinguished
strain_factor = 1.25

# Exponents for the initial solution variation with changes in strain rate
# Taken from Fiala and Sattelmayer (2014)
exp_d_a = - 1. / 2.
exp_u_a = 1. / 2.
exp_V_a = 1.
exp_lam_a = 2.
exp_mdot_a = 1. / 2.

strainratemaxtemp = 0
for i in tempL:
    width = 300e-3 # 50mm wide
    strainratemaxtemp = strainratemaxtemp + 0.5
    f = ct.CounterflowDiffusionFlame(gas, width=width)
    f.fuel_inlet.mdot = 0.01  # kg/m^2/s
    f.fuel_inlet.Y = Char
    f.fuel_inlet.T = min(i,800)  # K
    f.oxidizer_inlet.mdot = 0.01#*(16)/(28.84)  # kg/m^2/s
    f.oxidizer_inlet.Y = Vol
    f.oxidizer_inlet.T = i  # K

    # Set refinement parameters, if used
    f.set_refine_criteria(ratio=4, slope=0.2, curve=0.3, prune=0.04)

    # Define a limit for the maximum temperature below which the flame is
    # considered as extinguished and the computation is aborted
    # This increases the speed of refinement is enabled
    #temperature_limit_extinction = max(f.oxidizer_inlet.T+600,900)  # K
    temperature_limit_extinction = max(f.oxidizer_inlet.T+600,900)  # K
    # Initialize and solve
    print('Creating the initial solution for t={0:04d}'.format(i))
    f.solve(loglevel=2, auto=True)

    f.set_interrupt(interrupt_extinction)
    # Save to data directory
    file_name = 'initial_solution_{0:04d}.xml'.format(i)
    f.save(data_directory + file_name, name='solution',
           description='Cantera version ' + ct.__version__ +
           ', reaction mechanism ' + reaction_mechanism)
    # Restore initial solution
    f.restore(filename=data_directory + file_name, name='solution', loglevel=0)
    print(np.max(f.T))
    # Counter to identify the loop
    n = 1
    # Do the strain rate loop
    while np.max(f.T) > temperature_limit_extinction:
        
        print('strain rate iteration', n)
        # Create an initial guess based on the previous solution
        # Update grid
        f.flame.grid *= strain_factor ** exp_d_a
        normalized_grid = f.grid / (f.grid[-1] - f.grid[0])
        # Update mass fluxes
        f.fuel_inlet.mdot *= strain_factor ** exp_mdot_a
        f.oxidizer_inlet.mdot *= strain_factor ** exp_mdot_a
        # Update velocities
        f.set_profile('u', normalized_grid, f.u * strain_factor ** exp_u_a)
        f.set_profile('V', normalized_grid, f.V * strain_factor ** exp_V_a)
        # Update pressure curvature
        f.set_profile('lambda', normalized_grid, f.L * strain_factor ** exp_lam_a)
        try:
            # Try solving the flame
            f.solve(loglevel=0)
            file_name = 'Temp_'+format(i, '04d')+'strain_loop_' + format(n, '02d') + '.xml'
            output_chem1dstyle(f,n,i)
            a_max = f.strain_rate('mean')
            print('strain rate a ={0:.2e}'.format(a_max))
            if a_max>strainratemaxtemp:
                print('SaveData!')
                f.save(data_directory + file_name, name='solution', loglevel=1,
                       description='Cantera version ' + ct.__version__ +
                       ', reaction mechanism ' + reaction_mechanism)
                n += 1
        except Exception as e:
            if e.args[0] == 'Flame extinguished':
                print('Flame extinguished')
            else:
                print('Error occurred while solving:', e)
            break


    # PART 3: PLOT SOME FIGURES

    fig3 = plt.figure()
    fig4 = plt.figure()
    fig5 = plt.figure()
    ax3 = fig3.add_subplot(1,1,1)
    ax4 = fig4.add_subplot(1,1,1)
    ax5 = fig5.add_subplot(1,1,1)
    n_selected = range(1, n, 5)
    #n_selected = range(n-10, n, 1)
    for n in n_selected:
        file_name = 'Temp_'+format(i, '04d')+'strain_loop_' + format(n, '02d') + '.xml'
        f.restore(filename=data_directory + file_name, name='solution', loglevel=0)
        a_max = f.strain_rate('mean') # the maximum axial strain rate

        # Plot the temperature profiles for the strain rate loop (selected)
        ax3.plot(f.grid / f.grid[-1], f.T, label='{0:.2e} 1/s'.format(a_max))

        # Plot the axial velocity profiles (normalized by the fuel inlet velocity)
        # for the strain rate loop (selected)
        ax4.plot(f.grid / f.grid[-1], f.u / f.u[0],label=format(a_max, '.2e') + ' 1/s')
        ax5.plot(f.grid / f.grid[-1], f.Y[iCO,:]+f.Y[iCO2,:],label=format(a_max, '.2e') + ' 1/s')


    ax3.legend(loc=0)
    ax3.set_xlabel(r'$z/z_{max}$')
    ax3.set_ylabel(r'$T$ [K]')
    fig3.savefig(data_directory + 'figure_'+format(i, '04d')+'_T_a.png')

    ax4.legend(loc=0)
    ax4.set_xlabel(r'$z/z_{max}$')
    ax4.set_ylabel(r'$u/u_f$')
    fig4.savefig(data_directory + 'figure_'+format(i, '04d')+'_u_a.png')

    ax5.legend(loc=0)
    ax5.set_xlabel(r'$z/z_{max}$')
    ax5.set_ylabel(r'$Y_{pv}$')
    fig5.savefig(data_directory + 'figure_'+format(i, '04d')+'_Ypv_a.png')
    plt.close(fig3)
    plt.close(fig4)
    plt.close(fig5)

