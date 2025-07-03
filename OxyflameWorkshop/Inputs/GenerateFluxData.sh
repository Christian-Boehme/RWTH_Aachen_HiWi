#!/usr/bin bash

# calculate element flux from ... to ... [ms]
start=0
JetEnd=238
SingleEnd=300
echo 'start time: '
echo $start
echo 'end time for Jet: '
echo $JetEnd
echo 'end time for Single: '
echo $SingleEnd

# create output folder
mkdir -p Single_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
mkdir -p Single_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased
mkdir -p Single_FVC0_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_FVC0_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_FVC0_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_FVC0_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_FVC0_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
mkdir -p Single_FVC0_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased
mkdir -p Single_FVC1_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_FVC1_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_FVC2_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_FVC2_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_COL_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_COL_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_WS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_WS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased

mkdir -p Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased
mkdir -p Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased
mkdir -p Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased
mkdir -p Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased
mkdir -p Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased
mkdir -p Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased


# change directory
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Scripts/ElementBasedReactionFluxAnalysis

# use Bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

# MIS
echo 'Single: MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: MIS_OXY_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_OXY20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_OXY20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: MIS_OXY_DP_90_O2_30'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_OXY30_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_MIS_OXY30_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased

echo 'Single: FVC0_MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: FVC0_MIS_OXY_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_OXY20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_OXY20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: FVC0_MIS_OXY_DP_90_O2_30'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_OXY30_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC0_MIS_OXY30_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC0_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased

echo 'Single: FVC1_MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC1_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC1_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC1_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC1_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: FVC2_MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC2_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC2_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/FVC2_MIS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_FVC2_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: OxyflameWorkshop - MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain_ReactionRateBased


# COAL
# use Coal-kinetics
cp core/MechanismDependentFunctions_ITVCoalNOx.py core/MechanismDependentFunctions.py

echo 'Single: COL_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_COL_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_COL_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: COL_OXY_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_COL_OXY20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_COL_OXY20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_COL_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: OxyflameWorkshop - COL_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain_ReactionRateBased


# WS
# use Bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

echo 'Single: WS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_WS_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_WS_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: WS_OXY_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_WS_OXY20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/DYN_WS_OXY20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_WS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased

echo 'Single: OxyflameWorkshop - WS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/SingleParticleSimulations/OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $SingleEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Single_OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain_ReactionRateBased

