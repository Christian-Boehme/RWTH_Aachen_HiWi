#!/usr/bin/bash

# This script creates all required FlameMaster.input files

echo 'Directory: '
read dir
echo 'Mechanism: '
read Mech

# General data
N2=0.00
Pres=101325
O2=0.35
CO2=0.65
CH4=0.0
CH3OH=1.0

# change directory
cd $dir
cd T308K/

# T308K
Temp=308

StartProf=CH3OH_p01_0phi0_8000tu0308
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8000tu0308
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8500tu0308
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9000tu0308
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9500tu0308
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0000tu0308
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0500tu0308
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1000tu0308
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1500tu0308
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2000tu0308
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2500tu0308
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3000tu0308
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3500tu0308
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4000tu0308
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4500tu0308
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH



# change directory
cd ../T318K/

# T318K
Temp=318

StartProf=CH3OH_p01_0phi0_8000tu0318
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8000tu0318
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8500tu0318
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9000tu0318
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9500tu0318
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0000tu0318
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0500tu0318
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1000tu0318
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1500tu0318
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2000tu0318
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2500tu0318
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3000tu0318
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3500tu0318
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4000tu0318
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4500tu0318
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH



# change directory
cd ../T328K/

# T328K
Temp=328

StartProf=CH3OH_p01_0phi0_8000tu0328
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8000tu0328
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8500tu0328
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9000tu0328
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9500tu0328
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0000tu0328
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0500tu0328
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1000tu0328
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1500tu0328
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2000tu0328
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2500tu0328
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3000tu0328
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3500tu0328
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4000tu0328
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4500tu0328
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH



# change directory
cd ../T338K/

# T338K
Temp=338

StartProf=CH3OH_p01_0phi0_8000tu0338
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8000tu0338
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8500tu0338
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9000tu0338
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9500tu0338
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0000tu0338
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0500tu0338
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1000tu0338
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1500tu0338
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2000tu0338
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2500tu0338
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3000tu0338
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3500tu0338
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4000tu0338
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4500tu0338
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH



# change directory
cd ../T358K/

# T358K
Temp=358

StartProf=CH3OH_p01_0phi0_8000tu0358
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8000tu0358
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_8500tu0358
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9000tu0358
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi0_9500tu0358
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0000tu0358
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_0500tu0358
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1000tu0358
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_1500tu0358
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2000tu0358
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_2500tu0358
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3000tu0358
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_3500tu0358
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4000tu0358
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH

StartProf=output/CH3OH_p01_0phi1_4500tu0358
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XCH3OH $CH3OH


