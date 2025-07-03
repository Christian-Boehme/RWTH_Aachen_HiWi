#!bin/bash

echo 'Directory: '
read dir
cd $dir
python3 ../../../../Scripts/PP_IDT.py output/IgniDelTimesCHmax.dout
cd ../
