#!/usr/bin/env python3

import sys
import argparse


def write_file(filename, YFCO, YFCO2, YFCH4, YFH2O, YFC2H2, Tfuel, Fmdot, YOH2O, YOCO2, YOO2, YON2, Toxid, Omdot, mech, Pres, Dist, StartProf, a):

    #
    Vfuel = 0.0
    Voxid = -0.0

    #
    with open(filename, 'w') as out:
        out.write('# Generated from: GenerateLBVInputFile.py\n')
        out.write('#Inputs - global\n#mech = {}\n#Pres = {}\n#Dist = {}\n#Startprofile = {}#a = {}\n\n'.format(
            mech, Pres, Dist, StartProf, a))
        out.write('#Inputs - fuel side:\n#YCO = {}\n#YCO2 = {}\n#YCH4  = {}\n#YH2O = {}\
                \n#YC2H2 = {}\n#Temp = {}\n#mdot = {}\n\n'.format(YFCO, YFCO2, YFCH4, YFH2O, YFC2H2, Tfuel, Fmdot))
        out.write('#Inputs - oxidizer side\n#YOH2O = {}\n#YOCO2 = {}\n#YOO2 = {}\n#YON2 = {}\
                \n#Temp = {}\n#mdot = {}\n\n'.format(YOH2O, YOCO2, YOO2, YON2, Toxid, Omdot))
        out.write('############\n')
        out.write('# Numerics #\n')
        out.write('############\n\n')
        out.write('UseNumericalJac is TRUE\n')
        out.write('UseModifiedNewton = TRUE\n\n')
        out.write('DampFlag = TRUE\n')
        out.write('LambdaMin = 5.0e-3\n\n')
        out.write('DeltaTStart = 1.0e-4\n')
        out.write('DeltaTMax = 1.0e5\n\n')
        out.write('MaxIter = 100\n')
        out.write('TolRes = 1.0e-14\n')
        out.write('TolDy = 1e-6\n\n')
        out.write('#######\n')
        out.write('# Grid#\n')
        out.write('#######\n\n')
        out.write('DeltaNewGrid = 15\n')
        out.write('OneSolutionOneGrid = TRUE\n')
        out.write('initialgridpoints = 495\n')
        out.write('maxgridpoints = 500\n')
        out.write('q = -0.25\n')
        out.write('R = 60\n\n')
        out.write('left = 0.0\n')
        out.write('right = {}\n\n'.format(Dist))
        out.write('#######\n')
        out.write('# I/O #\n')
        out.write('#######\n\n')
        out.write('WriteEverySolution = TRUE\n')
        out.write('PrintMolarFractions is TRUE\n')
        out.write('#AdditionalOutput is TRUE\n\n')
        out.write('Boundaries_at_inner_grid_points = TRUE\n\n')
        out.write('OutputPath is ./output\n')
        out.write('StartProfilesFile is {}\n\n'.format(StartProf))
        out.write('#############\n')
        out.write('# Chemistry #\n')
        out.write('#############\n\n')
        out.write('MechanismFile is {}\n'.format(mech))
        out.write('globalReaction is C2H2 +2.5 O2 == 2 CO2 + 1 H2O;\n\n')
        out.write('fuel is C2H2\n')
        out.write('oxidizer is O2\n\n')
        out.write('#########\n')
        out.write('# Flame #\n')
        out.write('#########\n\n')
        # EigenValueDiffusion on physical coordinate\n')
        out.write('Flame is CounterFlowDiffusion\n')
        out.write('StrainRate = {}\n'.format(a))
        out.write('FlameIsAxisymmetric = TRUE\n')
        out.write('ExactBackward is TRUE\n\n')
        out.write('pressure = {:.1f}\n\n'.format(Pres))
        out.write('ComputeWithRadiation is FALSE\n')
        out.write('ArclengthCont = TRUE\n')
        out.write('ConstLewisNumber is TRUE\n')
        out.write('LewisNumberFile is LewisNumberOne\n')
        out.write('ThermoDiffusion is TRUE\n')
        out.write('TransModel is MultiGeom\n\n')  # ???
        out.write('#######################\n')
        out.write('# Boundary conditions #\n')
        out.write('#######################\n\n')
        out.write('Fuel Side {\n')
        out.write('     dirichlet {\n')
        out.write('         T  = {:.2f}\n'.format(Tfuel))
        # out.write('         V  = {:.3f}\n'.format(Vfuel))
        out.write('         Y->CO   = {:.5f}\n'.format(YFCO))
        out.write('         Y->CO2  = {:.5f}\n'.format(YFCO2))
        out.write('         Y->CH4  = {:.5f}\n'.format(YFCH4))
        out.write('         Y->H2O  = {:.5f}\n'.format(YFH2O))
        out.write('         Y->C2H2 = {:.5f}\n'.format(YFC2H2))
        out.write('         }\n}\n\n')
        out.write('Oxidizer Side {\n')
        out.write('     dirichlet {\n')
        out.write('         T  = {:.2f}\n'.format(Toxid))
        # out.write('         V  = {:.3f}\n'.format(Voxid))
        out.write('         Y->H2O = {:.5f}\n'.format(YOH2O))
        out.write('         Y->CO2 = {:.5f}\n'.format(YOCO2))
        out.write('         Y->O2  = {:.5f}\n'.format(YOO2))
        out.write('         Y->N2  = {:.5f}\n'.format(YON2))
        out.write('         }\n')
        out.write('}\n\n')

    return


def main(args=None):

    parser = argparse.ArgumentParser(
        description='Create FlameMaster.input file for a counterflow simulation')

    parser.add_argument('-o', type=str, required=True,
                        help='Name of output file (FlameMaster.input')
    parser.add_argument('-YFCO', type=float, required=False,
                        help='CO mass fraction (fuel side)')
    parser.add_argument('-YFCO2', type=float, required=False,
                        help='CO2 mass fraction (fuel side)')
    parser.add_argument('-YFCH4', type=float, required=False,
                        help='CH4 mass fraction (fuel side)')
    parser.add_argument('-YFH2O', type=float, required=False,
                        help='H2O mass fraction (fuel side)')
    parser.add_argument('-YFC2H2', type=float, required=False,
                        help='C2H2 mass fraction (fuel side)')
    parser.add_argument('-Tfuel', type=float, required=False,
                        help='Temperature (fuel side)')
    parser.add_argument('-Fmdot', type=float, required=False,
                        help='Mass flux (fuel side)')
    parser.add_argument('-YOH2O', type=float, required=False,
                        help='H2O mass fraction (oxidizer side)')
    parser.add_argument('-YOCO2', type=float, required=False,
                        help='CO2 mass fraction (oxidizer side)')
    parser.add_argument('-YOO2', type=float, required=False,
                        help='O2 mass fraction (oxidizer side)')
    parser.add_argument('-YON2', type=float, required=False,
                        help='N2 mass fraction (oxidizer side)')
    parser.add_argument('-Toxid', type=float, required=False,
                        help='Temperature (oxidizer side)')
    parser.add_argument('-Omdot', type=float, required=False,
                        help='mass flux (oxidizer side)')
    parser.add_argument('-mech', type=str, required=True,
                        help='Path to kinetic model')
    parser.add_argument('-Pres', type=float, required=True,
                        help='Pressure in bar')
    parser.add_argument('-Dist', type=float, required=True,
                        help='Distance in meter')
    parser.add_argument('-StartProf', type=str,
                        required=True, help='Path to StartProfile')
    parser.add_argument('-a', type=str, required=True,
                        help='Strainrate in 1/s')

    # Default settings
    parser.set_defaults(YFCO=0.0)
    parser.set_defaults(YFCO2=0.0)
    parser.set_defaults(YFCH4=0.0)
    parser.set_defaults(YFH2O=0.0)
    parser.set_defaults(YFC2H2=0.0)
    parser.set_defaults(TFuel=0.0)
    parser.set_defaults(Fmdot=0.0)
    parser.set_defaults(YOH2O=0.0)
    parser.set_defaults(YOCO2=0.0)
    parser.set_defaults(YOO2=0.0)
    parser.set_defaults(YON2=0.0)
    parser.set_defaults(Toxid=0.0)
    parser.set_defaults(Omdot=0)
    parser.set_defaults(mech='')
    parser.set_defaults(Pres=0)
    parser.set_defaults(Dist=0.0)
    parser.set_defaults(StartProf='')
    parser.set_defaults(a=0.0)

    #
    args = parser.parse_args(args)

    #
    write_file(args.o, args.YFCO, args.YFCO2, args.YFCH4, args.YFH2O, args.YFC2H2, args.Tfuel, args.Fmdot, args.YOH2O,
               args.YOCO2, args.YOO2, args.YON2, args.Toxid, args.Omdot, args.mech, args.Pres, args.Dist, args.StartProf, args.a)
    return


if __name__ == '__main__':
    main()
