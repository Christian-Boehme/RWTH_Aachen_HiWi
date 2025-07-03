#!/bin/bash

## Double ## is a comment , #SBATCH is a command

## Job name and files
#SBATCH --job-name=S_C_A20
## OUTPUT AND ERROR
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err

## Initial working directory
##SBATCH -D /. 


#### specify your mail address (send feedback when job is done)
##SBATCH --mail-type=begin  				 # send email when process begins...
#SBATCH --mail-type=end    				 # ...and when it ends...
#SBATCH --mail-type=fail   		 	         # ...or when it fails.
#SBATCH --mail-user=christian.boehme@rwth-aachen.de	 # send notifications to this email REPLACE WITH YOUR EMAIL

## Setup of execution environment 
#SBATCH --export=NONE

## account and partition selection
#SBATCH --account='p0021497'
#SBATCH --partition='c23ms'

## Select list of nodes (use itv_jobs / itv_status / itv_status_long for more info)
## 'westmere'    = citv1-4
## 'ivybridge'   = citv5
## 'c2'          = citv6-7
##SBATCH -C 'broadwell'    ## CHANGE THIS TO SELECT THE DESIRED PARTITION

## Request the number of nodes
#SBATCH --nodes=2           # number of nodes

##### Check 'itv_status_long' for more information about cores
## Set tasks per node = Number of CPUs per node( without hyperthreading)
## Default values for different nodes:
## 'westmere'    = 12
## 'ivybridge'   = 20
## 'c2'          = 24
#SBATCH --tasks-per-node=48

## Set cpus per task (multiple tasks for hyperthreading)
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1

## memory per cpu (if not specified, the maximum allowable value for the selected node will be used)
##SBATCH --mem-per-cpu='INSERT VALUE IN MB'
## this is per node (100000 = 100GB)
#SBATCH --mem=120000

## do not share nodes 
#SBATCH --exclusive

## OPTIONAL
## set max. file size to 500Gbyte per file
####SBATCH -F 500000000

## execution time in [hours]:[minutes]:[seconds]
## recommended: less than 24:00:00
#SBATCH --time=30:30:00

############################################### 
###############################################
########## END OF SLURM INSTRUCTION ###########
##!!! DO NOT PLACE SHELL VARIABLES ABOVE!!!####
###############################################
###############################################

## Optional lines to remove all modules loaded and load the one desired
## Not need to use them if you use the default modules
## In the case the code has been compiled with the intel2016, change the following line accordingly 

### Load the required modules
module load MATLAB/2022a

### start non-interactive batch job
matlab -singleCompThread -nodisplay -nodesktop -nosplash -logfile job.${SLURM_JOB_ID}.txt <<EOF
run SINGLE_DVC_COL_AIR_90_O2_20_Twall1400K_TotalDomain_scalar_vol.m;
quit();
EOF
