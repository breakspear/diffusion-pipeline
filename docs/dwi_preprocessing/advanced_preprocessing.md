# Advanced preprocessing

The pipeline uses several FSL and MRtrix functions to process the diffusion images prior to anatomical correction and tract generation. Specifically it performs the following:

  1) DWI denoising (output as `rawdataAPdn.mif` and `rawdataPAdn.mif`)

  2) DWI distortion correction using eddy and topup (`eddycorr.mif` and `eddymeanb0.nii`)

  3) Bias correction using ANTS N4 correction on the B0 image applied to the denoised, distortion corrected DWI images (`biascorr.mif` and `biasmeanb0.nii`)

  4) Creates an optimal mask from the B0 image (`iterbrainmask.nii`)

  5) Creates the diffusion tensor and fractional anisotropy image (`dt.nii` and `fa.nii`)

More details on all of these steps can be found at http://mrtrix.readthedocs.io/en/latest/

## Study-specific details to note

Only studies with reverse phase encoded b0 pair(s) can be used in the pipeline without some reworking. Please read the details as described at http://mrtrix.readthedocs.io/en/latest/dwi_preprocessing/dwipreproc.html.
