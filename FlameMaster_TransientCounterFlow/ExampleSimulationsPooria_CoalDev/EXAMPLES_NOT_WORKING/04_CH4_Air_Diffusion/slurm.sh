#!/usr/bin/env bash

## Job name and files
#SBATCH --job-name=04_CH4_Air_Diffusion

## OUTPUT AND ERROR
#SBATCH -o job.04_CH4_Air_Diffusion.%j.out
#SBATCH -e job.04_CH4_Air_Diffusion.%j.err


## Initial working directory
##SBATCH -D.

### specify your mail address (send feedback when job is done)
##SBATCH --mail-type=begin  				 # send email when process begins...
##SBATCH --mail-type=end    				 # ...and when it ends...
##SBATCH --mail-type=fail   		 	    # ...or when it fails.
##SBATCH --mail-user=p.farmand@itv.rwth-aachen.de	 # send notifications to this email REPLACE WITH YOUR EMAIL

## Setup of execution environment 
#SBATCH --export=NONE

## choose account
#SBATCH --account='itv'
#SBATCH --partition='itv'	 
#SBATCH -C 'broadwell'
##SBATCH -w 'lnih087'   # Specific node

## select resources
##SBATCH -C hpcwork

## Request the number of nodes
#SBATCH --nodes=1           # number of nodes

## total number of tasks
#SBATCH --ntasks=1

## Set tasks per node
#SBATCH --tasks-per-node=1    # NOTE new machine has 48 core per node


## Set cpus per task (multiple tasks for hyperthreading)
#SBATCH --cpus-per-task=1

## Set threats per cores
#SBATCH --threads-per-core=1

## memory per cpu
##SBATCH --mem-per-cpu=3400


## do not share nodes 
##SBATCH --exclusive

## OPTIONAL
## set max. file size to 500Gbyte per file
##SBATCH -F 500000000

## execution time in [hours]:[minutes]:[seconds]
## recommended: less than 24:00
#SBATCH --time=12:00:00

############################################### 
###############################################
########## END OF SLURM INSTRUCTION ###########
##!!! DO NOT PLACE SHELL VARIABLES ABOVE!!!####
###############################################
###############################################

echo "Starting $SLURM_JOB_NAME ..."

## Optional lines to remove all modules loaded and load the one disired
## Not need to use them if you use the default modules
## In the case the code has been compiled with the intel2016, change the following line accordingly 
module purge; module load DEVELOP DEPRECATED
module load intel
module load intelmpi/2018.3.222

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/itv/compile_centos7/lib/sundials/2.7.0_intel19.0_intelmpi_2018_mkl/Install_DIR/lib/

### Processor affinity options
### Processor pinning
##export I_MPI_PIN=1
##export I_MPI_PIN_DOMAIN=core


## #executable name (e.g. arts_cf)
exe='FlameMaster'

### executable arguments
args='-i 04_CH4_Air_Diffusion.input'

date
##$MPIEXEC $FLAGS_MPI_BATCH $I_MPI_PIN $I_MPI_PIN_DOMAIN ./$exe $args
##$MPIEXEC $FLAGS_MPI_BATCH 
./$exe $args 2>&1 | tee job_04_CH4_Air_Diffusion.out
date

### echo the envvars containing info on how the slots are distributed
echo "### Nodes assigned to job #####################################"
echo $SLURM_JOB_NODELIST
echo "### Number of cores per node ################################"
echo $SLURM_JOB_CPUS_PER_NODE 
##echo "### SLURM_HOSTFILE #############################"
##echo $SLURM_HOSTFILE
##cat  $SLURM_HOSTFILE
echo "### Total number of tasks for job ##############################"
echo $SLURM_NTASKS
echo $R_DELIMITER
