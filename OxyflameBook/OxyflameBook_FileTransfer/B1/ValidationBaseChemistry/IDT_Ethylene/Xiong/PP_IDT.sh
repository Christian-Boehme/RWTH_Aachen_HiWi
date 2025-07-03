#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd Set_4
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../Set_5
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../Set_6
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
