#!/usr/bin bash

# calculate element flux
#cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/Inputs
#echo 'Calculate element flux => DOUBLE CHECK YOUR TIME INTERVAL!'
#bash GenerateFluxData.sh
#echo 'Element fluxes are calculated'

# INPUTS
ROPA_MIS_AIR_20="../Inputs/Jet_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv"
ROPA_MIS_OXY_20="../Inputs/Jet_MIS_OXY_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv"
ROPA_MIS_OXY_30="../Inputs/Jet_MIS_OXY_DP_90_O2_30/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv"
ROPA_MIS_AIR_20_SINGLE="../Inputs/Single_MIS_AIR_DP_90_O2_20/TotalDomain_ReactionRateBased/SpeciesElementFluxesN.csv"
FontSize=26

mkdir -p Figures_OxyflameBook

# change directory
cd ElementBasedReactionFluxAnalysis

# use bio-kinetics
cp core/MechanismDependentFunctions_ITVBioNOx.py core/MechanismDependentFunctions.py

############################################
echo 'Effect of combined atm-O2...'
#mkdir -p ../Figures_OxyflameBook/ROPA_EffectofCombined_atmO2/

python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -L_ROPA_2 $ROPA_MIS_OXY_20 -L_ROPA_3 $ROPA_MIS_OXY_30 -label_1 "Air-21" -label_2 "Oxy-21" -label_3 "Oxy-31" -legend_position "best" -limit 3.5 -species NO -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
cd Output
mv -f ROPA_NO.pdf ROPA_O2comb_TotalDomain_ReactionRateBased_NO.pdf
cd ..

python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -L_ROPA_2 $ROPA_MIS_OXY_20 -L_ROPA_3 $ROPA_MIS_OXY_30 -label_1 "Air-21" -label_2 "Oxy-21" -label_3 "Oxy-31" -legend_position "best" -limit 3.5 -species NH -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
cd Output
mv -f ROPA_NH.pdf ROPA_O2comb_TotalDomain_ReactionRateBased_NH.pdf
cd ..

echo 'Effect of combined atm-O2: DONE'
#mv -f Output ROPA_EffectofCombined_atmO2
#mv -f ROPA_EffectofCombined_atmO2 ../Figures_OxyflameBook/
mv Output/* ../Figures_OxyflameBook/


############################################
#echo 'Reference analysis...'
#mkdir -p ../Figures_OxyflameBook/ROPA_MIS_JET
#
#python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -limit 3.0 -species NO -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
#cd Output
#mv ROPA_NO.pdf ROPA_MIS_AIR_Dp_90_O2_20_TotalDomain_ReactionRateBased_NO.pdf
#cd ..
#
#python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -limit 3.0 -species N -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
#cd Output
#mv ROPA_N.pdf ROPA_MIS_AIR_Dp_90_O2_20_TotalDomain_ReactionRateBased_N.pdf
#cd ..
#
#echo 'Reference analysis DONE'
#mv -f Output ROPA_MIS_JET
#mv -f ROPA_MIS_JET ../Figures_OxyflameBook/
#
#
############################################
echo 'Particle/Particle interaction effect...'
#mkdir -p ../Figures_OxyflameBook/ROPA_group

# Total domain - time integrated & reaction rates based
python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -L_ROPA_2 $ROPA_MIS_AIR_20_SINGLE -label_1 "Group" -label_2 "Single" -legend_position "right" -limit 3.5 -species NO -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
cd Output
mv ROPA_NO.pdf ROPA_groupsingle_TotalDomain_ReactionRateBased_NO.pdf
cd ..
#python3 FluxAnalysis.py -L_ROPA_1 $ROPA_MIS_AIR_20 -L_ROPA_2 $ROPA_MIS_AIR_20_SINGLE -label_1 "Group" -label_2 "Single" -legend_position "best" -limit 3.5 -species NCO -rcs R754='#ff8c00',R755='#ff8c00',R796='#ff8c00' -fs $FontSize
#cd Output
#mv ROPA_NCO.pdf ROPA_groupsingle_TotalDomain_ReactionRateBased_NCO.pdf
#cd ..
echo 'Particle/Particle interaction effect DONE'
#mv -f Output ROPA_group
#mv -f ROPA_group ../Figures_OxyflameBook
mv Output/* ../Figures_OxyflameBook

############################################
cd ..
renamedFolder="Figures_OxyflameBook_FontSize${FontSize}"
mv Figures_OxyflameBook $renamedFolder
