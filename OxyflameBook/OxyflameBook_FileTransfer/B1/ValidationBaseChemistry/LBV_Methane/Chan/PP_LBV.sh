#!bin/bash

echo 'Directory: '
read dir
cd $dir

cd X_CO2_10
python3 ../../../../Scripts/PP_IDT.py output
cd ../X_CO2_15
python3 ../../../../Scripts/PP_IDT.py output
cd ..

