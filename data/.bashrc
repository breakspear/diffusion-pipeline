# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

#export basic binaries

PATH=:/usr/bin:/usr/local/pbs/default/bin:${PATH}
export PATH

#now software specific for path

addsoftware=:/software/c3d/c3d-1.1.0-Linux-gcc64/bin

PATH=${addsoftware}:${PATH}
export PATH

#now modules

module load mrtrix3/AP
module load freesurfer/6.0.0
module load ANTs/20160509
module load fsl/5.0.9_eddy
module load ConnectomeWorkbench/1.2.3
module load R/3.4.1
