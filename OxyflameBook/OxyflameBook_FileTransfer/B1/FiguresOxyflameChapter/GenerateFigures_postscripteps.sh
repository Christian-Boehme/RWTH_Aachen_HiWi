#!usr/bin bash


##########
# BASE-CHEMISTRY
##########
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

X_CO2_025_ref="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_025/IDT.txt"
X_CO2_050_ref="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_050/IDT.txt"
X_CO2_075_ref="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_ref"/X_CO2_075/IDT.txt"
X_CO2_025_full="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_025/IDT.txt"
X_CO2_050_full="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_050/IDT.txt"
X_CO2_075_full="../../ValidationBaseChemistry/IDT_Methane/HargisAndPetersen/"$mech_dir_full"/X_CO2_075/IDT.txt"

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
# CH4-IDT - Koroglu et al.
#####
# change directory
cd ../Scripts_postscripteps

Koroglu_Lean_LP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/LP/IDT.txt"
Koroglu_Lean_LP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Lean/LP/IDT.txt"
#Koroglu_Lean_LP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Lean/LP/IDT.txt"
Koroglu_Stoi_LP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/LP/IDT.txt"
Koroglu_Stoi_LP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Stoichiometric/LP/IDT.txt"
#Koroglu_Stoi_LP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Stoichiometric/LP/IDT.txt"
Koroglu_Rich_LP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/LP/IDT.txt"
Koroglu_Rich_LP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Rich/LP/IDT.txt"
#Koroglu_Rich_LP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Rich/LP/IDT.txt"

Koroglu_Lean_HP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Lean/HP/IDT.txt"
Koroglu_Lean_HP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Lean/HP/IDT.txt"
#Koroglu_Lean_HP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Lean/HP/IDT.txt"
Koroglu_Stoi_HP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Stoichiometric/HP/IDT.txt"
Koroglu_Stoi_HP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Stoichiometric/HP/IDT.txt"
#Koroglu_Stoi_HP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Stoichiometric/HP/IDT.txt"
Koroglu_Rich_HP_ref="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_ref"/Rich/HP/IDT.txt"
Koroglu_Rich_HP_full="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir_full"/Rich/HP/IDT.txt"
#Koroglu_Rich_HP="../../ValidationBaseChemistry/IDT_Methane/Koroglu/"$mech_dir"/Rich/HP/IDT.txt"

echo 'Methane IDT validation => Koroglu et al.'
gnuplot -c IDT_CH4_Koroglu_Lean.gnu $Koroglu_Lean_LP_ref $Koroglu_Lean_HP_ref $Koroglu_Lean_LP_full $Koroglu_Lean_HP_full $Koroglu_Lean_LP
gnuplot -c IDT_CH4_Koroglu_Rich.gnu $Koroglu_Rich_LP_ref $Koroglu_Rich_HP_ref $Koroglu_Rich_LP_full $Koroglu_Rich_HP_full $Koroglu_Rich_LP
gnuplot -c IDT_CH4_Koroglu_Stoi.gnu $Koroglu_Stoi_LP_ref $Koroglu_Stoi_HP_ref $Koroglu_Stoi_LP_full $Koroglu_Stoi_HP_full $Koroglu_Stoi_LP
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Lean.eps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Rich.eps
ps2pdf -dEPSCrop IDT_CH4_Koroglu_Stoi.eps
echo 'Done'


#####
# C2H4-IDT - Peng et al.
#####
# change directory
cd ../Scripts_postscripteps

Peng_Set1_ref="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir_ref"/Set_1/IDT.txt"
Peng_Set3_ref="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir_ref"/Set_3/IDT.txt"
Peng_Set1_full="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir_full"/Set_1/IDT.txt"
Peng_Set3_full="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir_full"/Set_3/IDT.txt"
#Peng_Set1="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir"/Set_1/IDT.txt"
#Peng_Set3="../../ValidationBaseChemistry/IDT_Ethylene/Peng/"$mech_dir"/Set_3/IDT.txt"

echo 'Ethylene IDT validation => Peng et al.'
gnuplot -c IDT_C2H4_Peng_Set_1.gnu $Peng_Set1_ref $Peng_Set1_full
gnuplot -c IDT_C2H4_Peng_Set_3.gnu $Peng_Set3_ref $Peng_Set3_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H4_Peng_Set_1.eps
ps2pdf -dEPSCrop IDT_C2H4_Peng_Set_3.eps
echo 'Done'


#####
# C2H6-IDT - Liu et al.
#####
# change directory
cd ../Scripts_postscripteps

Liu_HP_Lean_30_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/30perCO2/IDT.txt"
Liu_HP_Lean_60_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/60perCO2/IDT.txt"
Liu_HP_Lean_86_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/HP/Lean/86perCO2/IDT.txt"

Liu_HP_Lean_30_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/30perCO2/IDT.txt"
Liu_HP_Lean_60_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/60perCO2/IDT.txt"
Liu_HP_Lean_86_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/HP/Lean/86perCO2/IDT.txt"

#Liu_HP_Lean_30="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir"/HP/Lean/30perCO2/IDT.txt"
#Liu_HP_Lean_60="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir"/HP/Lean/60perCO2/IDT.txt"
#Liu_HP_Lean_86="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir"/HP/Lean/86perCO2/IDT.txt"

Liu_LP_Lean_30_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/30perCO2/IDT.txt"
Liu_LP_Lean_60_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/60perCO2/IDT.txt"
Liu_LP_Lean_86_ref="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_ref"/LP/Lean/86perCO2/IDT.txt"

Liu_LP_Lean_30_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/30perCO2/IDT.txt"
Liu_LP_Lean_60_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/60perCO2/IDT.txt"
Liu_LP_Lean_86_full="../../ValidationBaseChemistry/IDT_Ethane/Liu/"$mech_dir_full"/LP/Lean/86perCO2/IDT.txt"

echo 'Ethylene IDT validation => Liu et al.'
gnuplot -c IDT_C2H6_Liu_Lean_30perCO2.gnu $Liu_LP_Lean_30_ref $Liu_HP_Lean_30_ref $Liu_LP_Lean_30_full $Liu_HP_Lean_30_full
gnuplot -c IDT_C2H6_Liu_Lean_60perCO2.gnu $Liu_LP_Lean_60_ref $Liu_HP_Lean_60_ref $Liu_LP_Lean_60_full $Liu_HP_Lean_60_full
gnuplot -c IDT_C2H6_Liu_Lean_86perCO2.gnu $Liu_LP_Lean_86_ref $Liu_HP_Lean_86_ref $Liu_LP_Lean_86_full $Liu_HP_Lean_86_full
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_30perCO2.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_60perCO2.eps
ps2pdf -dEPSCrop IDT_C2H6_Liu_Lean_86perCO2.eps
echo 'Done'





##########
# IDT Propyon
##########
mech_dir="FINAL_SKELETAL_ITV_BIOMASS"     			# Solid line
# IDT
mech_dir_IDT_full="ITVPelucchi2015"				# Dashed line
mech_dir_IDT_ref="Pelucchi2015" 				# Dashed line

# change directory
cd ../Scripts_postscripteps

Reference_Lean_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_ref"/Lean/1.25atm/IDT.txt"
Full_Lean_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_full"/Lean/1.25atm/IDT.txt"
Skeletal_Lean_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir"/Lean/1.25atm/IDT.txt"
Reference_Lean_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir_IDT_ref"/IDT.txt"
Full_Lean_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Lean_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir"/IDT.txt"


Reference_Stoichiometric_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_ref"/Stoichiometric/1.22atm/IDT.txt"
Full_Stoichiometric_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_full"/Stoichiometric/1.22atm/IDT.txt"
Skeletal_Stoichiometric_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir"/Stoichiometric/1.22atm/IDT.txt"
Reference_Stoichiometric_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir_IDT_ref"/IDT.txt"
Full_Stoichiometric_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Stoichiometric_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir"/IDT.txt"


Reference_Rich_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_ref"/Rich/1.21atm/IDT.txt"
Full_Rich_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir_IDT_full"/Rich/1.21atm/IDT.txt"
Skeletal_Rich_Pelucchi_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/"$mech_dir"/Rich/1.21atm/IDT.txt"
Reference_Rich_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir_IDT_ref"/IDT.txt"
Full_Rich_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Rich_AKB_exp="../../ValidationIDTPropionaldehyde/IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir"/IDT.txt"

echo 'Generating plots => IDT'
gnuplot -c IDT_Propanal_Lean.gnu $Reference_Lean_Pelucchi_exp $Reference_Lean_AKB_exp $Full_Lean_Pelucchi_exp $Full_Lean_AKB_exp $Skeletal_Lean_Pelucchi_exp $Skeletal_Lean_AKB_exp
gnuplot -c IDT_Propanal_Stoichiometric.gnu $Reference_Stoichiometric_Pelucchi_exp $Reference_Stoichiometric_AKB_exp $Full_Stoichiometric_Pelucchi_exp $Full_Stoichiometric_AKB_exp $Skeletal_Stoichiometric_Pelucchi_exp $Skeletal_Stoichiometric_AKB_exp
gnuplot -c IDT_Propanal_Rich.gnu $Reference_Rich_Pelucchi_exp $Reference_Rich_AKB_exp $Full_Rich_Pelucchi_exp $Full_Rich_AKB_exp $Skeletal_Rich_Pelucchi_exp $Skeletal_Rich_AKB_exp
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop IDT_Propanal_Lean.eps
ps2pdf -dEPSCrop IDT_Propanal_Stoichiometric.eps
ps2pdf -dEPSCrop IDT_Propanal_Rich.eps
echo 'Done'


##########
# Anisole oxidation
##########

# kinetic model
mech_dir="ITV_CoalBiomass_compact" #"FINAL_SKELETAL_ITV_COAL"  		# Solid line
mech_dir_full="ITVCoalMech1049" 			# Dotted line
mech_dir_ref="Full_LLNLAnisole"				# Dashed line

#####
# Chen et al.
#####
# change directory
cd ../Scripts_postscripteps

Reference_CO2F="../../ValidationAnisole/AnisoleOxidation/"$mech_dir_ref"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Full_CO2F="../../ValidationAnisole/AnisoleOxidation/"$mech_dir_full"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Skeletal_CO2F="../../ValidationAnisole/AnisoleOxidation/"$mech_dir"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"

Reference_CO2O="../../ValidationAnisole/AnisoleOxidation/"$mech_dir_ref"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Full_CO2O="../../ValidationAnisole/AnisoleOxidation/"$mech_dir_full"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Skeletal_CO2O="../../ValidationAnisole/AnisoleOxidation/"$mech_dir"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"

echo 'Generating plots => Chen et al.'
gnuplot -c Figure_6a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6c.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6d.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6e.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8c.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8d.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8e.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8g.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8h.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_8i.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_10b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Figure_6a.eps
ps2pdf -dEPSCrop Figure_6b.eps
ps2pdf -dEPSCrop Figure_6c.eps
ps2pdf -dEPSCrop Figure_6d.eps
ps2pdf -dEPSCrop Figure_6e.eps
ps2pdf -dEPSCrop Figure_6f.eps
ps2pdf -dEPSCrop Figure_8a.eps
ps2pdf -dEPSCrop Figure_8b.eps
ps2pdf -dEPSCrop Figure_8c.eps
ps2pdf -dEPSCrop Figure_8d.eps
ps2pdf -dEPSCrop Figure_8e.eps
ps2pdf -dEPSCrop Figure_8f.eps
ps2pdf -dEPSCrop Figure_8g.eps
ps2pdf -dEPSCrop Figure_8h.eps
#ps2pdf -dEPSCrop Figure_8i.eps
ps2pdf -dEPSCrop Figure_10b.eps
echo 'Done'


##########
# Rate modification: pyridine
##########

# kinetic model
mech_dir_ref="ITV-Base-Chemistry_CRECK"
mech_dir_full="ITV-Base-Chemistry_FullGlarborg_C5H5Nmodule"
mech_dir="ITV-Base-Chemistry_ModFullGlarborg_C5H5Nmodule/"

#####
# Alzueta
#####
# change directory
cd ../Scripts_postscripteps

Reference="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir_ref"/"
Full="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir_full"/"
Skeletal="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir"/"

Reference1=$Reference"Results_Set_1"
Reference2=$Reference"Results_Set_2"
Reference3=$Reference"Results_Set_3"
Reference4=$Reference"Results_Set_4"
Reference5=$Reference"Results_Set_5"
Reference6=$Reference"Results_Set_6"
Reference7=$Reference"Results_Set_7"
Reference8=$Reference"Results_Set_8"

Full1=$Full"Results_Set_1"
Full2=$Full"Results_Set_2"
Full3=$Full"Results_Set_3"
Full4=$Full"Results_Set_4"
Full5=$Full"Results_Set_5"
Full6=$Full"Results_Set_6"
Full7=$Full"Results_Set_7"
Full8=$Full"Results_Set_8"

Skeletal1=$Skeletal"Results_Set_1"
Skeletal2=$Skeletal"Results_Set_2"
Skeletal3=$Skeletal"Results_Set_3"
Skeletal4=$Skeletal"Results_Set_4"
Skeletal5=$Skeletal"Results_Set_5"
Skeletal6=$Skeletal"Results_Set_6"
Skeletal7=$Skeletal"Results_Set_7"
Skeletal8=$Skeletal"Results_Set_8"

echo 'Generating plots => Alzueta et al.'
#gnuplot -c Alzueta_C5H5N_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_C5H5N_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_C5H5N_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_C5H5N_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_C5H5N_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_C5H5N_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_C5H5N_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_C5H5N_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_CO2_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_CO2_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_CO2_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_CO2_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_CO2_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_CO2_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_CO2_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_CO2_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_CO_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_CO_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_CO_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_CO_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_CO_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_CO_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_CO_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_CO_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_HCN_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_HCN_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_HCN_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_HCN_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_HCN_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_HCN_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_HCN_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_HCN_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_NO_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_NO_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_NO_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_NO_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_NO_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_NO_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c RateModification_Alzueta_NO_Set7.gnu $Reference7 $Full7 $Skeletal7
gnuplot -c RateModification_Alzueta_NO_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_N2O_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_N2O_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_N2O_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_N2O_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_N2O_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_N2O_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_N2O_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_N2O_Set8.gnu $Reference8 $Full8 $Skeletal8

echo 'Convert eps to pdf'
cd ../figures_postscripteps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set1.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set2.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set3.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set4.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set5.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set6.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set7.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set8.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set1.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set2.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set3.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set4.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set5.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set6.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set7.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set8.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set1.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set2.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set3.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set4.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set5.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set6.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set7.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set8.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set1.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set2.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set3.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set4.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set5.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set6.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set7.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set8.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set1.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set2.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set3.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set4.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set5.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set6.eps
ps2pdf -dEPSCrop RateModification_Alzueta_NO_Set7.eps
ps2pdf -dEPSCrop RateModification_Alzueta_NO_Set8.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set1.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set2.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set3.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set4.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set5.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set6.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set7.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set8.eps
echo 'Done'


##########
# Glarborg
##########

# kinetic model
mech_dir_ref="Glarborg2018"
mech_dir_full="ITVDetailed_NOx"
mech_dir="ITVCompact_NOx"

#####
# HNCO (Glarborg2018: Fig.20)
#####
# change directory
cd ../Scripts_postscripteps

ref_N="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHNCO_FR_1.txt"
ref_C="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHNCO_FR_2.txt"
full_N="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHNCO_FR_1.txt"
full_C="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHNCO_FR_2.txt"
skeletal_N="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHNCO_FR_1.txt"
skeletal_C="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHNCO_FR_2.txt"

echo 'Generating plots => HNCO'
gnuplot -c Glarborg2018_HNCO_CPollutants.gnu $ref_C $full_C $skeletal_C $lw_ref $lw_full $lw_mod
gnuplot -c Glarborg2018_HNCO_NPollutants.gnu $ref_N $full_N $skeletal_N
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_HNCO_CPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_HNCO_NPollutants.eps
echo 'DONE'



#####
# NH3 (Glarborg2018: Fig.29)
#####
# change directory
cd ../Scripts_postscripteps

ref_lean="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_1.txt"
ref_stoich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_2.txt"
ref_rich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_3.txt"
full_lean="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotAmmonia_FR_1.txt"
full_stoich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotAmmonia_FR_2.txt"
full_rich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotAmmonia_FR_3.txt"
skeletal_lean="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotAmmonia_FR_1.txt"
skeletal_stoich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotAmmonia_FR_2.txt"
skeletal_rich="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotAmmonia_FR_3.txt"

echo 'Generating plots => NH3'
gnuplot -c Glarborg2018_NH3_Lean.gnu $ref_lean $full_lean $skeletal_lean
gnuplot -c Glarborg2018_NH3_Stoich.gnu $ref_stoich $full_stoich $skeletal_stoich
gnuplot -c Glarborg2018_NH3_Rich.gnu $ref_rich $full_rich $skeletal_rich
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_NH3_Lean.eps
ps2pdf -dEPSCrop Glarborg2018_NH3_Stoich.eps
ps2pdf -dEPSCrop Glarborg2018_NH3_Rich.eps
echo 'DONE'



#####
# HCN (Glarborg2018: Fig 18 a+b)
#####
# change directory
cd ../Scripts_postscripteps

ref_wCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHCN_FR_3.txt"
ref_woCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHCN_FR_4.txt"
ref_wCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHCN_FR_2.txt"
ref_woCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_ref"/PlotHCN_FR_1.txt"
full_wCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHCN_FR_3.txt"
full_woCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHCN_FR_4.txt"
full_wCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHCN_FR_2.txt"
full_woCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir_full"/PlotHCN_FR_1.txt"
skeletal_wCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHCN_FR_3.txt"
skeletal_woCO_CPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHCN_FR_4.txt"
skeletal_wCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHCN_FR_2.txt"
skeletal_woCO_NPollutants="../../ValidationGlarborg2018/Figures/SimulationData/"$mech_dir"/PlotHCN_FR_1.txt"

echo 'Generating plots => HCN'
gnuplot -c Glarborg2018_HCN_withCO_CPollutants.gnu $ref_wCO_CPollutants $full_wCO_CPollutants $skeletal_wCO_CPollutants
gnuplot -c Glarborg2018_HCN_withCO_NPollutants.gnu $ref_wCO_NPollutants $full_wCO_NPollutants $skeletal_wCO_NPollutants
gnuplot -c Glarborg2018_HCN_withoutCO_CPollutants.gnu $ref_woCO_CPollutants $full_woCO_CPollutants $skeletal_woCO_CPollutants
gnuplot -c Glarborg2018_HCN_withoutCO_NPollutants.gnu $ref_woCO_NPollutants $full_woCO_NPollutants $skeletal_woCO_NPollutants
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_HCN_withCO_CPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_HCN_withCO_NPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_HCN_withoutCO_CPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_HCN_withoutCO_NPollutants.eps
echo 'DONE'



##########
# Pyridine- Reduced
##########
# kinetic model
mech_dir_ref="ITV-Base-Chemistry_CRECK"
mech_dir_full="ITV-Base-Chemistry_ExtrModRedGlarborg_C5H5Nmodule"
mech_dir="Final_ITVCompact_ExtrModRedGlarborg_C5H5Nmodule"

#####
# Alzueta
#####
# change directory
cd ../Scripts_postscripteps

Reference="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir_ref"/"
Full="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir_full"/"
Skeletal="../../ValidationPyridine/Validation_Pyridine/Alzueta/"$mech_dir"/"

Reference1=$Reference"Results_Set_1"
Reference2=$Reference"Results_Set_2"
Reference3=$Reference"Results_Set_3"
Reference4=$Reference"Results_Set_4"
Reference5=$Reference"Results_Set_5"
Reference6=$Reference"Results_Set_6"
Reference7=$Reference"Results_Set_7"
Reference8=$Reference"Results_Set_8"

Full1=$Full"Results_Set_1"
Full2=$Full"Results_Set_2"
Full3=$Full"Results_Set_3"
Full4=$Full"Results_Set_4"
Full5=$Full"Results_Set_5"
Full6=$Full"Results_Set_6"
Full7=$Full"Results_Set_7"
Full8=$Full"Results_Set_8"

Skeletal1=$Skeletal"Results_Set_1"
Skeletal2=$Skeletal"Results_Set_2"
Skeletal3=$Skeletal"Results_Set_3"
Skeletal4=$Skeletal"Results_Set_4"
Skeletal5=$Skeletal"Results_Set_5"
Skeletal6=$Skeletal"Results_Set_6"
Skeletal7=$Skeletal"Results_Set_7"
Skeletal8=$Skeletal"Results_Set_8"

echo 'Generating plots => Alzueta et al.'
#gnuplot -c Alzueta_C5H5N_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_C5H5N_Set2.gnu $Reference2 $Full2 $Skeletal2
gnuplot -c Alzueta_C5H5N_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_C5H5N_Set4.gnu $Reference4 $Full4 $Skeletal4
gnuplot -c Alzueta_C5H5N_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_C5H5N_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c Alzueta_C5H5N_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_C5H5N_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_CO2_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_CO2_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_CO2_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_CO2_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_CO2_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_CO2_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_CO2_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_CO2_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_CO_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_CO_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_CO_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_CO_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_CO_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_CO_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_CO_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_CO_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_HCN_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_HCN_Set2.gnu $Reference2 $Full2 $Skeletal2
gnuplot -c Alzueta_HCN_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_HCN_Set4.gnu $Reference4 $Full4 $Skeletal4
gnuplot -c Alzueta_HCN_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_HCN_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c Alzueta_HCN_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_HCN_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_NO_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_NO_Set2.gnu $Reference2 $Full2 $Skeletal2
gnuplot -c Alzueta_NO_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_NO_Set4.gnu $Reference4 $Full4 $Skeletal4
gnuplot -c Alzueta_NO_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_NO_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c Alzueta_NO_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_NO_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_N2O_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_N2O_Set2.gnu $Reference2 $Full2 $Skeletal2
gnuplot -c Alzueta_N2O_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_N2O_Set4.gnu $Reference4 $Full4 $Skeletal4
gnuplot -c Alzueta_N2O_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_N2O_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c Alzueta_N2O_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_N2O_Set8.gnu $Reference8 $Full8 $Skeletal8

echo 'Convert eps to pdf'
cd ../figures_postscripteps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set1.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set2.eps
ps2pdf -dEPSCrop Alzueta_C5H5N_Set3.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set4.eps
ps2pdf -dEPSCrop Alzueta_C5H5N_Set5.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set6.eps
ps2pdf -dEPSCrop Alzueta_C5H5N_Set7.eps
#ps2pdf -dEPSCrop Alzueta_C5H5N_Set8.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set1.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set2.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set3.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set4.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set5.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set6.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set7.eps
#ps2pdf -dEPSCrop Alzueta_CO2_Set8.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set1.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set2.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set3.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set4.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set5.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set6.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set7.eps
#ps2pdf -dEPSCrop Alzueta_CO_Set8.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set1.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set2.eps
ps2pdf -dEPSCrop Alzueta_HCN_Set3.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set4.eps
ps2pdf -dEPSCrop Alzueta_HCN_Set5.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set6.eps
ps2pdf -dEPSCrop Alzueta_HCN_Set7.eps
#ps2pdf -dEPSCrop Alzueta_HCN_Set8.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set1.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set2.eps
ps2pdf -dEPSCrop Alzueta_NO_Set3.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set4.eps
ps2pdf -dEPSCrop Alzueta_NO_Set5.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set6.eps
ps2pdf -dEPSCrop Alzueta_NO_Set7.eps
#ps2pdf -dEPSCrop Alzueta_NO_Set8.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set1.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set2.eps
ps2pdf -dEPSCrop Alzueta_N2O_Set3.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set4.eps
ps2pdf -dEPSCrop Alzueta_N2O_Set5.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set6.eps
ps2pdf -dEPSCrop Alzueta_N2O_Set7.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set8.eps
echo 'Done'




# merge all pdf's
rm Merged.pdf
pdfunite *.pdf Merged.pdf
