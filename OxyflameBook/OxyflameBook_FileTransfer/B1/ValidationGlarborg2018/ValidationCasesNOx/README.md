#Validation DataBase for NOx predictions: 

#Experiments are taken from: 
Glarborg, P., Miller, J., A., Ruscic, B., Klippenstein, S. J.,Modeling nitrogen chemistry in combustion, Progress in Energy and Combustion Science, 67, 31-68, 2018 


#Before running the script: 
module load gcc/8 python/3.9.6 
source your_FM_folder/Bin/bin/Source.zsh 

#Run 
bash submit_all.sh your_pre_file
 
#When all your simulations are done 
bash ListToolAll 
python3 ValidationDB.py 

#NOTE
If your python does not run because some modules are missing:
pip install your_module 

# Christian
LT Simulations/Prompt/CH_Prompt_Lam/OutputCH4Stoch/CH4_p00_1phi1_0000tu0388v0280 && LT Simulations/Prompt/CH_Prompt_Lam/OutputCH4Rich/CH4_p00_1phi1_2500tu0325v0286 && LT Simulations/Prompt/CH_Prompt_Lam/OutputCH4Lean/CH4_p00_1phi0_8000tu0342v0268
python3 MY_ValiDationDB.py RESULTS/ITVDetailed_NOx
=> writes data to RESULTS/ITVDetailed_NOx
=> cp this folder to Figures/SimulationData and run the post-processing script (PP_Glarborg.py)
