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
mkdir -p Jet_CRS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Jet_CRS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Jet_CRS_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased
mkdir -p Jet_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Jet_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Jet_MIS_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased
mkdir -p Jet_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Jet_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
#mkdir -p Jet_MIS_OXY_DP_90_O2_20/LastPlain_x288_MassFractionBased
mkdir -p Jet_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
mkdir -p Jet_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased
#mkdir -p Jet_MIS_OXY_DP_90_O2_30/LastPlain_x288_MassFractionBased
mkdir -p Jet_MSR_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Jet_MSR_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Jet_MSR_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased

mkdir -p Single_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
mkdir -p Single_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
mkdir -p Single_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
mkdir -p Single_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased

# change directory
cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Scripts/ElementBasedReactionFluxAnalysis

# use Bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

echo 'Jet: CRS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/CRS_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_CRS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/CRS_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_CRS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/CRS_AIR_DP_90_O2_20/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_CRS_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased

echo 'Jet: MIS_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased

#echo 'Jet: MIS_AIR_DP_90_O2_20_FVC0'
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC0/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC0/TotalDomain_MassFractionBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC0/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC0/TotalDomain_ReactionRateBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC0/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC0/LastPlain_x288_MassFractionBased

#echo 'Jet: MIS_AIR_DP_90_O2_20_FVC2'
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC2/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC2/TotalDomain_MassFractionBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC2/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC2/TotalDomain_ReactionRateBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_AIR_DP_90_O2_20_/FVC2/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_AIR_DP_90_O2_20_/FVC2/LastPlain_x288_MassFractionBased

echo 'Jet: MIS_OXY_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_20/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_20/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_20/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_20/LastPlain_x288_MassFractionBased

echo 'Jet: MIS_OXY_DP_90_O2_30'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_30/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_30/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_30/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased
#python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MIS_OXY_DP_90_O2_30/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
#mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MIS_OXY_DP_90_O2_30/LastPlain_x288_MassFractionBased

echo 'Jet: MSR_AIR_DP_90_O2_20'
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MSR_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MSR_AIR_DP_90_O2_20/TotalDomain_MassFractionBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MSR_AIR_DP_90_O2_20/TotalDomain/VolumetricAverageReactionRate.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MSR_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased
python3 FluxAnalysis.py -i ~/NHR/NOx_JETS_ICNC24/VolumetricAverageData/MSR_AIR_DP_90_O2_20/LastPlain_x288/VolumetricAverageMassFractions.txt -tstart $start -tend $JetEnd
mv Output/* ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs/Jet_MSR_AIR_DP_90_O2_20/LastPlain_x288_MassFractionBased


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

