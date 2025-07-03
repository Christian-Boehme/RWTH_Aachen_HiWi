#!bin/bash

echo 'Directory: '
read dir
cd $dir
cd T308K
python3 ../../../../../Scripts/PP_IDT.py output/
#cd ../T318K
#python3 ../../../../../Scripts/PP_IDT.py output/
cd ../T328K
python3 ../../../../../Scripts/PP_IDT.py output/
#cd ../T338K
#python3 ../../../../../Scripts/PP_IDT.py output/
cd ../T358K
python3 ../../../../../Scripts/PP_IDT.py output/

