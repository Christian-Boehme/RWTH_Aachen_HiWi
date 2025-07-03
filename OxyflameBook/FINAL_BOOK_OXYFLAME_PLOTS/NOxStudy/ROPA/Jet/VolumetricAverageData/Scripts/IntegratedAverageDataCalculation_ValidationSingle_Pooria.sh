#!/usr/bin bash

# time = calculate integrated average up to ...
timeDTF90=1.00
time=0.330

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1300K 1s'
cd ../Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1300K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90 

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1400K 1s'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90 

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1500K 1s'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90 


echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1300K 0.33s'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1300K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1400K 0.33s'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time 

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1500K 0.33s'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1500K_Pooria/LastPlain_x288
echo 'LastPlain_x288'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time 
