#!/usr/bin bash


############################################
# calculate element flux
############################################
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs
#echo 'Calculate element flux => DOUBLE CHECK YOUR TIME INTERVAL!'
#bash GenerateFluxData.sh
#echo 'Element fluxes are calculated'
############################################


############################################
# extract dominant reactions
############################################
# change directory
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameWorkshop/ElementBasedReactionFluxAnalysis
rm -rf Output/*
# Output folder
mkdir -p ../Data
rm -rf ../Data/*
# use bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVBioNOx.py core/Modification.py
Limit=0.001
Species=(NO N HNO NH N HCN NH3 C5H5N NH2 NCN)
# Single MIS AIR 21
case="Single_MIS_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_MIS_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_MIS_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
# Single MIS OXY 21
case="Single_MIS_OXY_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_MIS_OXY_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_MIS_OXY_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
## Single MIS OXY 31
#case="Single_MIS_OXY_DP_90_O2_31"
#ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
#echo $case
#for i in ${Species[@]}; do
#    echo $i
#    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
#done
#mv Output $case
#mv $case ../Data
# Single WS AIR 21
case="Single_WS_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_WS_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_WS_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
# Single WS OXY 21
case="Single_WS_OXY_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_WS_OXY_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_WS_OXY_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data

# use coal-kinetics
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVCoalNOx.py core/Modification.py
# Single COL AIR 21
case="Single_COL_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_COL_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_COL_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
# Single COL OXY 21
case="Single_COL_OXY_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_COL_OXY_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_COL_OXY_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
############################################
# HIGH TEMPERATURE CASE
###########################################
# use coal-kinetics
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVCoalNOx.py core/Modification.py
# Single COL AIR 21
case="Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data


# use bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py
cp core/Modification_ITVBioNOx.py core/Modification.py
# Single MIS AIR 21
case="Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data
# Single WS AIR 21
case="Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20_Consumption"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -cons
done
mv Output $case
mv $case ../Data
case="Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20_Production"
ROPA1='~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv'
echo $case
for i in ${Species[@]}; do
    echo $i
    python3 FluxAnalysis.py -L_ROPA_1 $ROPA1 -species $i -limit $Limit -prod
done
mv Output $case
mv $case ../Data


