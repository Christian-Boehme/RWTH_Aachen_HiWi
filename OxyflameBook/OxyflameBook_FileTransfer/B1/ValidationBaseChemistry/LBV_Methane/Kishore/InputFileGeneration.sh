#!/usr/bin/bash

# This script creates all required FlameMaster.input files

echo 'Directory: '
read dir
echo 'Mechanism: '
read Mech

# General data
O2=0.21
N2=0.79
Pres=1E5
Temp=307

# change directory
cd $dir
cd X_CO2_020/

# XCO2 = 0.2
CH4=0.8
CO2=0.2

StartProf=CH4_p01_0phi0_8000tu0307
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8000tu0307
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8500tu0307
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9001tu0307
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9500tu0307
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0000tu0307
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0501tu0307
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1000tu0307
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1500tu0307
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2000tu0307
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2500tu0307
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi


# change directory
cd ../X_CO2_040/

# XCO2 = 0.4
CH4=0.6
CO2=0.4

StartProf=CH4_p01_0phi0_8000tu0307
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8000tu0307
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8500tu0307
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9000tu0307
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9500tu0307
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0000tu0307
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0501tu0307
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1001tu0307
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1500tu0307
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2000tu0307
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2500tu0307
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi


# change directory
cd ../X_CO2_060/

# XCO2 = 0.6
CH4=0.4
CO2=0.6

StartProf=CH4_p01_0phi0_8000tu0307
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8000tu0307
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_8500tu0307
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9000tu0307
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi0_9500tu0307
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0000tu0307
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_0500tu0307
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1000tu0307
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_1500tu0307
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2000tu0307
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi

StartProf=output/CH4_p01_0phi1_2499tu0307
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi
