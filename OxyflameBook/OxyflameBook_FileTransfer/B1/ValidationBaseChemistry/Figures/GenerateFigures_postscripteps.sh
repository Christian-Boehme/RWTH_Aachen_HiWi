#!usr/bin bash

# Define the reference mechanism folder
mech_dir_ref="ITV_BASE"
mech_dir_full="ITV_Intermediate"

# create output folder
mkdir -p figures_postscripteps

#####
# CH4-IDT - Hargis and Petersen
#####
# change directory
cd Scripts_postscripteps

X_CO2_025_ref="../../IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_025/IDT.txt"
X_CO2_050_ref="../../IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_050/IDT.txt"
X_CO2_075_ref="../../IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_075/IDT.txt"
X_CO2_025_full="../../IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_025/IDT.txt"
X_CO2_050_full="../../IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_050/IDT.txt"
X_CO2_075_full="../../IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_075/IDT.txt"
#X_CO2_025="../../IDT_Methane/HargisAndPetersen/"$mech_dir"/X_CO2_025/IDT.txt"
#X_CO2_050="../../IDT_Methane/HargisAndPetersen/"$mech_dir"/X_CO2_050/IDT.txt"
#X_CO2_075="../../IDT_Methane/HargisAndPetersen/"$mech_dir"/X_CO2_075/IDT.txt"

echo 'Methane IDT validation => Hargis and Petersen'
gnuplot -c IDT_CH4_HargisAndPetersen_025.gnu $X_CO2_025_ref $X_CO2_025_full
gnuplot -c IDT_CH4_HargisAndPetersen_050.gnu $X_CO2_050_ref $X_CO2_050_full
gnuplot -c IDT_CH4_HargisAndPetersen_075.gnu $X_CO2_075_ref $X_CO2_075_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_CH4_HargisAndPetersen_025.eps
ps2pdf -dEPSCrop IDT_CH4_HargisAndPetersen_050.eps
ps2pdf -dEPSCrop IDT_CH4_HargisAndPetersen_075.eps
echo 'Done'


#####
# CH4-IDT - Liu et al.
#####
# change directory
cd ../Scripts_postscripteps

Liu_ref="../../IDT_Methane/Liu/"$mech_dir_ref"/IDT.txt"
Liu_full="../../IDT_Methane/Liu/"$mech_dir_full"/IDT.txt"
#Liu="../../IDT_Methane/Liu/"$mech_dir"/IDT.txt"

echo 'Methane IDT validation => Liu et al.'
gnuplot -c IDT_CH4_Liu.gnu $Liu_ref $Liu_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_CH4_Liu.eps
echo 'Done'


#####
# CH4-IDT - Pryor et al.
#####
# change directory
cd ../Scripts_postscripteps

Pryor_ref="../../IDT_Methane/Pryor/"$mech_dir_ref"/IDT.txt"
Pryor_full="../../IDT_Methane/Pryor/"$mech_dir_full"/IDT.txt"
#Pryor="../../IDT_Methane/Pryor/"$mech_dir"/IDT.txt"

echo 'Methane IDT validation => Pryor et al.'
gnuplot -c IDT_CH4_Pryor_1atm.gnu $Pryor_ref $Pryor_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_CH4_Pryor_1atm.eps
echo 'Done'


#####
# CH4-IDT - Koroglu et al.
#####
# change directory
cd ../Scripts_postscripteps

Koroglu_Lean_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/LP/IDT.txt"
Koroglu_Lean_LP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Lean/LP/IDT.txt"
#Koroglu_Lean_LP="../../IDT_Methane/Koroglu/"$mech_dir"/Lean/LP/IDT.txt"
Koroglu_Stoi_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/LP/IDT.txt"
Koroglu_Stoi_LP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Stoichiometric/LP/IDT.txt"
#Koroglu_Stoi_LP="../../IDT_Methane/Koroglu/"$mech_dir"/Stoichiometric/LP/IDT.txt"
Koroglu_Rich_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/LP/IDT.txt"
Koroglu_Rich_LP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Rich/LP/IDT.txt"
#Koroglu_Rich_LP="../../IDT_Methane/Koroglu/"$mech_dir"/Rich/LP/IDT.txt"

Koroglu_Lean_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/HP/IDT.txt"
Koroglu_Lean_HP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Lean/HP/IDT.txt"
#Koroglu_Lean_HP="../../IDT_Methane/Koroglu/"$mech_dir"/Lean/HP/IDT.txt"
Koroglu_Stoi_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/HP/IDT.txt"
Koroglu_Stoi_HP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Stoichiometric/HP/IDT.txt"
#Koroglu_Stoi_HP="../../IDT_Methane/Koroglu/"$mech_dir"/Stoichiometric/HP/IDT.txt"
Koroglu_Rich_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/HP/IDT.txt"
Koroglu_Rich_HP_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/Rich/HP/IDT.txt"
#Koroglu_Rich_HP="../../IDT_Methane/Koroglu/"$mech_dir"/Rich/HP/IDT.txt"

Koroglu_Stoi_XCO2_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/X_CO2_060/IDT.txt"
Koroglu_Stoi_XCO2_full="../../IDT_Methane/Koroglu/"$mech_dir_full"/X_CO2_060/IDT.txt"
#Koroglu_Stoi_XCO2="../../IDT_Methane/Koroglu/"$mech_dir"/X_CO2_060/IDT.txt"

echo 'Methane IDT validation => Koroglu et al.'
gnuplot -c IDT_CH4_Koroglu_Lean.gnu $Koroglu_Lean_LP_ref $Koroglu_Lean_HP_ref $Koroglu_Lean_LP_full $Koroglu_Lean_HP_full $Koroglu_Lean_LP
gnuplot -c IDT_CH4_Koroglu_Rich.gnu $Koroglu_Rich_LP_ref $Koroglu_Rich_HP_ref $Koroglu_Rich_LP_full $Koroglu_Rich_HP_full $Koroglu_Rich_LP
gnuplot -c IDT_CH4_Koroglu_Stoi.gnu $Koroglu_Stoi_LP_ref $Koroglu_Stoi_HP_ref $Koroglu_Stoi_LP_full $Koroglu_Stoi_HP_full $Koroglu_Stoi_LP
gnuplot -c IDT_CH4_Koroglu_Stoi_XCO2_060.gnu $Koroglu_Stoi_XCO2_ref $Koroglu_Stoi_XCO2_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Lean.eps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Rich.eps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Stoi.eps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Stoi_XCO2_060.eps
echo 'Done'


#####
# CH4-LBV - Chan et al.
#####
# change directory
cd ../Scripts_postscripteps

Chan_010_ref="../../LBV_Methane/Chan/"$mech_dir_ref"/X_CO2_10/LBV.txt"
Chan_015_ref="../../LBV_Methane/Chan/"$mech_dir_ref"/X_CO2_15/LBV.txt"

Chan_010_full="../../LBV_Methane/Chan/"$mech_dir_full"/X_CO2_10/LBV.txt"
Chan_015_full="../../LBV_Methane/Chan/"$mech_dir_full"/X_CO2_15/LBV.txt"

echo 'Methane LBV validation => Chan et al.'
gnuplot -c LBV_CH4_Chan.gnu $Chan_010_ref $Chan_010_full $Chan_015_ref $Chan_015_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_CH4_Chan.eps
echo 'Done'


#####
# CH4-LBV - Kishore et al.
#####
# change directory
cd ../Scripts_postscripteps

Kishore_020_ref="../../LBV_Methane/Kishore/"$mech_dir_ref"/X_CO2_020/LBV.txt"
Kishore_040_ref="../../LBV_Methane/Kishore/"$mech_dir_ref"/X_CO2_040/LBV.txt"
Kishore_060_ref="../../LBV_Methane/Kishore/"$mech_dir_ref"/X_CO2_060/LBV.txt"

Kishore_020_full="../../LBV_Methane/Kishore/"$mech_dir_full"/X_CO2_020/LBV.txt"
Kishore_040_full="../../LBV_Methane/Kishore/"$mech_dir_full"/X_CO2_040/LBV.txt"
Kishore_060_full="../../LBV_Methane/Kishore/"$mech_dir_full"/X_CO2_060/LBV.txt"

echo 'Methane LBV validation => Kishore et al.'
gnuplot -c LBV_CH4_Kishore.gnu $Kishore_020_ref $Kishore_020_full $Kishore_040_ref $Kishore_040_full $Kishore_060_ref $Kishore_060_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_CH4_Kishore.eps
echo 'Done'


#####
# CH4-LBV - Mazas et al.
#####
# change directory
cd ../Scripts_postscripteps

Mazas_020_ref="../../LBV_Methane/Mazas/"$mech_dir_ref"/X_CO2_20/LBV.txt"
Mazas_040_ref="../../LBV_Methane/Mazas/"$mech_dir_ref"/X_CO2_40/LBV.txt"

Mazas_020_full="../../LBV_Methane/Mazas/"$mech_dir_full"/X_CO2_20/LBV.txt"
Mazas_040_full="../../LBV_Methane/Mazas/"$mech_dir_full"/X_CO2_40/LBV.txt"

echo 'Methane LBV validation => Mazas et al.'
gnuplot -c LBV_CH4_Mazas.gnu $Mazas_020_ref $Mazas_020_full $Mazas_040_ref $Mazas_040_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_CH4_Mazas.eps
echo 'Done'


#####
# C2H2-LBV - 1atm
#####
# change directory
cd ../Scripts_postscripteps

ITV_BASE="../../LBV_Acetylene/Jamaas/"$mech_dir_ref"/T298K/LBV.txt"
ITV_Intermediate="../../LBV_Acetylene/Jamaas/"$mech_dir_full"/T298K/LBV.txt"

echo 'Acetylene LBV validation'
gnuplot -c LBV_C2H2.gnu $ITV_BASE $ITV_Intermediate
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_C2H2.eps
echo 'Done'


#####
# C2H4-IDT - Xiong et al.
#####
# change directory
cd ../Scripts_postscripteps

Xiong_Set4_ref="../../IDT_Ethylene/Xiong/"$mech_dir_ref"/Set_4/IDT.txt"
Xiong_Set5_ref="../../IDT_Ethylene/Xiong/"$mech_dir_ref"/Set_5/IDT.txt"
Xiong_Set6_ref="../../IDT_Ethylene/Xiong/"$mech_dir_ref"/Set_6/IDT.txt"
Xiong_Set4_full="../../IDT_Ethylene/Xiong/"$mech_dir_full"/Set_4/IDT.txt"
Xiong_Set5_full="../../IDT_Ethylene/Xiong/"$mech_dir_full"/Set_5/IDT.txt"
Xiong_Set6_full="../../IDT_Ethylene/Xiong/"$mech_dir_full"/Set_6/IDT.txt"
#Xiong_Set4="../../IDT_Ethylene/Xiong/"$mech_dir"/Set_4/IDT.txt"
#Xiong_Set5="../../IDT_Ethylene/Xiong/"$mech_dir"/Set_5/IDT.txt"
#Xiong_Set6="../../IDT_Ethylene/Xiong/"$mech_dir"/Set_6/IDT.txt"

echo 'Ethylene IDT validation => Xiong et al.'
gnuplot -c IDT_C2H4_Xiong_Set_4.gnu $Xiong_Set4_ref $Xiong_Set4_full
gnuplot -c IDT_C2H4_Xiong_Set_5.gnu $Xiong_Set5_ref $Xiong_Set5_full
gnuplot -c IDT_C2H4_Xiong_Set_6.gnu $Xiong_Set6_ref $Xiong_Set6_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H4_Xiong_Set_4.eps
ps2pdf -dEPSCrop IDT_C2H4_Xiong_Set_5.eps
ps2pdf -dEPSCrop IDT_C2H4_Xiong_Set_6.eps
echo 'Done'


#####
# C2H4-IDT - Peng et al.
#####
# change directory
cd ../Scripts_postscripteps

Peng_Set1_ref="../../IDT_Ethylene/Peng/"$mech_dir_ref"/Set_1/IDT.txt"
Peng_Set3_ref="../../IDT_Ethylene/Peng/"$mech_dir_ref"/Set_3/IDT.txt"
Peng_Set5_ref="../../IDT_Ethylene/Peng/"$mech_dir_ref"/Set_5/IDT.txt"
Peng_Set1_full="../../IDT_Ethylene/Peng/"$mech_dir_full"/Set_1/IDT.txt"
Peng_Set3_full="../../IDT_Ethylene/Peng/"$mech_dir_full"/Set_3/IDT.txt"
Peng_Set5_full="../../IDT_Ethylene/Peng/"$mech_dir_full"/Set_5/IDT.txt"
#Peng_Set1="../../IDT_Ethylene/Peng/"$mech_dir"/Set_1/IDT.txt"
#Peng_Set3="../../IDT_Ethylene/Peng/"$mech_dir"/Set_3/IDT.txt"
#Peng_Set5="../../IDT_Ethylene/Peng/"$mech_dir"/Set_5/IDT.txt"

echo 'Ethylene IDT validation => Peng et al.'
gnuplot -c IDT_C2H4_Peng_Set_1.gnu $Peng_Set1_ref $Peng_Set1_full
gnuplot -c IDT_C2H4_Peng_Set_3.gnu $Peng_Set3_ref $Peng_Set3_full
gnuplot -c IDT_C2H4_Peng_Set_5.gnu $Peng_Set5_ref $Peng_Set5_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H4_Peng_Set_1.eps
ps2pdf -dEPSCrop IDT_C2H4_Peng_Set_3.eps
ps2pdf -dEPSCrop IDT_C2H4_Peng_Set_5.eps
echo 'Done'


#####
# C2H4-LBV - 1atm
#####
# change directory
cd ../Scripts_postscripteps

ITV_BASE="../../LBV_Ethylene/Kumaar/"$mech_dir_ref"/T298K/LBV.txt"
ITV_Intermediate="../../LBV_Ethylene/Kumaar/"$mech_dir_full"/T298K/LBV.txt"

echo 'Ethylene LBV validation'
gnuplot -c LBV_C2H4.gnu $ITV_BASE $ITV_Intermediate
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_C2H4.eps
echo 'Done'


#####
# C2H6-IDT - Lu et al.
#####
# change directory
cd ../Scripts_postscripteps

Lu_LP_ref="../../IDT_Ethane/Lu/"$mech_dir_ref"/LP/IDT.txt"
Lu_HP_ref="../../IDT_Ethane/Lu/"$mech_dir_ref"/HP/IDT.txt"
Lu_LP_full="../../IDT_Ethane/Lu/"$mech_dir_full"/LP/IDT.txt"
Lu_HP_full="../../IDT_Ethane/Lu/"$mech_dir_full"/HP/IDT.txt"
#Lu_LP="../../IDT_Ethane/Lu/"$mech_dir"/LP/IDT.txt"
#Lu_HP="../../IDT_Ethane/Lu/"$mech_dir"/HP/IDT.txt"

echo 'Ethylene IDT validation => Lu et al.'
gnuplot -c IDT_C2H6_Lu.gnu $Lu_LP_ref $Lu_HP_ref $Lu_LP_full $Lu_HP_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H6_Lu.eps
echo 'Done'


#####
# C2H6-IDT - Liu et al.
#####
# change directory
cd ../Scripts_postscripteps

Liu_HP_Lean_30_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/30perCO2/IDT.txt"
Liu_HP_Lean_60_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/60perCO2/IDT.txt"
Liu_HP_Lean_86_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/86perCO2/IDT.txt"
Liu_HP_Stoi_04_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Stoi/4perFuel/IDT.txt"
Liu_HP_Stoi_02_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Stoi/2perFuel/IDT.txt"
Liu_HP_Rich_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/HP/Rich/IDT.txt"

Liu_HP_Lean_30_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/30perCO2/IDT.txt"
Liu_HP_Lean_60_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/60perCO2/IDT.txt"
Liu_HP_Lean_86_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/86perCO2/IDT.txt"
Liu_HP_Stoi_04_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Stoi/4perFuel/IDT.txt"
Liu_HP_Stoi_02_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Stoi/2perFuel/IDT.txt"
Liu_HP_Rich_full="../../IDT_Ethane/Liu/"$mech_dir_full"/HP/Rich/IDT.txt"

#Liu_HP_Lean_30="../../IDT_Ethane/Liu/"$mech_dir"/HP/Lean/30perCO2/IDT.txt"
#Liu_HP_Lean_60="../../IDT_Ethane/Liu/"$mech_dir"/HP/Lean/60perCO2/IDT.txt"
#Liu_HP_Lean_86="../../IDT_Ethane/Liu/"$mech_dir"/HP/Lean/86perCO2/IDT.txt"
#Liu_HP_Stoi_04="../../IDT_Ethane/Liu/"$mech_dir"/HP/Stoi/4perFuel/IDT.txt"
#Liu_HP_Stoi_02="../../IDT_Ethane/Liu/"$mech_dir"/HP/Stoi/2perFuel/IDT.txt"
#Liu_HP_Rich="../../IDT_Ethane/Liu/"$mech_dir"/HP/Rich/IDT.txt"


Liu_LP_Lean_30_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/30perCO2/IDT.txt"
Liu_LP_Lean_60_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/60perCO2/IDT.txt"
Liu_LP_Lean_86_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/86perCO2/IDT.txt"
Liu_LP_Stoi_04_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Stoi/4perFuel/IDT.txt"
Liu_LP_Stoi_02_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Stoi/2perFuel/IDT.txt"
Liu_LP_Rich_ref="../../IDT_Ethane/Liu/"$mech_dir_ref"/LP/Rich/IDT.txt"

Liu_LP_Lean_30_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/30perCO2/IDT.txt"
Liu_LP_Lean_60_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/60perCO2/IDT.txt"
Liu_LP_Lean_86_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/86perCO2/IDT.txt"
Liu_LP_Stoi_04_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Stoi/4perFuel/IDT.txt"
Liu_LP_Stoi_02_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Stoi/2perFuel/IDT.txt"
Liu_LP_Rich_full="../../IDT_Ethane/Liu/"$mech_dir_full"/LP/Rich/IDT.txt"

#Liu_LP_Lean_30="../../IDT_Ethane/Liu/"$mech_dir"/LP/Lean/30perCO2/IDT.txt"
#Liu_LP_Lean_60="../../IDT_Ethane/Liu/"$mech_dir"/LP/Lean/60perCO2/IDT.txt"
#Liu_LP_Lean_86="../../IDT_Ethane/Liu/"$mech_dir"/LP/Lean/86perCO2/IDT.txt"
#Liu_LP_Stoi_04="../../IDT_Ethane/Liu/"$mech_dir"/LP/Stoi/4perFuel/IDT.txt"
#Liu_LP_Stoi_02="../../IDT_Ethane/Liu/"$mech_dir"/LP/Stoi/2perFuel/IDT.txt"
#Liu_LP_Rich="../../IDT_Ethane/Liu/"$mech_dir"/LP/Rich/IDT.txt"

echo 'Ethylene IDT validation => Liu et al.'
gnuplot -c IDT_C2H6_Liu_Lean_30perCO2.gnu $Liu_LP_Lean_30_ref $Liu_HP_Lean_30_ref $Liu_LP_Lean_30_full $Liu_HP_Lean_30_full
gnuplot -c IDT_C2H6_Liu_Lean_60perCO2.gnu $Liu_LP_Lean_60_ref $Liu_HP_Lean_60_ref $Liu_LP_Lean_60_full $Liu_HP_Lean_60_full
gnuplot -c IDT_C2H6_Liu_Lean_86perCO2.gnu $Liu_LP_Lean_86_ref $Liu_HP_Lean_86_ref $Liu_LP_Lean_86_full $Liu_HP_Lean_86_full
gnuplot -c IDT_C2H6_Liu_Stoi_04perFuel.gnu $Liu_LP_Stoi_04_ref $Liu_HP_Stoi_04_ref $Liu_LP_Stoi_04_full $Liu_HP_Stoi_04_full
gnuplot -c IDT_C2H6_Liu_Stoi_02perFuel.gnu $Liu_LP_Stoi_02_ref $Liu_HP_Stoi_02_ref $Liu_LP_Stoi_02_full $Liu_HP_Stoi_02_full
gnuplot -c IDT_C2H6_Liu_Rich.gnu $Liu_LP_Rich_ref $Liu_HP_Rich_ref $Liu_LP_Rich_full $Liu_HP_Rich_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_30perCO2.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_60perCO2.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_86perCO2.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Stoi_04perFuel.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Stoi_02perFuel.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Rich.eps
echo 'Done'


#####
# CH3OH-LBV - Naucler et al.
#####
# change directory
cd ../Scripts_postscripteps

Naucler_T308_ref="../../LBV_Methanol/Naucler/"$mech_dir_ref"/T308K/LBV.txt"
#Naucler_T318_ref="../../LBV_Methanol/Naucler/"$mech_dir_ref"/T318K/LBV.txt"
Naucler_T328_ref="../../LBV_Methanol/Naucler/"$mech_dir_ref"/T328K/LBV.txt"
#Naucler_T338_ref="../../LBV_Methanol/Naucler/"$mech_dir_ref"/T338K/LBV.txt"
Naucler_T358_ref="../../LBV_Methanol/Naucler/"$mech_dir_ref"/T358K/LBV.txt"
Naucler_T308_full="../../LBV_Methanol/Naucler/"$mech_dir_full"/T308K/LBV.txt"
#Naucler_T318_full="../../LBV_Methanol/Naucler/"$mech_dir_full"/T318K/LBV.txt"
Naucler_T328_full="../../LBV_Methanol/Naucler/"$mech_dir_full"/T328K/LBV.txt"
#Naucler_T338_full="../../LBV_Methanol/Naucler/"$mech_dir_full"/T338K/LBV.txt"
Naucler_T358_full="../../LBV_Methanol/Naucler/"$mech_dir_full"/T358K/LBV.txt"
#Naucler_T308="../../LBV_Methanol/Naucler/"$mech_dir"/T308K/LBV.txt"
#Naucler_T318="../../LBV_Methanol/Naucler/"$mech_dir"/T318K/LBV.txt"
#Naucler_T328="../../LBV_Methanol/Naucler/"$mech_dir"/T328K/LBV.txt"
#Naucler_T338="../../LBV_Methanol/Naucler/"$mech_dir"/T338K/LBV.txt"
#Naucler_T358="../../LBV_Methanol/Naucler/"$mech_dir"/T358K/LBV.txt"

echo 'Methanol LBV validation => Naucler et al.'
gnuplot -c LBV_CH3OH_Naucler.gnu $Naucler_T308_ref $Naucler_T308_full $Naucler_T328_ref $Naucler_T328_full $Naucler_T358_ref $Naucler_T358_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_CH3OH_Naucler.eps
echo 'Done'


#####
# C2H5OH-LBV - Naucler et al.
#####
# change directory
cd ../Scripts_postscripteps

Naucler_T298_ref="../../LBV_Ethanol/Naucler/"$mech_dir_ref"/T298K/LBV.txt"
Naucler_T318_ref="../../LBV_Ethanol/Naucler/"$mech_dir_ref"/T318K/LBV.txt"
Naucler_T338_ref="../../LBV_Ethanol/Naucler/"$mech_dir_ref"/T338K/LBV.txt"
Naucler_T298_full="../../LBV_Ethanol/Naucler/"$mech_dir_full"/T298K/LBV.txt"
Naucler_T318_full="../../LBV_Ethanol/Naucler/"$mech_dir_full"/T318K/LBV.txt"
Naucler_T338_full="../../LBV_Ethanol/Naucler/"$mech_dir_full"/T338K/LBV.txt"

echo 'Ethanol LBV validation => Naucler et al.'
gnuplot -c LBV_C2H5OH_Naucler.gnu $Naucler_T298_ref $Naucler_T298_full $Naucler_T318_ref $Naucler_T318_full $Naucler_T338_ref $Naucler_T338_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop LBV_C2H5OH_Naucler.eps
echo 'Done'


#####
# OXYFLAME
#####
# change directory
cd ../Scripts_postscripteps

mech_dir_ref="ITV_LimingCai2019"
Koroglu_Lean_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/LP/IDT.txt"
Koroglu_Stoi_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/LP/IDT.txt"
Koroglu_Rich_LP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/LP/IDT.txt"

Koroglu_Lean_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/HP/IDT.txt"
Koroglu_Stoi_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/HP/IDT.txt"
Koroglu_Rich_HP_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/HP/IDT.txt"

Koroglu_Stoi_XCO2_ref="../../IDT_Methane/Koroglu/"$mech_dir_ref"/X_CO2_060/IDT.txt"

echo 'Methane IDT validation => Koroglu et al. (OXYFLAME)'
gnuplot -c OXYFLAME_IDT_CH4_Koroglu_Lean.gnu $Koroglu_Lean_LP_ref $Koroglu_Lean_HP_ref
gnuplot -c OXYFLAME_IDT_CH4_Koroglu_Rich.gnu $Koroglu_Rich_LP_ref $Koroglu_Rich_HP_ref
gnuplot -c OXYFLAME_IDT_CH4_Koroglu_Stoi.gnu $Koroglu_Stoi_LP_ref $Koroglu_Stoi_HP_ref
gnuplot -c OXYFLAME_IDT_CH4_Koroglu_Stoi_XCO2_060.gnu $Koroglu_Stoi_XCO2_ref
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop B1b_LCai_IDT_CH4_Koroglu_Lean.eps
ps2pdf -dEPSCrop B1b_LCai_IDT_CH4_Koroglu_Rich.eps
ps2pdf -dEPSCrop B1b_LCai_IDT_CH4_Koroglu_Stoi.eps
ps2pdf -dEPSCrop B1b_LCai_IDT_CH4_Koroglu_Stoi_XCO2_060.eps
echo 'Done'



# merge all pdf's
rm Merged.pdf
pdfunite *.pdf Merged.pdf
