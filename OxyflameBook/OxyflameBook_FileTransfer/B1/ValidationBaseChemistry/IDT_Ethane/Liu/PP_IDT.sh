#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd HP/Lean/30perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../60perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../86perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../../Stoi/2perFuel
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../4perFuel
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../../Rich
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../../LP/Lean/30perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../60perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../86perCO2
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../../Stoi/2perFuel
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../4perFuel
python3 ../../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../../Rich
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
