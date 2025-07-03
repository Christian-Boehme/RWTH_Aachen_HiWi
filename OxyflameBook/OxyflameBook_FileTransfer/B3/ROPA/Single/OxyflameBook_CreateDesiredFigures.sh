#!/usr/bin bash


# change directory
#cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameWorkshop/ElementBasedReactionFluxAnalysis
#rm -rf Output/*
# Output folder
Out="Figures_OxyflameBook_Desired/"
mkdir -p Figures_OxyflameBook_Desired
#rm -rf Figures_OxyflameBook_Desired/*


# global
color="#ff8c00"
NOxReactions="N+O2=O+NO:${color},O+NO=N+O2:${color},N+OH=H+NO:${color},H+NO=N+OH:${color},N+NO=O+N2:${color},O+N2=N+NO:${color}"
Limit=1.0
Species=(NO)
FontSize=36

############################################
# ROPA: NO consumption and production
############################################
ROPA_COL_AIR_Cons="Data/COL_Tgas_1500K_AIR_DP_82_O2_21_Consumption/"
ROPA_MIS_AIR_Cons="Data/MIS_Tgas_1500K_AIR_DP_82_O2_21_Consumption/"
ROPA_COL_AIR_Prod="Data/COL_Tgas_1500K_AIR_DP_82_O2_21_Production/"
ROPA_MIS_AIR_Prod="Data/MIS_Tgas_1500K_AIR_DP_82_O2_21_Production/"

out="${Out}Limit_${Limit}/"
mkdir -p $out
ROPA1c=$ROPA_COL_AIR_Cons
ROPA2c=$ROPA_MIS_AIR_Cons
ROPA1p=$ROPA_COL_AIR_Prod
ROPA2p=$ROPA_MIS_AIR_Prod
Label1="Coal"
Label2="MIS"

#echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1c="${ROPA1c}Data_${i}.csv"
    ROPA_2c="${ROPA2c}Data_${i}.csv"
    ROPA_1p="${ROPA1p}Data_${i}.csv"
    ROPA_2p="${ROPA2p}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_2c -i2 $ROPA_1c -l1 $Label2 -l2 $Label1 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -cons -fs $FontSize -legend_pos="center left"
    python3 CreateFigure.py -i1 $ROPA_2p -i2 $ROPA_1p -l1 $Label2 -l2 $Label1 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -prod -fs $FontSize -legend_pos="lower right"
done

