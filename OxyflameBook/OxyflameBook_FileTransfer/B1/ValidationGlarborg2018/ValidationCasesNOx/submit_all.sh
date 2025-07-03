#!/usr/bin/env bash 

if [ "$#" -ne 1 ]; then
   me=`"$0"`
   echo "Provide the mech.pre file name as input"
   echo "example:"
   echo "$me Mech.pre"
   exit 1
fi

cp $1 MechNOx.pre 


echo "Submit Prompt NOx:"
bash submit.sh Simulations/Prompt/jobs_list SlurmScript_template Prompt \"30:09:00\"
#echo "Submit Thermal NOx"
#bash submit.sh Simulations/Thermal/jobs_list SlurmScript_template Thermal \"15:09:00\"
#echo "Submit Ammonia: " 
#bash submit.sh Simulations/Ammonia/jobs_list SlurmScript_template Ammonia \"15:09:00\" 
#echo "Submit N2O and NNH:  "
#bash submit.sh Simulations/N2O_NNH/jobs_list SlurmScript_template N2O_NNH \"15:09:00\"
#echo "Submit HCN:"
#bash submit.sh Simulations/HCN/jobs_list SlurmScript_template HCN \"15:09:00\"
#echo "Submit HNCO: "
#bash submit.sh Simulations/HNCO/jobs_list SlurmScript_template HNCO \"15:09:00\"
#echo "Submit RapReNOx: "
#bash submit.sh Simulations/RapReNOx/jobs_list SlurmScript_template RapReNOx \"15:09:00\"
#echo "Submit NOxOut: "
#bash submit.sh Simulations/NOxOut/jobs_list SlurmScript_template NOxOut \"15:09:00\"
#echo "Submit ThermalDeNOx: "
#bash submit.sh Simulations/ThermalDeNOx/jobs_list SlurmScript_template ThermalDeNOx \"15:09:00\" 
