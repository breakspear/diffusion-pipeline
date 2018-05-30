# Welcome to SNG Diffusion Pipeline's user documentation!

This pipeline provides a streamlined way of processing diffusion weighted images (and as a side effect, structural images) through the "*MRtrix*", "*FSL*" and "*FreeSurfer*" packages.

## Setup Information

1) Ensure that you are in your home directory on the avalon cluster::

  `$ cd ~`
	
2) Install the github package:

  `$ git clone https://github.com/breakspear/diffusion-pipeline.git`

3) Make sure your bash environment is setup correctly:

  `$ cp ~/diffusion-pipeline/.bashrc ~/.`

You will need to restart your terminal session:

  `$ bash`

for these changes to take effect. You may also wish to copy the contents of the .bashrc file into an existing .bashrc file in your home directory.

## Getting started

[Conversion to NiFTI for T1](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/structural_preprocessing/conversion_to_nifti.rst)

[Conversion to MIF for DWI](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/dwi_preprocessing/conversion_to_mif.md)

## Structural image preprocessing

[FreeSurfer preprocessing](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/structural_preprocessing/t1_processing_in_freesurfer.rst)

## Diffusion image preprocessing

[Advanced preprocessing](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/dwi_preprocessing/advanced_preprocessing.md)

[Segmentation and parcellation](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/dwi_preprocessing/segmentation_and_parcellation.md)

[Fibre and connectome construction](https://github.com/breakspear/diffusion-pipeline/tree/master/docs/dwi_preprocessing/fibre_and_connectome_construction.md)

All processed files (images, matrices, text files) can be found in `/working/your_lab_here/your_working_dir/Diff/your_sub/preproc/`.


