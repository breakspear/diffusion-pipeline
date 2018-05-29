.. _t1_processing_in_freesurfer

T1 Processing using FreeSurfer recon-all tool
============================================

This pipeline utilises the automatic processing of structural images built in to the FreeSurfer program. The recon-all tool is responsible for multiple processing steps, as detailed on https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all.

Process the files:
-----------------

All of your subjects can be batch processed on the Avalon HPC cluster by using the following command:

.. code-block:: console

  $ cd ~/diffusion-pipeline
  $ sh dticon /working/your_lab_here/your_username/your_working_dir/ processFSall

The structure of the above command is:

  1) Change to the pipeline directory (should be in your home directory on the cluster)
  2) "sh" sets the format of the output files
  3) dticon is a script that, when called, automatically creates each subjects' individual script
  4) Make sure to replace your /working/ path with the correct path
  5) processFSall is the command that runs a subject through the recon-all tool automatically.

Call this command correctly, then move to your working directory:

.. code-block:: console

  $ cd /working/your_lab_here/your_username/your_working_dir/
  $ cd batch

To run a script, your will need to pass them to the PBS batching system built into the cluster. Do this via:

.. code-block:: console

  $ qsub processFSall_yoursub.sh

To run all of scripts together, use the following command:

.. code-block:: console

  $ find . -name ".sh" -exec qsub {} \;

If you need further explanation on this command, please look at the "Tips and Tricks" page.

