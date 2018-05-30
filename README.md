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

[Conversion to NiFTI for T1](docs/conversion_to_nifti.rst)

[Conversion to MIF for DWI](docs/conversion_to_mif.rst)

## Structural image preprocessing

[FreeSurfer preprocessing](docs/t1_processing_in_freesurfer.rst)

## Diffusion image preprocessing

[Advanced preprocessing](docs/advanced_preprocessing.rst)

[Segmentation_and_parcellation](docs/segmentation_and_parcellation.rst)

[Fibre and connectome construction](docs/fibre_and_connectome_construction.rst)
