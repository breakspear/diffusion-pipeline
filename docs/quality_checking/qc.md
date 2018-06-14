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

_Files_: `brainFSnat.nii`
