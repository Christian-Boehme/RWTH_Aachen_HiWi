#!/usr/bin bash

# NOTE: IDT + 0.01 if .00 (avoid E+02)
cd ../Data/Coal/AIR10-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 8.21
cd ../AIR20-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 8.31
cd ../AIR20-DP160
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 12.7
cd ../AIR20-DP160-GRID125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 13.3
cd ../AIR20-DP90
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.71
cd ../AIR20-DP90-GRID125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.51
cd ../AIR40-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 8.41
cd ../OXY20-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 7.91
cd ../OXY20-DP160
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 12.1
cd ../OXY20-DP90
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.41
cd ../../WS/
echo 'WS'
cd AIR10-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 7.36
cd ../AIR20-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 7.41
cd ../AIR20-DP160
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 11.1
cd ../AIR20-DP160-GRID125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 11.8
cd ../AIR20-DP90
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.21
cd ../AIR20-DP90-GRID125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.11
cd ../AIR40-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 7.62
cd ../OXY20-DP125
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 7.01
cd ../OXY20-DP160
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 10.51
cd ../OXY20-DP90
pwd
python3 ../../../Scripts/DataInterpolationAndSmoothing.py FlameThickness.txt 4.01

