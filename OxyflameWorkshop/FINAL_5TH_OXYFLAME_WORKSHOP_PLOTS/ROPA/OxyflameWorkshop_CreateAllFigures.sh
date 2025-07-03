#!/usr/bin bash


# change directory
#cd ~/NHR/NOx_JETS_ICNC24/Post/FluxAnalysis/ROPA_OxyflameWorkshop/ElementBasedReactionFluxAnalysis
#rm -rf Output/*
# Output folder
Out="Figures_OxyflameWorkshop_Total/"
mkdir -p Figures_OxyflameWorkshop_Total
rm -rf Figures_OxyflameWorkshop_Total/*


# global
color="#ff8c00"
NOxReactions="N+O2=O+NO:${color},O+NO=N+O2:${color},N+OH=H+NO:${color},H+NO=N+OH:${color},N+NO=O+N2:${color},O+N2=N+NO:${color}"
Limit=2
Species=(NO N HNO NH N HCN NH3 C5H5N NH2 NCN)

# inputs
ROPA_COL_AIR="Data/Single_COL_AIR_DP_90_O2_20/"
ROPA_COL_OXY="Data/Single_COL_OXY_DP_90_O2_20/"
ROPA_MIS_AIR="Data/Single_MIS_AIR_DP_90_O2_20/"
ROPA_MIS_OXY="Data/Single_MIS_OXY_DP_90_O2_20/"
ROPA_WS_AIR="Data/Single_WS_AIR_DP_90_O2_20/"
ROPA_WS_OXY="Data/Single_WS_OXY_DP_90_O2_20/"


############################################
echo 'Effect of fuel type...' 
############################################
folder="EffectOfFuelType/"
# AIR
case="AIR"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_COL_AIR
ROPA2=$ROPA_MIS_AIR
ROPA3=$ROPA_WS_AIR
Label1="COL"
Label2="MIS"
Label3="WS"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out -rcs $NOxReactions
done


# OXY
case="OXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_COL_OXY
ROPA2=$ROPA_MIS_OXY
ROPA3=$ROPA_WS_OXY
Label1="COL"
Label2="MIS"
Label3="WS"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -l1 $Label1 -l2 $Label2 -l3 $Label3 -species $i -lim $Limit -outdir $out
done


# AIR and OXY
case="AIRandOXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_COL_AIR
ROPA2=$ROPA_COL_OXY
ROPA3=$ROPA_MIS_AIR
ROPA4=$ROPA_MIS_OXY
ROPA5=$ROPA_WS_AIR
ROPA6=$ROPA_WS_OXY
Label1="COL:AIR"
Label2="COL:OXY"
Label3="MIS:AIR"
Label4="MIS:OXY"
Label5="WS:AIR"
Label6="WS:OXY"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    ROPA_4="${ROPA4}Data_${i}.csv"
    ROPA_5="${ROPA5}Data_${i}.csv"
    ROPA_6="${ROPA6}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -i4 $ROPA_4 -i5 $ROPA_5 -i6 $ROPA_6 -l1 $Label1 -l2 $Label2 -l3 $Label3 -l4 $Label4 -l5 $Label5 -l6 $Label6 -species $i -lim $Limit -outdir $out
done


echo 'Effect of fuel type: DONE'
############################################



############################################
echo 'Effect of biomass fuel type...' 
############################################
folder="EffectOfBiomassFuelType/"
# AIR
case="AIR"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_MIS_AIR
ROPA2=$ROPA_WS_AIR
Label1="MIS"
Label2="WS"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -l1 $Label1 -l2 $Label2 -species $i -lim $Limit -outdir $out
done


# OXY
case="OXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_MIS_OXY
ROPA2=$ROPA_WS_OXY
Label1="MIS"
Label2="WS"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -l1 $Label1 -l2 $Label2 -species $i -lim $Limit -outdir $out
done


# AIR and OXY
case="AIRandOXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_MIS_AIR
ROPA2=$ROPA_WS_AIR
ROPA3=$ROPA_MIS_OXY
ROPA4=$ROPA_WS_OXY
Label1="MIS:AIR"
Label2="WS:AIR"
Label3="MIS:OXY"
Label4="WS:OXY"

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    ROPA_2="${ROPA2}Data_${i}.csv"
    ROPA_3="${ROPA3}Data_${i}.csv"
    ROPA_4="${ROPA4}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -i2 $ROPA_2 -i3 $ROPA_3 -i4 $ROPA_4 -l1 $Label1 -l2 $Label2 -l3 $Label3 -l4 $Label4 -species $i -lim $Limit -outdir $out
done


echo 'Effect of biomass fuel type: DONE'
############################################


############################################
echo 'ROPA for each fuel type:' 
############################################
folder="SingleFuelTypes/"
# COL - AIR
case="COL_AIR"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_COL_AIR

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


# COL - OXY
case="COL_OXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_COL_OXY

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


# MIS - AIR
case="MIS_AIR"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_MIS_AIR

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


# MIS - OXY
case="MIS_OXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_MIS_OXY

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


# WS - AIR
case="WS_AIR"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_WS_AIR

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


# WS - OXY
case="WS_OXY"
out="${Out}${folder}${case}"
mkdir -p $out
ROPA1=$ROPA_WS_OXY

echo "   CASE: ${case}"
for i in ${Species[@]}; do
    echo $i
    ROPA_1="${ROPA1}Data_${i}.csv"
    python3 CreateFigure.py -i1 $ROPA_1 -l1 $Label1 -species $i -lim $Limit -outdir $out
done


echo 'ROPA for each fuel type: DONE'
############################################
