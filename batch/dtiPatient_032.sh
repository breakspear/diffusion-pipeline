#!/bin/bash
#Template file which sets up PBS requirements for all jobs

# All required resource statements start with "#PBS -l"
# These will be interpreted by the job submission system (PBS pro)

#PBS -l ncpus=8,mem=2G
# *select* is the number of parallel processes
# *ncpus* is the number of cores required by each process
# *mem* is the amount of memory required by each process

#PBS -v MRTRIX=/software/mrtrix3/mrtrix3-AP,ncpus=8

#PBS -l walltime=47:00:00
# *walltime* is the total time required in hours:minutes:seconds
# to run the job. 
# Warning: all processes still running at the end of this period
# of time will be killed and any temporary data will be erased.

#PBS -m abe 
#NOTE : alistair.perry@qimrberghofer.edu.au
# *m* situations under which to email a) aborted b) begin e) end
# *M* email address to send emails to


####
#Find all scripting files
pipedir=$(pwd)
PATH=$PATH$( find $pipedir/ -type d -printf ":%p" )
#export PATH=$(pwd)/custscripts:$PATH


####
#Load all required software
module load mrtrix3/AP
module load freesurfer/6.0.0
module load ANTs/20160509
module load fsl/5.0.9_eddy


####
#Setup dir for temp MRtrix files to be written - otherwise they get sent to nodes tmp dir

WORKDIR=/mnt/lustre/working/lab_michaebr/alistaiP/Park
echo "TempDir: ${WORKDIR}/tmp" > /mnt/lustre/$USER/.mrtrix.conf

#Extract ID of subject and their corresponding folder holding raw image files

subj=Patient_032
subjDIRECTORY=/mnt/lustre/working/lab_michaebr/alistaiP/Park/Raw/Patient_032

cd $subjDIRECTORY

advfibertrackandcntmecon_phil Patient_032 /mnt/lustre/working/lab_michaebr/alistaiP/Park 25M DST #"%%%%" will match to the string  that corresponds to your personalised batch script, or preferred pipeline
 
