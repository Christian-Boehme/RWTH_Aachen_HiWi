#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd X_CO2_20
python3 ../../../../../Scripts/PP_IDT.py output/
cd ../X_CO2_40
python3 ../../../../../Scripts/PP_IDT.py output/

