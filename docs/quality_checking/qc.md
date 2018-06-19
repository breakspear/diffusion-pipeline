# Quality checking diffusion data

## Preprocessing

### 1. Motion and severe geometric distortions

_Files_: `rawdataAPdn.mif` (raw diffusion data - denoised)

_Steps_: Scroll through each volume of the diffusion data in FSLeyes or FSLview.

_Things to look out for_: 

* Severe "zebra-like" blurring in diffusion signal
* Complete slice (due to high head motion, see below) or signal dropout
* Severe geometric warping of images

### 2. Repeat checking of slice signal loss and dropout, after eddy and bias-correction has been performed

_Files_: `biascorr.mif` (full preprocessed diffusion data)

_Steps_: As above, scroll through each volume of the diffusion data

_Things to look out for_:

* If `eddy` has correction (i.e. restored) the slice signal dropout

### 3. FA image appears regular (to complete)

_Files_: `fa.nii`

_Steps_: Open within FSLeyes or FSLview

_Things to look out for_:

* White matter tracts/bundles (and tissue) appear biologically realistic, with the strongest signal in major tracts (i.e. SLF, UC, etc).

### 4. Check accuracy of skull-stripping for the diffusion data

_Files_: `fa.nii`, `iterbrainmask.nii` or `biasmeanb0bet_mask.nii.gz` (as overlay)

_Things to look out for_:

* Accuracy of binary brain mask - that is, the skull-stripping is not over-conservative or too liberal

### 5. Segmentation and coregistration

_Files_: `brainFSnat.nii`, `5TT.nii` (as overlay)

_Steps_: Scroll through each volume of 5TT file.

_Things to look out for_:

* Classification of white matter, grey matter are biologically plausible
* Known issues:
	* Grey matter segments are missing, white matter extends to skull
	* White matter classification is scarce, missing areas near the cortical layers

### 6. Inspect parcellation files

_Files_: `brainFSnat.nii`, `parc_fixsubcort.nii` (as overlay)

_Steps_: Overlay parcellation file on T1 image, render colour to random.

_Things to look out for_:

* Parcellation ribbon should nicely follow cortical layers
* Subcortical structures appear accurate, and are spatially consistent with tissue boundaries in T1 image

### 7. Co-registration accuracy between diffusion and T1 image

_Files_: `rFS.nii`, `fa.nii` (as overlay)

* If using FSLview, select rFSrg.nii

_Steps_: Overlay FA image on co-registered T1 image (now in diffusion space)

* To ease identification of co-registration accuracy, in FSLeyes increase the minimum threshold for the FA image

* This will filter out the weak or noisy voxels

_Things to look out for_:

* Strong (filtered) white matter populations should nicely reside within the white matter on the T1 image

_Files_: `r5TT.nii`, `fa.nii` (as overlay)

_Steps_: Overlay 5TT image (now in diffusion space) on FA image

* Scroll through WM and GM volumes of 5TT file

_Things to look out for_:

* As above, the tissue-segmentations should be biologically consistent with the boundaries in the diffusion image
