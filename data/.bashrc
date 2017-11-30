# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

PATH=:/usr/bin:/usr/local/pbs/default/bin/:/mnt/lusture/home/alistaiP/base/packages:${PATH}

export PATH

module load mrtrix3/AP
module load freesurfer/6.0.0
module load ANTs/20160509
module load fsl/5.0.9_eddy
module load ConnectomeWorkbench/1.2.3
module load R/3.4.1
