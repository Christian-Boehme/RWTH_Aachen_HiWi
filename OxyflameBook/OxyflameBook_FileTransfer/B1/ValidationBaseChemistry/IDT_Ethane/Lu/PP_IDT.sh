#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd LP
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout
cd ../HP
python3 ../../../../../Scripts/PP_IDT.py output/IgniDelTimesOH10.dout

