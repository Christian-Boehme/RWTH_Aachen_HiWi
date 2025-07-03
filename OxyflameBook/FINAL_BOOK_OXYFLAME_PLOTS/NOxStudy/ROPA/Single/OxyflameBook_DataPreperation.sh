#!/usr/bin bash


############################################
# extract dominant reactions
############################################
# change directory
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/ElementBasedReactionFluxAnalysis
rm -rf Output/*
# Output folder
mkdir -p ../Data
rm -rf ../Data/*
# use bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVBioNOx.py core/Modification.py
Limit=0.001
Species=(NO) # N HNO NH N HCN NH3 C5H5N NH2 NCN)
# Single MIS 1500 AIR 21
case="MIS_Tgas_1500K_AIR_DP_82_O2_21"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/MIS_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="MIS_Tgas_1500K_AIR_DP_82_O2_21_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/MIS_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="MIS_Tgas_1500K_AIR_DP_82_O2_21_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/MIS_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data

# Single COL AIR 21
# use coal-kinetics
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVCoalNOx.py core/Modification.py
case="COL_Tgas_1500K_AIR_DP_82_O2_21"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/COL_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="COL_Tgas_1500K_AIR_DP_82_O2_21_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/COL_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="COL_Tgas_1500K_AIR_DP_82_O2_21_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameBook/Inputs/COL_Tgas_1500K_Dp_82_Air21_TotalDomain_ReactionRateAveraged/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data


