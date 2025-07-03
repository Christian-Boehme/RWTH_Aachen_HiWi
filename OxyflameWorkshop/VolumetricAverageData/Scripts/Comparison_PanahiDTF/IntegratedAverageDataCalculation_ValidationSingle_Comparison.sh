#!/usr/bin bash

# time = calculate integrated average up to ...
time=0.66 #0.50

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1300K'
cd ../../Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1300K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1400K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1500K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1500K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time


echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1300K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1300K/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1400K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time 

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1500K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1500K/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time 
