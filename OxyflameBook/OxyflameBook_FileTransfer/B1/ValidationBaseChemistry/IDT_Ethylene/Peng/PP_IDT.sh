#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd Set_1
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../Set_3
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../Set_5
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
