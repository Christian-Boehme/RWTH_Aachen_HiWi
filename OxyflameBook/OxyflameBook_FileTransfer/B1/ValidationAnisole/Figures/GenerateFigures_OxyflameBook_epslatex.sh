#!usr/bin bash

# kinetic model
mech_dir="ITV_CoalBiomass_compact" #"FINAL_SKELETAL_ITV_COAL"  		# Solid line
mech_dir_full="ITVCoalMech1049" 			# Dotted line
mech_dir_ref="Full_LLNLAnisole"				# Dashed line

# create output-dir
mkdir -p figures_OxyflameBook_epslatex

######
## IDT
######
## change directory
#cd Scripts_OxyflameBook
#
#Reference_Lean="../../IDT_Anisole/"$mech_dir_ref"/Lean/1atm/IDT.txt"
#Full_Lean="../../IDT_Anisole/"$mech_dir_full"/Lean/1atm/IDT.txt"
#Skeletal_Lean="../../IDT_Anisole/"$mech_dir"/Lean/1atm/IDT.txt"
#
#Reference_Stoichiometric="../../IDT_Anisole/"$mech_dir_ref"/Stoichiometric/1atm/IDT.txt"
#Full_Stoichiometric="../../IDT_Anisole/"$mech_dir_full"/Stoichiometric/1atm/IDT.txt"
#Skeletal_Stoichiometric="../../IDT_Anisole/"$mech_dir"/Stoichiometric/1atm/IDT.txt"
#
#Reference_Rich="../../IDT_Anisole/"$mech_dir_ref"/Rich/1atm/IDT.txt"
#Full_Rich="../../IDT_Anisole/"$mech_dir_full"/Rich/1atm/IDT.txt"
#Skeletal_Rich="../../IDT_Anisole/"$mech_dir"/Rich/1atm/IDT.txt"
#
#echo 'Generating plots => IDT'
#gnuplot -c IDT_Lean_1atm.gnu $Reference_Lean $Full_Lean $Skeletal_Lean
#gnuplot -c IDT_Stoichiometric_1atm.gnu $Reference_Stoichiometric $Full_Stoichiometric $Skeletal_Stoichiometric
#gnuplot -c IDT_Rich_1atm.gnu $Reference_Rich $Full_Rich $Skeletal_Rich
## Oxyflame
#gnuplot -c OXYFLAME_IDT_Lean_1atm.gnu $Reference_Lean $Full_Lean $Skeletal_Lean
#gnuplot -c OXYFLAME_IDT_Stoichiometric_1atm.gnu $Reference_Stoichiometric $Full_Stoichiometric $Skeletal_Stoichiometric
#gnuplot -c OXYFLAME_IDT_Rich_1atm.gnu $Reference_Rich $Full_Rich $Skeletal_Rich
#echo 'Convert eps to pdf'
#cd ../figures_OxyflameBook
#ps2pdf -dEPSCrop IDT_Lean_1atm.eps
#ps2pdf -dEPSCrop IDT_Stoichiometric_1atm.eps
#ps2pdf -dEPSCrop IDT_Rich_1atm.eps
## Oxyflame
#ps2pdf -dEPSCrop B1b_Coal_IDT_Lean_1atm.eps
#ps2pdf -dEPSCrop B1b_Coal_IDT_Stoichiometric_1atm.eps
#ps2pdf -dEPSCrop B1b_Coal_IDT_Rich_1atm.eps
#echo 'Done'


#####
# Chen et al.
#####
# change directory
cd Scripts_OxyflameBook_epslatex

Reference_CO2F="../../AnisoleOxidation/"$mech_dir_ref"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Full_CO2F="../../AnisoleOxidation/"$mech_dir_full"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"
Skeletal_CO2F="../../AnisoleOxidation/"$mech_dir"/CO2F-Flame/C6H5OCH3_p01a00075tf0433to0313.csv"

Reference_CO2O="../../AnisoleOxidation/"$mech_dir_ref"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Full_CO2O="../../AnisoleOxidation/"$mech_dir_full"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"
Skeletal_CO2O="../../AnisoleOxidation/"$mech_dir"/CO2O-Flame/C6H5OCH3_p01a00072tf0433to0313.csv"

echo 'Generating plots => Chen et al.'
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
gnuplot -c Figure_7h.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
#gnuplot -c Figure_7i.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_8a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8c.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8d.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8e.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8f.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8g.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_8h.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
#gnuplot -c Figure_8i.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_9a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_9b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_10a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_10b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_12a.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_12b.gnu $Reference_CO2F $Full_CO2F $Skeletal_CO2F
gnuplot -c Figure_13a.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
gnuplot -c Figure_13b.gnu $Reference_CO2O $Full_CO2O $Skeletal_CO2O
echo 'Convert eps to pdf'


# post-process 
cp compile ../figures_OxyflameBook_epslatex
cp convert2pdf.sh ../figures_OxyflameBook_epslatex

cd ../figures_OxyflameBook_epslatex

./compile
./convert2pdf.sh
rm Merged.pdf
pdfunite *.pdf Merged.pdf
