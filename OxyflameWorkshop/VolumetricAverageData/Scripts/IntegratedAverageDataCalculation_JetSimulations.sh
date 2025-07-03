#!/usr/bin bash

cd ..

echo 'CRS_AIR_DP_90_O2_20'
cd CRS_AIR_DP_90_O2_20/LastPlain_x288
echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
cd ../TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

echo 'MIS_AIR_DP_90_O2_20'
cd ../../MIS_AIR_DP_90_O2_20/LastPlain_x288
echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
cd ../TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

echo 'MIS_AIR_DP_90_O2_20_FVC'
echo 'old'
cd ../../MIS_AIR_DP_90_O2_20_FVC/old/LastPlain_x288
echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
cd ../TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
echo 'FVC0'
cd ../../FVC0/TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
echo 'FVC2'
cd ../../FVC2/TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

echo 'MIS_OXY_DP_90_O2_20'
# see BACKUP data!
#cd ../../MIS_OXY_DP_90_O2_20/LastPlain_x288
#echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
#cd ../TotalDomain
cd ../../../MIS_OXY_DP_90_O2_20/TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

echo 'MIS_OXY_DP_90_O2_30'
# see BACKUP data!
#cd ../../MIS_OXY_DP_90_O2_30/LastPlain_x288
#echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
#cd ../TotalDomain
cd ../../MIS_OXY_DP_90_O2_30/TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

echo 'MSR_AIR_DP_90_O2_20'
cd ../../MSR_AIR_DP_90_O2_20/LastPlain_x288
echo 'LastPlain_x288'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238
cd ../TotalDomain
echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py VolumetricAverageMoleFractions.txt 0.238
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage_IgnoreZeros.py MaxMoleFractions.txt 0.238
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py MaxMoleFractions.txt 0.238

