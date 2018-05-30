.. _segmentation_and_parcellation

Segmentation and Parcellation
=============================

Currently this step is provided by FreeSurfer. In the future, the Glasser multi-modal pipeline will be implemented (https://doi.org/10.1038/nature18933) to provide better delineation between regions. The atlas currently used is the Destrieux atlas, dividing the cortex into 148 regions with several sub-cortical regions accounted for. For now, this pipeline performs, in order:

  1) Preparation of anatomical volume in FS space

  2) Manual registration of subject brain to FSL (MNI) space

  3) Segmentation of anatomical image in FSL space into tissue types (GM, WM, CSF, etc), using FSL FAST tool

  4) Conversion to MRtrix 5TT (five tissue type) format (includes amygdala and hippocampal structures), this is used for anatomically constrained tractography (ACT), also replaces segmentations estimated by FSL FAST by FSL FIRST

  5) Parcellate and relabel brain regions using Destrieux atlas, giving a parcellation map

  6) Register FS-space subject brain, 5TT image and parcellation map to diffusion space for use in fibre construction
