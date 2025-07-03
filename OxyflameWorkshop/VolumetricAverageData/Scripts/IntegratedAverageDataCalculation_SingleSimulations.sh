#!/usr/bin bash

cd ../SingleParticleSimulations/Christian_Tests/

echo 'DVC_CRS_AIR_DP_90_O2_20_Twall500K'
cd DVC_CRS_AIR_DP_90_O2_20_Twall500K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

#echo 'DVC_MIS_AIR_DP_90_O2_20_PeriodicBC'
#cd ../../DVC_MIS_AIR_DP_90_O2_20_PeriodicBC/LastPlain_x168
#echo 'LastPlain_x168'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
#cd ../TotalDomain
#echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_AIR_DP_90_O2_20_Twall1400K'
cd ../../DVC_MIS_AIR_DP_90_O2_20_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_AIR_DP_90_O2_20_Twall500K'
cd ../../DVC_MIS_AIR_DP_90_O2_20_Twall500K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

#echo 'DVC_MIS_OXY_DP_90_O2_20_PeriodicBC'
#cd ../../DVC_MIS_OXY_DP_90_O2_20_PeriodicBC/LastPlain_x168
#echo 'LastPlain_x168'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
#cd ../TotalDomain
#echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_OXY_DP_90_O2_20_Twall1400K'
cd ../../DVC_MIS_OXY_DP_90_O2_20_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_OXY_DP_90_O2_20_Twall500K'
cd ../../DVC_MIS_OXY_DP_90_O2_20_Twall500K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

#echo 'DVC_MIS_OXY_DP_90_O2_30_PeriodicBC'
#cd ../../DVC_MIS_OXY_DP_90_O2_30_PeriodicBC/LastPlain_x168
#echo 'LastPlain_x168'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
#cd ../TotalDomain
#echo 'TotalVolume'
#python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_OXY_DP_90_O2_30_Twall1400K'
cd ../../DVC_MIS_OXY_DP_90_O2_30_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DVC_MIS_OXY_DP_90_O2_30_Twall500K'
cd ../../DVC_MIS_OXY_DP_90_O2_30_Twall500K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC_MIS_AIR_DP_90_O2_20_Twall1400K'
cd ../../FVC_MIS_AIR_DP_90_O2_20_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC_MIS_OXY_DP_90_O2_20_Twall1400K'
cd ../../FVC_MIS_OXY_DP_90_O2_20_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC_MIS_OXY_DP_90_O2_30_Twall1400K'
cd ../../FVC_MIS_OXY_DP_90_O2_30_Twall1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300
cd ../TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300



cd ../../../



echo 'DYN_COL_AIR20_SINGLE/'
cd DYN_COL_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_COL_OXY20_SINGLE/'
cd ../../DYN_COL_OXY20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_WS_AIR20_SINGLE/'
cd ../../DYN_WS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_WS_OXY20_SINGLE/'
cd ../../DYN_WS_OXY20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_MIS_AIR20_SINGLE/'
cd ../../DYN_MIS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_MIS_OXY20_SINGLE/'
cd ../../DYN_MIS_OXY20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'DYN_MIS_OXY30_SINGLE/'
cd ../../DYN_MIS_OXY30_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC0_MIS_AIR20_SINGLE/'
cd ../../FVC0_MIS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC0_MIS_OXY20_SINGLE/'
cd ../../FVC0_MIS_OXY20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC0_MIS_OXY30_SINGLE/'
cd ../../FVC0_MIS_OXY30_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC1_MIS_AIR20_SINGLE/'
cd ../../FVC1_MIS_AIR20_SINGLE/TotalDomain
echo 'TotalVolume'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.300

echo 'FVC2_MIS_AIR20_SINGLE/'
cd ../../FVC2_MIS_AIR20_SINGLE/TotalDomain
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

