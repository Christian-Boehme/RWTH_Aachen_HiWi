#!/usr/bin bash

cd ../Scripts/

# single particle simulations simulations
echo 'DYN_COL_AIR20_SINGLE/'
cd ../../DYN_COL_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_MIS_AIR20_SINGLE/'
cd ../../DYN_MIS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_WS_AIR20_SINGLE/'
cd ../../DYN_WS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300


# Oxyflame workshop simulations
echo 'OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/'
cd ../../OxyflameWorkshop_DYN_COLOMBIAN_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/'
cd ../../OxyflameWorkshop_DYN_MISCANTHUS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/'
cd ../../OxyflameWorkshop_DYN_WALNUT_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

