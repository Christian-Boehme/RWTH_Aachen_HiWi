#!bin/bash

echo 'Directory for postprocessing:'
read dir

cd $dir
cd Lean/1.00atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../1.25atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../2.49atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../../Stoichiometric/1.00atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../1.22atm/
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../2.75atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../../Rich/1.00atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../1.21atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../2.91atm
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../..
echo 'DONE'
