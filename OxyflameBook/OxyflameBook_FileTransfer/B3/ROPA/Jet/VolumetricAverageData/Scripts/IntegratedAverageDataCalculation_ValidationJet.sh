#!/usr/bin bash

echo 'CRS_AIR_DP_90_O2_20'
cd ../Validation_JET/CRS_AIR_DP_90_O2_20/LastPlain_x288/
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.320

echo 'MIS_AIR_DP_90_O2_20'
cd ../../MIS_AIR_DP_90_O2_20/LastPlain_x288/
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.320

