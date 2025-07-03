#!usr/bin bash

mech_dir="FINAL_SKELETAL_ITV_BIOMASS"     			# Solid line
# IDT
mech_dir_IDT_full="ITVPelucchi2015"				# Dashed line
mech_dir_IDT_ref="Pelucchi2015" 				# Dashed line
# Anisole oxidation
mech_dir_AO_full="ITVCoalMech1049" 				# Dotted line
mech_dir_AO_ref="Full_LLNLAnisole"				# Dashed line
# Cellulose pyrolysis
mech_dir_CP_full="FullITVBio1079"				# Dotted line
mech_dir_CP_ref="FullCRECKBio532"				# Dashed line


#####
# LATEX
#####
# change directory
#cd ../LATEX

Reference_CO2F="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_ref"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Full_CO2F="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_full"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Skeletal_CO2F="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"

Reference_CO2O="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_ref"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Full_CO2O="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir_AO_full"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Skeletal_CO2O="../../../../ITVCoalMechanism/AnisoleOxidation/"$mech_dir"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"

echo 'Generating plots => Chen et al.'
gnuplot -c Figure_6a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_6f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O

./compile
./convert2pdf.sh
rm Merged.pdf
pdfunite *.pdf Merged.pdf
