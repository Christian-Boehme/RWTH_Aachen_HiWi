#!usr/bin bash

# kinetic model
mech_dir_ref="Glarborg2018"
mech_dir_full="ITVDetailed_NOx"
mech_dir="ITVCompact_NOx"

# create output directory
mkdir -p figures_postscripteps


# GLARBORG 2018
#####
# HNCO (Glarborg2018: Fig.20)
#####
# change directory
cd Scripts_postscripteps

ref_N="../SimulationData/"$mech_dir_ref"/PlotHNCO_FR_1.txt"
ref_C="../SimulationData/"$mech_dir_ref"/PlotHNCO_FR_2.txt"
full_N="../SimulationData/"$mech_dir_full"/PlotHNCO_FR_1.txt"
full_C="../SimulationData/"$mech_dir_full"/PlotHNCO_FR_2.txt"
skeletal_N="../SimulationData/"$mech_dir"/PlotHNCO_FR_1.txt"
skeletal_C="../SimulationData/"$mech_dir"/PlotHNCO_FR_2.txt"

echo 'Generating plots => HNCO'
gnuplot -c Glarborg2018_HNCO_CPollutants.gnu $ref_C $full_C $skeletal_C $lw_ref $lw_full $lw_mod
gnuplot -c Glarborg2018_HNCO_NPollutants.gnu $ref_N $full_N $skeletal_N
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_HNCO_CPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_HNCO_NPollutants.eps
echo 'DONE'


#####
# RapReNOx (Glarborg2018: Fig.37)
#####
# change directory
cd ../Scripts_postscripteps

ref_N="../SimulationData/"$mech_dir_ref"/PlotRapReNOx_FR_1.txt"
ref_C="../SimulationData/"$mech_dir_ref"/PlotRapReNOx_FR_2.txt"
full_N="../SimulationData/"$mech_dir_full"/PlotRapReNOx_FR_1.txt"
full_C="../SimulationData/"$mech_dir_full"/PlotRapReNOx_FR_2.txt"
skeletal_N="../SimulationData/"$mech_dir"/PlotRapReNOx_FR_1.txt"
skeletal_C="../SimulationData/"$mech_dir"/PlotRapReNOx_FR_2.txt"

echo 'Generating plots => RapReNOx'
gnuplot -c Glarborg2018_RapReNOx_CPollutants.gnu $ref_C $full_C $skeletal_C
gnuplot -c Glarborg2018_RapReNOx_NPollutants.gnu $ref_N $full_N $skeletal_N
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_RapReNOx_CPollutants.eps
ps2pdf -dEPSCrop Glarborg2018_RapReNOx_NPollutants.eps
echo 'DONE'


#####
# ThermalDeNOx (Glarborg2018: Fig.33)
#####
# change directory
cd ../Scripts_postscripteps

ref_JSR="../SimulationData/"$mech_dir_ref"/PlotThermalDeNOx_JSR.txt"
ref_10="../SimulationData/"$mech_dir_ref"/PlotThermalDeNOx_FR_1.txt"
ref_50="../SimulationData/"$mech_dir_ref"/PlotThermalDeNOx_FR_2.txt"
full_JSR="../SimulationData/"$mech_dir_full"/PlotThermalDeNOx_JSR.txt"
full_10="../SimulationData/"$mech_dir_full"/PlotThermalDeNOx_FR_1.txt"
full_50="../SimulationData/"$mech_dir_full"/PlotThermalDeNOx_FR_2.txt"
skeletal_JSR="../SimulationData/"$mech_dir"/PlotThermalDeNOx_JSR.txt"
skeletal_10="../SimulationData/"$mech_dir"/PlotThermalDeNOx_FR_1.txt"
skeletal_50="../SimulationData/"$mech_dir"/PlotThermalDeNOx_FR_2.txt"

echo 'Generating plots => ThermalDeNOx'
gnuplot -c Glarborg2018_ThermalDeNOx_O20.gnu $ref_JSR $full_JSR $skeletal_JSR
gnuplot -c Glarborg2018_ThermalDeNOx_O210.gnu $ref_10 $full_10 $skeletal_10
gnuplot -c Glarborg2018_ThermalDeNOx_O250.gnu $ref_50 $full_50 $skeletal_50
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_ThermalDeNOx_O20.eps
ps2pdf -dEPSCrop Glarborg2018_ThermalDeNOx_O210.eps
ps2pdf -dEPSCrop Glarborg2018_ThermalDeNOx_O250.eps
echo 'DONE'


#####
# NOxOut (Glarborg2018: Fig.38(JSR))
#####
# change directory
cd ../Scripts_postscripteps

ref="../SimulationData/"$mech_dir_ref"/PlotNOxOut_JSR_1.txt"
full="../SimulationData/"$mech_dir_full"/PlotNOxOut_JSR_1.txt"
skeletal="../SimulationData/"$mech_dir"/PlotNOxOut_JSR_1.txt"

echo 'Generating plots => NOxOut'
gnuplot -c Glarborg2018_NOxOut.gnu $ref $full $skeletal
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_NOxOut.eps
echo 'DONE'


#####
# N2O-NNH: NO from NNH (Glarborg2018: Fig.16)
#####
# change directory
cd ../Scripts_postscripteps

ref_N2O="../SimulationData/"$mech_dir_ref"/PlotN2O_JSR_2.txt"
ref_NO="../SimulationData/"$mech_dir_ref"/PlotN2O_JSR_1.txt"
full_N2O="../SimulationData/"$mech_dir_full"/PlotN2O_JSR_2.txt"
full_NO="../SimulationData/"$mech_dir_full"/PlotN2O_JSR_1.txt"
skeletal_N2O="../SimulationData/"$mech_dir"/PlotN2O_JSR_2.txt"
skeletal_NO="../SimulationData/"$mech_dir"/PlotN2O_JSR_1.txt"

echo 'Generating plots => N2O-NNH'
gnuplot -c Glarborg2018_N2O_NNH.gnu $ref_N2O $ref_NO $full_N2O $full_NO $skeletal_N2O $skeletal_NO
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_N2O_NNH.eps
echo 'DONE'


#####
# Thermal (Glarborg2018: Fig.???)
#####
# change directory
cd ../Scripts_postscripteps

ref="../SimulationData/"$mech_dir_ref"/PlotThermal_ST_Lean.txt"
full="../SimulationData/"$mech_dir_full"/PlotThermal_ST_Lean.txt"
skeletal="../SimulationData/"$mech_dir"/PlotThermal_ST_Lean.txt"

echo 'Generating plots => Thermal'
gnuplot -c Glarborg2018_Thermal.gnu $ref $full $skeletal
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_Thermal.eps
echo 'DONE'


#####
# NH3 (Glarborg2018: Fig.29)
#####
# change directory
cd ../Scripts_postscripteps

ref_lean="../SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_1.txt"
ref_stoich="../SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_2.txt"
ref_rich="../SimulationData/"$mech_dir_ref"/PlotAmmonia_FR_3.txt"
full_lean="../SimulationData/"$mech_dir_full"/PlotAmmonia_FR_1.txt"
full_stoich="../SimulationData/"$mech_dir_full"/PlotAmmonia_FR_2.txt"
full_rich="../SimulationData/"$mech_dir_full"/PlotAmmonia_FR_3.txt"
skeletal_lean="../SimulationData/"$mech_dir"/PlotAmmonia_FR_1.txt"
skeletal_stoich="../SimulationData/"$mech_dir"/PlotAmmonia_FR_2.txt"
skeletal_rich="../SimulationData/"$mech_dir"/PlotAmmonia_FR_3.txt"

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
# Prompt (Glarborg2018: Fig 10a and 11a)
#####
# change directory
cd ../Scripts_postscripteps

ref_CH="../SimulationData/"$mech_dir_ref"/CHPlotLam1.txt"
ref_NO="../SimulationData/"$mech_dir_ref"/CHPlotLam2.txt"
ref_NOR="../SimulationData/"$mech_dir_ref"/CHPlotLam_NORich.txt"
full_CH="../SimulationData/"$mech_dir_full"/CHPlotLam1.txt"
full_NO="../SimulationData/"$mech_dir_full"/CHPlotLam2.txt"
full_NOR="../SimulationData/"$mech_dir_full"/CHPlotLam_NORich.txt"
skeletal_CH="../SimulationData/"$mech_dir"/CHPlotLam1.txt"
skeletal_NO="../SimulationData/"$mech_dir"/CHPlotLam2.txt"
skeletal_NOR="../SimulationData/"$mech_dir"/CHPlotLam_NORich.txt"

echo 'Generating plots => Prompt'
gnuplot -c Glarborg2018_Prompt_CH.gnu $ref_CH $full_CH $skeletal_CH
gnuplot -c Glarborg2018_Prompt_NO.gnu $ref_NO $ref_NOR $full_NO $full_NOR $skeletal_NO $skeletal_NOR
echo 'Convert eps to pdf'
cd ../figures_postscripteps
ps2pdf -dEPSCrop Glarborg2018_Prompt_CH.eps
ps2pdf -dEPSCrop Glarborg2018_Prompt_NO.eps
echo 'DONE'


#####
# HCN (Glarborg2018: Fig 18 a+b)
#####
# change directory
cd ../Scripts_postscripteps

ref_wCO_CPollutants="../SimulationData/"$mech_dir_ref"/PlotHCN_FR_3.txt"
ref_woCO_CPollutants="../SimulationData/"$mech_dir_ref"/PlotHCN_FR_4.txt"
ref_wCO_NPollutants="../SimulationData/"$mech_dir_ref"/PlotHCN_FR_2.txt"
ref_woCO_NPollutants="../SimulationData/"$mech_dir_ref"/PlotHCN_FR_1.txt"
full_wCO_CPollutants="../SimulationData/"$mech_dir_full"/PlotHCN_FR_3.txt"
full_woCO_CPollutants="../SimulationData/"$mech_dir_full"/PlotHCN_FR_4.txt"
full_wCO_NPollutants="../SimulationData/"$mech_dir_full"/PlotHCN_FR_2.txt"
full_woCO_NPollutants="../SimulationData/"$mech_dir_full"/PlotHCN_FR_1.txt"
skeletal_wCO_CPollutants="../SimulationData/"$mech_dir"/PlotHCN_FR_3.txt"
skeletal_woCO_CPollutants="../SimulationData/"$mech_dir"/PlotHCN_FR_4.txt"
skeletal_wCO_NPollutants="../SimulationData/"$mech_dir"/PlotHCN_FR_2.txt"
skeletal_woCO_NPollutants="../SimulationData/"$mech_dir"/PlotHCN_FR_1.txt"

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

# post-process
cd ../figures_postscripteps
rm Merged.pdf
pdfunite *.pdf Merged.pdf

