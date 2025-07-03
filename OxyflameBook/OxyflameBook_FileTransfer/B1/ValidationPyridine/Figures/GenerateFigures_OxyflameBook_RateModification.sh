#!usr/bin bash

# kinetic model
mech_dir_ref="ITV-Base-Chemistry_CRECK"
mech_dir_full="ITV-Base-Chemistry_FullGlarborg_C5H5Nmodule"
#mech_dir_full="ITV-Base-Chemistry_RedGlarborg_C5H5Nmodule"
mech_dir="ITV-Base-Chemistry_ModFullGlarborg_C5H5Nmodule/"
#mech_dir="ITV-Base-Chemistry_ModRedGlarborg_C5H5Nmodule/"


# create output directory
mkdir -p figures_OxyflameBook

# PYRIDINE VALIDATION
#####
# Alzueta
#####
# change directory
cd Scripts_OxyflameBook

Reference="../../Validation_Pyridine/Alzueta/"$mech_dir_ref"/"
Full="../../Validation_Pyridine/Alzueta/"$mech_dir_full"/"
Skeletal="../../Validation_Pyridine/Alzueta/"$mech_dir"/"

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

gnuplot -c Alzueta_NO_Set1.gnu $Reference1 $Full1 $Skeletal1
gnuplot -c Alzueta_NO_Set2.gnu $Reference2 $Full2 $Skeletal2
gnuplot -c Alzueta_NO_Set3.gnu $Reference3 $Full3 $Skeletal3
gnuplot -c Alzueta_NO_Set4.gnu $Reference4 $Full4 $Skeletal4
gnuplot -c Alzueta_NO_Set5.gnu $Reference5 $Full5 $Skeletal5
gnuplot -c Alzueta_NO_Set6.gnu $Reference6 $Full6 $Skeletal6
gnuplot -c Alzueta_NO_Set7.gnu $Reference7 $Full7 $Skeletal7
gnuplot -c Alzueta_NO_Set8.gnu $Reference8 $Full8 $Skeletal8

#gnuplot -c Alzueta_N2O_Set1.gnu $Reference1 $Full1 $Skeletal1
#gnuplot -c Alzueta_N2O_Set2.gnu $Reference2 $Full2 $Skeletal2
#gnuplot -c Alzueta_N2O_Set3.gnu $Reference3 $Full3 $Skeletal3
#gnuplot -c Alzueta_N2O_Set4.gnu $Reference4 $Full4 $Skeletal4
#gnuplot -c Alzueta_N2O_Set5.gnu $Reference5 $Full5 $Skeletal5
#gnuplot -c Alzueta_N2O_Set6.gnu $Reference6 $Full6 $Skeletal6
#gnuplot -c Alzueta_N2O_Set7.gnu $Reference7 $Full7 $Skeletal7
#gnuplot -c Alzueta_N2O_Set8.gnu $Reference8 $Full8 $Skeletal8

echo 'Convert eps to pdf'
cd ../figures_OxyflameBook
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
ps2pdf -dEPSCrop Alzueta_NO_Set1.eps
ps2pdf -dEPSCrop Alzueta_NO_Set2.eps
ps2pdf -dEPSCrop Alzueta_NO_Set3.eps
ps2pdf -dEPSCrop Alzueta_NO_Set4.eps
ps2pdf -dEPSCrop Alzueta_NO_Set5.eps
ps2pdf -dEPSCrop Alzueta_NO_Set6.eps
ps2pdf -dEPSCrop Alzueta_NO_Set7.eps
ps2pdf -dEPSCrop Alzueta_NO_Set8.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set1.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set2.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set3.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set4.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set5.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set6.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set7.eps
#ps2pdf -dEPSCrop Alzueta_N2O_Set8.eps
echo 'Done'


######
## Wu et al. - Lean
######
## change directory
#cd ../Scripts_postscripteps
#
#Reference="../../Validation_Pyridine/Wu_Lean/"$mech_dir_ref"/Molefraction.txt"
#Full="../../Validation_Pyridine/Wu_Lean/"$mech_dir_full"/Molefraction.txt"
#Skeletal="../../Validation_Pyridine/Wu_Lean/"$mech_dir"/Molefraction.txt"
#
#echo 'Generating plots => Wu et al. - Lean'
#gnuplot -c Wu_Lean_C2H2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_C4H5N.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_CH2CO.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_CH4.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_CO.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_H2O.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_HNCO.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_N2O.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_NO.gnu $Reference $Full $Skeletal                                                 
##gnuplot -c Wu_Lean_C3H3N.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_C5H5N.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_C5H5N_Appendix.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_CH2O.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_CO2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_H2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_HCN.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_N2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_NH3.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Lean_O2.gnu $Reference $Full $Skeletal
#echo 'Convert eps to pdf'
#cd ../figures_postscripteps
#ps2pdf -dEPSCrop Wu_Lean_C2H2.eps
#ps2pdf -dEPSCrop Wu_Lean_C4H5N.eps
#ps2pdf -dEPSCrop Wu_Lean_CH2CO.eps
#ps2pdf -dEPSCrop Wu_Lean_CH4.eps
#ps2pdf -dEPSCrop Wu_Lean_CO.eps
#ps2pdf -dEPSCrop Wu_Lean_H2O.eps
#ps2pdf -dEPSCrop Wu_Lean_HNCO.eps
#ps2pdf -dEPSCrop Wu_Lean_N2O.eps
#ps2pdf -dEPSCrop Wu_Lean_NO.eps
#ps2pdf -dEPSCrop Wu_Lean_C5H5N.eps
#ps2pdf -dEPSCrop Wu_Lean_CH2O.eps
#ps2pdf -dEPSCrop Wu_Lean_CO2.eps
#ps2pdf -dEPSCrop Wu_Lean_H2.eps
#ps2pdf -dEPSCrop Wu_Lean_HCN.eps
#ps2pdf -dEPSCrop Wu_Lean_N2.eps
#ps2pdf -dEPSCrop Wu_Lean_NH3.eps
#ps2pdf -dEPSCrop Wu_Lean_O2.eps
#echo 'Done'
#
#
#
######
## Wu et al. - Rich
######
## change directory
#cd ../Scripts_postscripteps
#
#Reference="../../Validation_Pyridine/Wu_Rich/"$mech_dir_ref"/Molefraction.txt"
#Full="../../Validation_Pyridine/Wu_Rich/"$mech_dir_full"/Molefraction.txt"
#Skeletal="../../Validation_Pyridine/Wu_Rich/"$mech_dir"/Molefraction.txt"
#
#echo 'Generating plots => Wu et al. - Rich'
##gnuplot -c Wu_Rich_AC3H4.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_C2H4.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_C5H5N.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CH2CO.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CH3CHO.gnu $Reference $Full $Skeletal
##gnuplot -c Wu_Rich_CH3OH.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CO.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_HNC.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_NH3.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_O2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_C2H2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_C4H5N.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CH2CHCN.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CH2O.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CH3CN.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_CO2.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_HCN.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_N2O.gnu $Reference $Full $Skeletal
#gnuplot -c Wu_Rich_NO.gnu $Reference $Full $Skeletal
##gnuplot -c Wu_Rich_PC3H4.gnu $Reference $Full $Skeletal
#echo 'Convert eps to pdf'
#cd ../figures_postscripteps
##ps2pdf -dEPSCrop Wu_Rich_AC3H4.eps
#ps2pdf -dEPSCrop Wu_Rich_C2H4.eps
#ps2pdf -dEPSCrop Wu_Rich_C5H5N.eps
#ps2pdf -dEPSCrop Wu_Rich_CH2CO.eps
#ps2pdf -dEPSCrop Wu_Rich_CH3CHO.eps
##ps2pdf -dEPSCrop Wu_Rich_CH3OH.eps
#ps2pdf -dEPSCrop Wu_Rich_CO.eps
#ps2pdf -dEPSCrop Wu_Rich_HNC.eps
#ps2pdf -dEPSCrop Wu_Rich_NH3.eps
#ps2pdf -dEPSCrop Wu_Rich_O2.eps
#ps2pdf -dEPSCrop Wu_Rich_C2H2.eps
#ps2pdf -dEPSCrop Wu_Rich_C4H5N.eps
#ps2pdf -dEPSCrop Wu_Rich_CH2CHCN.eps
#ps2pdf -dEPSCrop Wu_Rich_CH2O.eps
#ps2pdf -dEPSCrop Wu_Rich_CH3CN.eps
#ps2pdf -dEPSCrop Wu_Rich_CO2.eps
#ps2pdf -dEPSCrop Wu_Rich_HCN.eps
#ps2pdf -dEPSCrop Wu_Rich_N2O.eps
#ps2pdf -dEPSCrop Wu_Rich_NO.eps
##ps2pdf -dEPSCrop Wu_Rich_PC3H4.eps
#echo 'Done'



# post-process
cd ../figures_OxyflameBook
#rm Merged.pdf
pdfunite *.pdf Merged.pdf
cd ../
mkdir -p figures_OxyflameBook_Reduced
rm -rf figures_OxyflameBook_Reduced/*
mv figures_OxyflameBook/* figures_OxyflameBook_Reduced
rm -rf figures_OxyflameBook

# TODO
#- do wu simulations!
#- cp to RWTH Master thesis
