#!/usr/bin bash

cd ../../../COL/AIR10-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 8.20
cd ../AIR20-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 8.30
cd ../AIR20-DP160
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 12.7
cd ../AIR20-DP160-GRID125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 13.2
cd ../AIR20-DP90
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.70
cd ../AIR20-DP90-GRID125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.50
cd ../AIR40-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar_tvol_calculation 8.40
cd ../OXY20-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 7.90
cd ../OXY20-DP160
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 12.0
cd ../OXY20-DP90
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.40
cd ../../WS/
echo 'WS'
cd AIR10-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 7.36
cd ../AIR20-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 7.40
cd ../AIR20-DP160
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 11.1
cd ../AIR20-DP160-GRID125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 11.8
cd ../AIR20-DP90
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.20
cd ../AIR20-DP90-GRID125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.10
cd ../AIR40-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 7.62
cd ../OXY20-DP125
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 7.00
cd ../OXY20-DP160
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 10.50
cd ../OXY20-DP90
pwd
python3 ../../PostProcessing/VolatileFlameTime/Scripts/CalculateVolatileFlameTime.py monitor_TaoLi/scalar 4.00

