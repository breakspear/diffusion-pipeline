.. diffusion_pipeline documentation master file, created by
   sphinx-quickstart on Thu May 24 15:45:08 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to SNG Diffusion Pipeline's user documentation!
==============================================

This pipeline provides a streamlined way of processing diffusion weighted images (and as a side effect, structural images) through the "*MRtrix*", "*FSL*" and "*FreeSurfer*" packages.

Setup Information
-----------------

1) Ensure that you are in your home directory on the avalon cluster::

.. code-block:: console

  $ cd ~
	
2) Install the github package:

.. code-block:: console

  $ git clone https://github.com/breakspear/diffusion-pipeline.git

3) Make sure your bash environment is setup correctly:

.. code-block:: console

  $ cp ~/diffusion-pipeline/.bashrc ~/.

You will need to restart your terminal session:

.. code-block:: console

  $ bash

for these changes to take effect. You may also wish to copy the contents of the .bashrc file into an existing .bashrc file in your home directory.



.. toctree::
   :maxdepth: 1
   :caption: Structural Preprocessing:

   structural_preprocessing/conversion_to_nifti
   structural_preprocessing/t1_processing_in_freesurfer




.. toctree::
   :maxdepth: 1
   :caption: DWI Preprocessing:

   dwi_preprocessing/conversion_to_mif
   dwi_preprocessing/advanced_preprocessing
   dwi_preprocessing/segmentation_and_parcellation
   dwi_preprocessing/fiber_and_connectome_construction




.. toctree::
  :maxdepth: 1
  :caption: Fixel-Based Analysis (FBA)

  fixel_based_analysis/fixel_based_analysis



.. toctree::
  :maxdepth: 1
  :caption: Tips and Tricks
  
  tips_and_tricks/dicom_handling
  tips_and_tricks/submitting_batch_jobs
  tips_and_tricks/interactive_jobs_and_foreach
  tips_and_tricks/miscellaneous_tips






.. toctree::
  :maxdepth: 1
  :caption: Troubleshooting

  troubleshooting/image_specific_issues
  troubleshooting/PBS_job_errors
  troubleshooting/FAQ
  troubleshooting/advanced_debugging




.. toctree::
  :maxdepth: 1
  :caption: Reference

  reference/commands_list
  reference/config_file_options
  reference/mrtrix3




Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
