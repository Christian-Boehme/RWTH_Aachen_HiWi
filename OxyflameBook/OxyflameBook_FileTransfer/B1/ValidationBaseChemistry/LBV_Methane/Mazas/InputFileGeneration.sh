#!/usr/bin/bash

# This script creates all required FlameMaster.input files

echo 'Directory: '
read dir
echo 'Mechanism: '
read Mech

# General data
N2=0.00
Pres=101325
Temp=373

# change directory
cd $dir
cd X_CO2_20/

# XCO2 = 0.2
CH4=1.0
O2=0.80
CO2=0.2

StartProf=CH4_p01_0phi0_4000tu0373
phi=0.40
FM="FlameMaster_phi0_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_4000tu0373
phi=0.45
FM="FlameMaster_phi0_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_4500tu0373
phi=0.50
FM="FlameMaster_phi0_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_5000tu0373
phi=0.55
FM="FlameMaster_phi0_55.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_5500tu0373
phi=0.60
FM="FlameMaster_phi0_60.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_6000tu0373
phi=0.65
FM="FlameMaster_phi0_65.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_6500tu0373
phi=0.70
FM="FlameMaster_phi0_70.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_7000tu0373
phi=0.75
FM="FlameMaster_phi0_75.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_7500tu0373
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_8000tu0373
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_8500tu0373
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_9000tu0373
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_9500tu0373
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_0000tu0373
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_0500tu0373
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_1000tu0373
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_1500tu0373
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_2000tu0373
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_2500tu0373
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_3000tu0373
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_3500tu0373
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_4000tu0373
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_4500tu0373
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_5000tu0373
phi=1.55
FM="FlameMaster_phi1_55.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_5500tu0373
phi=1.60
FM="FlameMaster_phi1_60.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy




# change directory
cd ../X_CO2_40/

# XCO2 = 0.40
CH4=1.00
O2=0.60
CO2=0.40

StartProf=CH4_p01_0phi0_4000tu0373
phi=0.40
FM="FlameMaster_phi0_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_4000tu0373
phi=0.45
FM="FlameMaster_phi0_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_4500tu0373
phi=0.50
FM="FlameMaster_phi0_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_5000tu0373
phi=0.55
FM="FlameMaster_phi0_55.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_5500tu0373
phi=0.60
FM="FlameMaster_phi0_60.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_6000tu0373
phi=0.65
FM="FlameMaster_phi0_65.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_6500tu0373
phi=0.70
FM="FlameMaster_phi0_70.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_7000tu0373
phi=0.75
FM="FlameMaster_phi0_75.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_7500tu0373
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_8000tu0373
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_8500tu0373
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_9000tu0373
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi0_9500tu0373
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_0000tu0373
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_0500tu0373
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_1000tu0373
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_1500tu0373
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_2000tu0373
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_2500tu0373
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_3000tu0373
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_3500tu0373
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_4000tu0373
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_4500tu0373
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_5000tu0373
phi=1.55
FM="FlameMaster_phi1_55.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

StartProf=output/CH4_p01_0phi1_5500tu0373
phi=1.60
FM="FlameMaster_phi1_60.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy

