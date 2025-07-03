#!/usr/bin bash

# YOU ARE IN THE MATLAB2DMOVIE FOLDER!
mkdir YOH Tgas
mv Movie_Tgas_Frame_* Tgas.avi Tgas
mv Movie_YOH_Frame_* YOH.avi YOH
python3 ~/p0021020/Christian/Scripts/Postprocessing_CIAO/python_scripts/PNG2Movie.py Tgas
python3 ~/p0021020/Christian/Scripts/Postprocessing_CIAO/python_scripts/PNG2Movie.py YOH
