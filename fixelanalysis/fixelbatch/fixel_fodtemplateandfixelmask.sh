#!/bin/bash
#Template file which sets up PBS requirements for all jobs

# All required resource statements start with "#PBS -l"
# These will be interpreted by the job submission system (PBS pro)

#PBS -l ncpus=10,mem=2G
# *select* is the number of parallel processes
# *ncpus* is the number of cores required by each process
# *mem* is the amount of memory required by each process

#PBS -l walltime=47:00:00
# *walltime* is the total time required in hours:minutes:seconds
# to run the job. 
# Warning: all processes still running at the end of this period
# of time will be killed and any temporary data will be erased.

#PBS -m abe -M alistair.perry@qimrberghofer.edu.au
#NOTE: if you want to receive notifications about job status, enter your QIMR email after the "abe" above
# *m* situations under which to email a) aborted b) begin e) end
# *M* email address to send emails to

export OMP_NUM_THREADS=8

####
#Find all scripting files
#currdir=$(pwd)
pipedir=/mnt/lustre/home/alistaiP/bundle/test/diffusion-pipeline/fixelanalysis
PATH=$PATH$( find $pipedir/ -not -path '*/\.*'  -type d -printf ":%p" )
#export PATH:$PATH

####
#Load all required software
module load mrtrix3/20170707
module load freesurfer/6.0.0
module load ANTs/20160509
module load fsl/5.0.9_eddy

fodtemplateandfixelmask  /working/lab_michaebr/alistaiP/Park AFD5-regridtemp templateoutput #"%%%%" will match to the string  that corresponds to your personalised batch script, or preferred pipeline
