#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd X_CO2_025
#FlameMaster
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH50.dout
cd ../X_CO2_050
# FlameMaster
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH50.dout
cd ../X_CO2_075
#FlameMaster
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH50.dout
cd ../..
