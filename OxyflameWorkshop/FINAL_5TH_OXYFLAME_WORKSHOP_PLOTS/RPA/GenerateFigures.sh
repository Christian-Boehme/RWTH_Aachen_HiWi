#!/usr/bin bash

lim=1
echo 'Tolerance is:'
echo $lim

# store data
mkdir -p MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim
mkdir -p COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim
mkdir -p WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim

mkdir -p OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim
mkdir -p OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim
mkdir -p OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
mkdir -p OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim


# go to script
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Scripts/ElementBasedReactionFluxAnalysis
rm -rf Output/*

# use Bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

# run
echo 'MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim 


# use Coal-kinetics
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py

echo 'COL_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim 


# use Bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

echo 'WS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased_Limit_$lim 


# Oxyflame Workshop
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py

echo 'Oxyflame Workshop: COLOMBIAN_AIR20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim 


cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py
echo 'Oxyflame Workshop: MISCANTHUS_AIR20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim 

echo 'Oxyflame Workshop: WALNUT_AIR20'
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased_Limit_$lim
python3 FluxAnalysis.py -L_RPA ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased/ElementFluxesN.csv -IntRRates ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased/TimeIntegratedNetReactionRate.csv -target NO -species C5H5N,NH3,HCN,N2 -limit $lim -NodeColor HCN='#500dbab1',NH3='#500dbab1',C5H5N=orange   
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/RPA/Single/OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased_Limit_$lim 

