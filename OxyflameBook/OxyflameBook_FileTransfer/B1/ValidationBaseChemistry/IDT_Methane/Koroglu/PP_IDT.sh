#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd Lean/HP
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
cd ../LP
python3 ../../../../../../Scripts/PP_IDT.py  output/IgniDelTimesCHmaxgrad.dout
cd ../../Stoichiometric/HP
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
cd ../LP
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
cd ../../Rich/HP
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
cd ../LP
python3 ../../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
cd ../../X_CO2_060
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmaxgrad.dout
