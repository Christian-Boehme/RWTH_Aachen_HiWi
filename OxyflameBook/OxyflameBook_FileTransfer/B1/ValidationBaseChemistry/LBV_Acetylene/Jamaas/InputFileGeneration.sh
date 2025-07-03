#!/usr/bin/bash

# This script creates all required FlameMaster.input files

echo 'Directory: '
read dir
echo 'Mechanism: '
read Mech

# General data
N2=0.79
Pres=101325
O2=0.21
CO2=0.0
CH4=0.0
C2H2=1.0
CH3OH=0.0

# change directory
mkdir -p $dir
cd $dir
mkdir -p T298K
cd T298K/
mkdir -p output

# T298K
Temp=298

StartProf=C2H2_p01_0phi0_6000tu0298
phi=0.60
FM="FlameMaster_phi0_60.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_6000tu0298
phi=0.65
FM="FlameMaster_phi0_65.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_6500tu0298
phi=0.70
FM="FlameMaster_phi0_70.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_7000tu0298
phi=0.75
FM="FlameMaster_phi0_75.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_7500tu0298
phi=0.80
FM="FlameMaster_phi0_80.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_8000tu0298
phi=0.85
FM="FlameMaster_phi0_85.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_8500tu0298
phi=0.90
FM="FlameMaster_phi0_90.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_9000tu0298
phi=0.95
FM="FlameMaster_phi0_95.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_9500tu0298
phi=1.00
FM="FlameMaster_phi1_00.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi0_0000tu0298
phi=1.05
FM="FlameMaster_phi1_05.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_0500tu0298
phi=1.10
FM="FlameMaster_phi1_10.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_1000tu0298
phi=1.15
FM="FlameMaster_phi1_15.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_1500tu0298
phi=1.20
FM="FlameMaster_phi1_20.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_2000tu0298
phi=1.25
FM="FlameMaster_phi1_25.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_2500tu0298
phi=1.30
FM="FlameMaster_phi1_30.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_3000tu0298
phi=1.35
FM="FlameMaster_phi1_35.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_3500tu0298
phi=1.40
FM="FlameMaster_phi1_40.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_4000tu0298
phi=1.45
FM="FlameMaster_phi1_45.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_4500tu0298
phi=1.50
FM="FlameMaster_phi1_50.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_5000tu0298
phi=1.55
FM="FlameMaster_phi1_55.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_5500tu0298
phi=1.60
FM="FlameMaster_phi1_60.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_6000tu0298
phi=1.65
FM="FlameMaster_phi1_65.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_6500tu0298
phi=1.70
FM="FlameMaster_phi1_70.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_7000tu0298
phi=1.75
FM="FlameMaster_phi1_75.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_7500tu0298
phi=1.80
FM="FlameMaster_phi1_80.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_8000tu0298
phi=1.85
FM="FlameMaster_phi1_85.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_8500tu0298
phi=1.90
FM="FlameMaster_phi1_90.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_9000tu0298
phi=1.95
FM="FlameMaster_phi1_95.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2

StartProf=output/C2H2_p01_0phi1_9500tu0298
phi=2.00
FM="FlameMaster_phi2_00.input"
python3 ../../../../../Scripts/GenerateLBVInputFiles.py -XCH4 $CH4 -XCO2 $CO2 -XO2 $O2 -XN2 $N2 -mech $Mech -Pres $Pres -Temp $Temp -StartProf $StartProf -o $FM -phi $phi -Oxy -XC2H2 $C2H2


