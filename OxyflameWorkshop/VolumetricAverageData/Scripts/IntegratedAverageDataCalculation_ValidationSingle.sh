#!/usr/bin bash

# time = calculate integrated average up to ...
timeDTF90=0.500
time=0.330
echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1300K'
cd ../Validation_SINGLE/Panahi2019_DTF90_288_40_40_Tgas1300K/LastPlain_x288
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.5 # 0.01ppm 0.4374 # 0.1ppm 0.3725

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1400K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1400K/LastPlain_x288
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.5 # 0.01ppm 0.4789 # 0.1ppm 0.4057

echo 'Panahi 2019 - DTF90-288-40-40 Tgas = 1500K'
cd ../../Panahi2019_DTF90_288_40_40_Tgas1500K/LastPlain_x288
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt 0.5 # 0.01ppm 0.5192 # 0.1ppm 0.4366

echo 'Panahi 2019 - DTF90-140 Tgas = 1300K'
cd ../../Panahi2019_DTF90_140_Tgas1300K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - DTF90-140 Tgas = 1400K'
cd ../../Panahi2019_DTF90_140_Tgas1400K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - DTF90-140 Tgas = 1500K'
cd ../../Panahi2019_DTF90_140_Tgas1500K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - DTF90 Tgas = 1300K'
cd ../../Panahi2019_DTF90_Tgas1300K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - DTF90 Tgas = 1400K'
cd ../../Panahi2019_DTF90_Tgas1400K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - DTF90 Tgas = 1500K'
cd ../../Panahi2019_DTF90_Tgas1500K/LastPlain_x192
echo 'LastPlain_x192'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $timeDTF90

echo 'Panahi 2019 - Tgas = 1300K'
cd ../../Panahi2019_DTF_Tgas1300K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1400K'
cd ../../Panahi2019_DTF_Tgas1400K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1500K'
cd ../../Panahi2019_DTF_Tgas1500K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1300K: FixedParticle'
cd ../../Panahi2019_FixedParticle_Tgas1300K/LastPlain_x49
echo 'LastPlain_x49'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1400K: FixedParticle'
cd ../../Panahi2019_FixedParticle_Tgas1400K/LastPlain_x49
echo 'LastPlain_x49'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1500K: FixedParticle'
cd ../../Panahi2019_FixedParticle_Tgas1500K/LastPlain_x49
echo 'LastPlain_x49'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time


# Twall=500K
echo 'Panahi 2019 - Tgas = 1300K: DTF P49'
cd ../../Twall500K/Panahi2019_DTF_P49_Tgas1300K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1400K: DTF P49'
cd ../../Panahi2019_DTF_P49_Tgas1300K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1500K: DTF P49'
cd ../../Panahi2019_DTF_P49_Tgas1300K/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time


echo 'Panahi 2019 - Tgas = 1500K: FixedParticleAtInjector'
cd ../../Panahi2019_FixedParticleAtInjector_Tgas1500K/LastPlain_x49
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time


echo 'Panahi 2019 - Tgas = 1300K: DTF'
cd ../../Panahi2019_FixedParticle_Tgas1300K/LastPlain_x49
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1400K: DTF'
cd ../../Panahi2019_FixedParticle_Tgas1400K/LastPlain_x49
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

echo 'Panahi 2019 - Tgas = 1500K: DTF'
cd ../../Panahi2019_FixedParticle_Tgas1500K/LastPlain_x49
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time


echo 'Panahi 2019 - Tgas = 1500K: DTF-TwallZ'
cd ../../Panahi2019_Tgas1500K_TwallZ/LastPlain_x168
echo 'LastPlain_x168'
python3 ~/NHR/NOx_JETS_ICNC24/Post/Python/GetIntegratedAverage.py VolumetricAverageMoleFractions.txt $time

