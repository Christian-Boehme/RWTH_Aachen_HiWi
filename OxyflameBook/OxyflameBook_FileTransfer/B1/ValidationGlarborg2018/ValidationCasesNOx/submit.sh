#!/usr/bin/env bash

if [ "$#" -ne 4 ]; then
   me=`"$0"`
   echo "3 arguments are required for the job submission"
   echo "usage: ./$me <jobs_list> <submission script template> <job_title> <slurm time>"
   echo "example:"
   echo "$me jobs SlurmScript_FM IDT_OCTANOL\"01:00:00\""
   exit 1
fi


export submission_template=$2
export job_list=$1
default_sub_template="SlurmScript_FM"
if [ ! -f "$submission_template" ]; then
  echo "using default submission script template \"$default_sub_template\""
  if [ ! -f "$default_sub_template" ]; then
    echo "#error: default job list file \"$default_sub_template\" does not exist"
    exit 1
  fi
  export submission_template="$default_sub_template"
fi

export TITLE="$3" 
export SLURM_RUN_TIME="$4"


#hide submission script clutter
mkdir -p jobs_out


slurm_submission () {
  #echo "JOB_LINE: $line"
  export line_number="$count"  
  export JOB_LINE="$line"
  #echo "FM_EXE: $FM_BIN/FlameMan"
  if [ ! -d "$FM_BIN" ]; then
    echo "#error: FlameMaster binary directory FM_BIN=\"$FM_BIN\" does not exist. Run source ~/Your/FlameMaster/Bin/bin/Source.<your_shell>"
    exit 1
  fi
  if [ ! -f "$FM_BIN/FlameMan" ]; then
    echo "#error: \"$FM_BIN/FlameMan\" executable does not exist. Is FlameMaster correctly installed?"
    exit 1
  fi
  export JOB_TITLE="$TITLE$line_number"  
  echo "SLURM_TITLE: ${JOB_TITLE}"
  # insert environment variables
  envsubst '$JOB_LINE,$JOB_TITLE,$SLURM_RUN_TIME,$FM_BIN/FlameMan' < "$submission_template" > slurm_work_1
  sbatch slurm_work_1  
  rm slurm_work_1  
}
count="0"
while read -r line; do
    ((count+=1)) 
    if [[ "$line" =~ ^#.* ]];then 
       continue  
    else 
    echo "submit job: $line"     
    slurm_submission    
    fi 
done < "$job_list"


