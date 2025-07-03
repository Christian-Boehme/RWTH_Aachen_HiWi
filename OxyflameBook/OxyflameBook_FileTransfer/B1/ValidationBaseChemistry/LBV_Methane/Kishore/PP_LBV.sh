#!bin/bash

echo 'Directory: '
read dir
cd $dir

cd X_CO2_020
python3 ../../../../../Scripts/PP_IDT.py output
cd ../X_CO2_040
python3 ../../../../../Scripts/PP_IDT.py output
cd ../X_CO2_060
python3 ../../../../../Scripts/PP_IDT.py output
cd ..

