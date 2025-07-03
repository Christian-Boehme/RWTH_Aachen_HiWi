# How to create the data:
cd ../PostProcessingFlameletsNicolai
## Z, chi, g calculation for each flamelet
python3 CreateFigure.py -o ../OutputData/Flamelet_preheated_PassiveScalarMixtureFraction -i ../InputData/Flamelets_preheated/* -vy grad,chi -vx Z -save
python3 CreateFigure.py -o ../OutputData/Flamelet_preheated_AtomicMixtureFraction -i ../InputData/Flamelets_preheated/* -vy grad,chi -vx Z -save -atomicZ
## Gradient validation
python3 GradientValidation.py -i ../OutputData/Flamelet_preheated_passiveScalarMixtureFraction/Data/Data_yiend.* -o ../OutputData/GradientValidation/Flamelet_preheated_PassiveScalarMixtureFraction/RelativeError -rel
## RelativeError
python3 RelativeError.py -i1 ../OutputData/Flamelet_preheated_AtomicMixtureFraction/Data/Data_yiend.* -i2 ../OutputData/Flamelet_preheated_passiveScalarMixtureFraction/Data/Data_yiend.* -o ../OutputData/RelativeError_ScalarDissipationRate/Flamelet_preheated -l1 at -l2 ps -x x -y chi
## FlameletData
cd ../PostProcessingMATLAB/
SaveFlameletData.m
