#!usr/bin bash

#####
# Name of kinetic models
#####
mech_dir="FINAL_SKELETAL_ITV_BIOMASS"     		# Solid line
# IDT
mech_dir_IDT_full="ITVPelucchi2015"				# Dashed line
mech_dir_IDT_ref="Pelucchi2015" 				# Dashed line
# Anisole oxidation
mech_dir_AO_full="ITVCoalMech1049" 				# Dotted line
mech_dir_AO_ref="Full_LLNLAnisole"				# Dashed line
# Cellulose pyrolysis
mech_dir_CP_full="FullITVBio1079"				# Dotted line
mech_dir_CP_ref="FullCRECKBio532"				# Dashed line

# create output-dir
mkdir -p figures_epslatex

# change directory
cd Scripts_epslatex

######
# IDT
#####
#Reference_Lean_1atm="../../IDT_Propanal/"$mech_dir_IDT_ref"/Lean/1.00atm/IDT.txt"
#Full_Lean_1atm="../../IDT_Propanal/"$mech_dir_IDT_full"/Lean/1.00atm/IDT.txt"
#Skeletal_Lean_1atm="../../IDT_Propanal/"$mech_dir"/Lean/1.00atm/IDT.txt"
Reference_Lean_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_ref"/Lean/1.25atm/IDT.txt"
Full_Lean_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_full"/Lean/1.25atm/IDT.txt"
Skeletal_Lean_Pelucchi_exp="../../IDT_Propanal/"$mech_dir"/Lean/1.25atm/IDT.txt"
Reference_Lean_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir_IDT_ref"/IDT.txt"
Full_Lean_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Lean_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Lean/"$mech_dir"/IDT.txt"

#Reference_Stoichiometric="../../IDT_Propanal/"$mech_dir_IDT_ref"/Stoichiometric/1.00atm/IDT.txt"
#Full_Stoichiometric="../../IDT_Propanal/"$mech_dir_IDT_full"/Stoichiometric/1.00atm/IDT.txt"
#Skeletal_Stoichiometric="../../IDT_Propanal/"$mech_dir"/Stoichiometric/1.00atm/IDT.txt"
Reference_Stoichiometric_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_ref"/Stoichiometric/1.22atm/IDT.txt"
Full_Stoichiometric_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_full"/Stoichiometric/1.22atm/IDT.txt"
Skeletal_Stoichiometric_Pelucchi_exp="../../IDT_Propanal/"$mech_dir"/Stoichiometric/1.22atm/IDT.txt"
Reference_Stoichiometric_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir_IDT_ref"/IDT.txt"
Full_Stoichiometric_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Stoichiometric_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Stoichiometric/"$mech_dir"/IDT.txt"

#Reference_Rich="../../IDT_Propanal/"$mech_dir_IDT_ref"/Rich/1.00atm/IDT.txt"
#Full_Rich="../../IDT_Propanal/"$mech_dir_IDT_full"/Rich/1.00atm/IDT.txt"
#Skeletal_Rich="../../IDT_Propanal/"$mech_dir"/Rich/1.00atm/IDT.txt"
Reference_Rich_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_ref"/Rich/1.21atm/IDT.txt"
Full_Rich_Pelucchi_exp="../../IDT_Propanal/"$mech_dir_IDT_full"/Rich/1.21atm/IDT.txt"
Skeletal_Rich_Pelucchi_exp="../../IDT_Propanal/"$mech_dir"/Rich/1.21atm/IDT.txt"
Reference_Rich_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir_IDT_ref"/IDT.txt"
Full_Rich_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir_IDT_full"/IDT.txt"
Skeletal_Rich_AKB_exp="../../IDT_Propanal/IDT_Propanal_AkihKumgehAndBergthorson/Rich/"$mech_dir"/IDT.txt"

echo 'Generating plots => IDT'
gnuplot -c IDT_Propanal_Lean.gnu $Reference_Lean_Pelucchi_exp $Reference_Lean_AKB_exp $Full_Lean_Pelucchi_exp $Full_Lean_AKB_exp $Skeletal_Lean_Pelucchi_exp $Skeletal_Lean_AKB_exp
gnuplot -c IDT_Propanal_Stoichiometric.gnu $Reference_Stoichiometric_Pelucchi_exp $Reference_Stoichiometric_AKB_exp $Full_Stoichiometric_Pelucchi_exp $Full_Stoichiometric_AKB_exp $Skeletal_Stoichiometric_Pelucchi_exp $Skeletal_Stoichiometric_AKB_exp
gnuplot -c IDT_Propanal_Rich.gnu $Reference_Rich_Pelucchi_exp $Reference_Rich_AKB_exp $Full_Rich_Pelucchi_exp $Full_Rich_AKB_exp $Skeletal_Rich_Pelucchi_exp $Skeletal_Rich_AKB_exp


######
# Cellulose pyrolysis - full
#####
Reference_700C="../../CellulosePyrolysis/"$mech_dir_CP_ref"/700C/0DHomoReactor.txt"
Full_700C="../../CellulosePyrolysis/"$mech_dir_CP_full"/700C/0DHomoReactor.txt"

Reference_800C="../../CellulosePyrolysis/"$mech_dir_CP_ref"/800C/0DHomoReactor.txt"
Full_800C="../../CellulosePyrolysis/"$mech_dir_CP_full"/800C/0DHomoReactor.txt"

echo 'Generating plots => Cellulose pyrolysis (Experiments)'
gnuplot -c CellPyrExp_C2H4.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_C6H10O5.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_C6H6.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_CH3COCH3.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_CH4.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_CO2.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_CO.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C
gnuplot -c CellPyrExp_H2.gnu $Reference_700C $Reference_800C $Full_700C $Full_800C


######
# Cellulose pyrolysis - extracted
#####
Reference_700C="../../CellulosePyrolysis/"$mech_dir_CP_ref"/700C/0DHomoReactor_EXTRACTED.txt"
Full_700C="../../CellulosePyrolysis/"$mech_dir_CP_full"/700C/0DHomoReactor_EXTRACTED.txt"
Skeletal_700C="../../CellulosePyrolysis/"$mech_dir"/700C/0DHomoReactor_EXTRACTED.txt"

Reference_750C="../../CellulosePyrolysis/"$mech_dir_CP_ref"/750C/0DHomoReactor_EXTRACTED.txt"
Full_750C="../../CellulosePyrolysis/"$mech_dir_CP_full"/750C/0DHomoReactor_EXTRACTED.txt"
Skeletal_750C="../../CellulosePyrolysis/"$mech_dir"/750C/0DHomoReactor_EXTRACTED.txt"

Reference_800C="../../CellulosePyrolysis/"$mech_dir_CP_ref"/800C/0DHomoReactor_EXTRACTED.txt"
Full_800C="../../CellulosePyrolysis/"$mech_dir_CP_full"/800C/0DHomoReactor_EXTRACTED.txt"
Skeletal_800C="../../CellulosePyrolysis/"$mech_dir"/800C/0DHomoReactor_EXTRACTED.txt"

echo 'Generating plots => Cellulose pyrolysis (Model)'
gnuplot -c CellPyr_C2H4.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_CH3CHO.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C5H4O2.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C6H10O5.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C6H6O3.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_CH3OH.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_CO2.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_H2.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C2H5CHO.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C6H6.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_CH4.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_CO.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C

# Appendix
gnuplot -c CellPyr_C2H4_Appendix.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C6H6_Appendix.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C
gnuplot -c CellPyr_C6H10O5_Appendix.gnu $Reference_700C $Reference_750C $Reference_800C $Full_700C $Full_750C $Full_800C $Skeletal_700C $Skeletal_750C $Skeletal_800C


#####
# Chen et al.
#####
Reference_CO2F="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_ref"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Full_CO2F="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_full"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Skeletal_CO2F="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"

Reference_CO2O="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_ref"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Full_CO2O="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_full"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Skeletal_CO2O="../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"

echo 'Generating plots => Anisole oxidation'
gnuplot -c Figure_3a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_3b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_3c.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_3d.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_3e.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_3f.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_6a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6c.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6d.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6e.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_7a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7c.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7d.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7e.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7f.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7g.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
#gnuplot -c Figure_7h.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_7i.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_8a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8c.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8d.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8e.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8g.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_8h.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8i.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_9a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_9b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_10a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_10b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_12a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
#gnuplot -c Figure_12b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_13a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_13b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#Oxyflame
#gnuplot -c Figure_6a_OXYFLAME.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_6f_OXYFLAME.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_8b_OXYFLAME.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O

# compile
cp compile ../figures_epslatex
cp convert2pdf.sh ../figures_epslatex
cd ../figures_epslatex
./compile
./convert2pdf.sh
rm Merged.pdf
pdfunite *.pdf Merged.pdf
