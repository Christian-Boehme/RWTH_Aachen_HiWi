#!/usr/bin bash


# change directory
#cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameWorkshop/ElementBasedReactionFluxAnalysis
#rm -rf Output/*
# Output folder
Out="Figures_OxyflameWorkshop_Desired/"
mkdir -p Figures_OxyflameWorkshop_Desired
#rm -rf Figures_OxyflameWorkshop_Desired/*


# global
color="#ff8c00"
NOxReactions="N+O2=O+NO:${color},O+NO=N+O2:${color},N+OH=H+NO:${color},H+NO=N+OH:${color},N+NO=O+N2:${color},O+N2=N+NO:${color}"
Limit=2.5
Species=(NO)


############################################
# LOW-TEMPERATURE
echo 'Low Temperature ...' 
############################################
ROPA_COL_AIR="Data/Single_COL_AIR_DP_90_O2_20/"
ROPA_MIS_AIR="Data/Single_MIS_AIR_DP_90_O2_20/"
ROPA_WS_AIR="Data/Single_WS_AIR_DP_90_O2_20/"
ROPA_COL_AIR_Cons="Data/Single_COL_AIR_DP_90_O2_20_Consumption/"
ROPA_MIS_AIR_Cons="Data/Single_MIS_AIR_DP_90_O2_20_Consumption/"
ROPA_WS_AIR_Cons="Data/Single_WS_AIR_DP_90_O2_20_Consumption/"
ROPA_COL_AIR_Prod="Data/Single_COL_AIR_DP_90_O2_20_Production/"
ROPA_MIS_AIR_Prod="Data/Single_MIS_AIR_DP_90_O2_20_Production/"
ROPA_WS_AIR_Prod="Data/Single_WS_AIR_DP_90_O2_20_Production/"

folder="LowTemperature/"
out="${Out}${folder}Limit_${Limit}/"
mkdir -p $out
ROPA1=$ROPA_COL_AIR
ROPA2=$ROPA_MIS_AIR
ROPA3=$ROPA_WS_AIR
ROPA1c=$ROPA_COL_AIR_Cons
ROPA2c=$ROPA_MIS_AIR_Cons
ROPA3c=$ROPA_WS_AIR_Cons
ROPA1p=$ROPA_COL_AIR_Prod
ROPA2p=$ROPA_MIS_AIR_Prod
ROPA3p=$ROPA_WS_AIR_Prod
Label1="Coal"
Label2="MIS"
Label3="WS"

#echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    ROPA_1c="${ROPA1c}Data_${i}.csv"
    ROPA_2c="${ROPA2c}Data_${i}.csv"
    ROPA_3c="${ROPA3c}Data_${i}.csv"
    ROPA_1p="${ROPA1p}Data_${i}.csv"
    ROPA_2p="${ROPA2p}Data_${i}.csv"
    ROPA_3p="${ROPA3p}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions
    python3 CreateFigure.py -i1 $ROPA_1c -i2 $ROPA_2c -i3 $ROPA_3c -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -cons
    python3 CreateFigure.py -i1 $ROPA_1p -i2 $ROPA_2p -i3 $ROPA_3p -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -prod
done


############################################
# HIGH-TEMPERATURE
echo 'High Temperature ...'
############################################
ROPA_COL_AIR="Data/Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20/"
ROPA_MIS_AIR="Data/Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20/"
ROPA_WS_AIR="Data/Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20/"
ROPA_COL_AIR_Cons="Data/Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20_Consumption/"
ROPA_MIS_AIR_Cons="Data/Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20_Consumption/"
ROPA_WS_AIR_Cons="Data/Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20_Consumption/"
ROPA_COL_AIR_Prod="Data/Single_OxyflameWorkshop_COL_AIR_DP_90_O2_20_Production/"
ROPA_MIS_AIR_Prod="Data/Single_OxyflameWorkshop_MIS_AIR_DP_90_O2_20_Production/"
ROPA_WS_AIR_Prod="Data/Single_OxyflameWorkshop_WS_AIR_DP_90_O2_20_Production/"

folder="HighTemperature/"
out="${Out}${folder}Limit_${Limit}/"
mkdir -p $out
ROPA1=$ROPA_COL_AIR
ROPA2=$ROPA_MIS_AIR
ROPA3=$ROPA_WS_AIR
ROPA1c=$ROPA_COL_AIR_Cons
ROPA2c=$ROPA_MIS_AIR_Cons
ROPA3c=$ROPA_WS_AIR_Cons
ROPA1p=$ROPA_COL_AIR_Prod
ROPA2p=$ROPA_MIS_AIR_Prod
ROPA3p=$ROPA_WS_AIR_Prod
Label1="Coal"
Label2="MIS"
Label3="WS"

#echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    ROPA_1c="${ROPA1c}Data_${i}.csv"
    ROPA_2c="${ROPA2c}Data_${i}.csv"
    ROPA_3c="${ROPA3c}Data_${i}.csv"
    ROPA_1p="${ROPA1p}Data_${i}.csv"
    ROPA_2p="${ROPA2p}Data_${i}.csv"
    ROPA_3p="${ROPA3p}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions
    python3 CreateFigure.py -i1 $ROPA_1c -i2 $ROPA_2c -i3 $ROPA_3c -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -cons
    python3 CreateFigure.py -i1 $ROPA_1p -i2 $ROPA_2p -i3 $ROPA_3p -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions -prod
done
