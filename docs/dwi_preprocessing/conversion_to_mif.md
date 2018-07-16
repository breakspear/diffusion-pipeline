# Conversion to MIF (Medical Image File)

Much like the structural images, the diffusion images will need to be converted from DICOM to .mif, MRtrix's own format for processing files. This is done in much the same way:

```

  $ mrinfo HIRF_MRI/
  mrinfo: [done] scanning DICOM folder "HIRF_MRI"
  Select series ('q' to abort):
     0 -  192 MR images 11:33:16 t1_mprage_sag_p2_iso (*tfl3d1_16ns) [6] ORIGINAL PRIMARY M ND NORM
     1 -   30 MR images 11:36:33 t2_tirm_tra_dark-fluid (*tir2d1_16) [7] ORIGINAL PRIMARY M ND NORM
     2 -   96 MR images 11:45:11 Mag_Images (*swi3d1r) [8] ORIGINAL PRIMARY M ND NORM
     3 -   96 MR images 11:45:12 Pha_Images (*swi3d1r) [9] ORIGINAL PRIMARY P ND
     4 -   89 MR images 11:45:23 mIP_Images(SW) (*swi3d1r) [10] ORIGINAL PRIMARY MNIP ND NORM
     5 -   96 MR images 11:45:23 SWI_Images (*swi3d1r) [11] ORIGINAL PRIMARY M SWI ND NORM
     6 -  192 MR images 11:59:16 t1_mp2rage_sag_p3_iso_INV1 (*tfl3d1_16ns) [12] ORIGINAL PRIMARY M ND NORM
     7 -  192 MR images 11:59:16 t1_mp2rage_sag_p3_iso_INV2 (*tfl3d1_16ns) [13] ORIGINAL PRIMARY M ND NORM
     8 -  192 MR images 11:59:18 t1_mp2rage_sag_p3_iso_UNI_Images (*tfl3d1_16ns) [14] DERIVED PRIMARY M ND UNI
     9 -   30 MR images 12:01:45 t2_tse_tra (*tse2d1_18) [15] ORIGINAL PRIMARY M ND NORM
    10 -  102 MR images 12:03:36 ep2d_diff_b3k_90dir_11b0_AP (*ep_b3000#27) [16] ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC
    11 -    9 MR images 12:33:34 ep2d_diff_b3k_1dir7b0_PA180 (*ep_b3000#8) [17] ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC
  ?

```

To perform EPI inhomogeneity correction, we will need both the raw anterior-posterior phase-encoded image and the raw posterior-anterior phase-encoded image. These are often labelled "AP" or "PA" and "diff". These can also be labelled as "B_0" or "B0" for the PA direction, while the AP direction will have many images (sometimes up to 120 images for each direction).

## Conversion:

Look closer at these images by selected the image set of interest. For example:

```

  ...
  ? 10
  mrinfo: [100%] reading DICOM series "ep2d_diff_b3k_90dir_11b0_AP"
  ************************************************
  Image:               "15/MHS/94 PE002 (MHS94002) [MR] ep2d_diff_b3k_90dir_11b0_AP"
  ************************************************
    Dimensions:        128 x 128 x 90 x 102
    Voxel size:        1.71875 x 1.71875 x 1.7 x ?
    Data strides:      [ -1 -2 3 4 ]
    Format:            DICOM
    Data type:         unsigned 16 bit integer (little endian)
    Intensity scaling: offset = 0, multiplier = 1
    Transform:                0.996     0.03461     0.08242      -115.6
                           -0.02333      0.9907     -0.1341      -80.63
                            -0.0863      0.1316      0.9875      -42.11
    EchoTime:          0.082
    PhaseEncodingDirection: j-
    TotalReadoutTime:  0.0473
    comments:          15/MHS/94 PE002 (MHS94002) [MR] ep2d_diff_b3k_90dir_11b0_AP
                       study: Research Brain Christine's FMRI [ ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC ]
                       DOS: 03/02/2016 12:03:36
    dw_scheme:         0,0,0,0
    [102 entries]      0,0,0,0
                       ...
                       0.48021215,-0.85957265000000005,-0.17473174999999999,3000
                       0,0,0,0

```

We can convert this image in much the same way as we did the T1 image:

```

  $ echo "10" | mrconvert HIRF_MRI/ rawdataAP.mif -strides +1,2,3,4
  mrconvert: [done] scanning DICOM folder "HIRF_MRI"
  Select series ('q' to abort):
     0 -  192 MR images 11:33:16 t1_mprage_sag_p2_iso (*tfl3d1_16ns) [6] ORIGINAL PRIMARY M ND NORM
     1 -   30 MR images 11:36:33 t2_tirm_tra_dark-fluid (*tir2d1_16) [7] ORIGINAL PRIMARY M ND NORM
     2 -   96 MR images 11:45:11 Mag_Images (*swi3d1r) [8] ORIGINAL PRIMARY M ND NORM
     3 -   96 MR images 11:45:12 Pha_Images (*swi3d1r) [9] ORIGINAL PRIMARY P ND
     4 -   89 MR images 11:45:23 mIP_Images(SW) (*swi3d1r) [10] ORIGINAL PRIMARY MNIP ND NORM
     5 -   96 MR images 11:45:23 SWI_Images (*swi3d1r) [11] ORIGINAL PRIMARY M SWI ND NORM
     6 -  192 MR images 11:59:16 t1_mp2rage_sag_p3_iso_INV1 (*tfl3d1_16ns) [12] ORIGINAL PRIMARY M ND NORM
     7 -  192 MR images 11:59:16 t1_mp2rage_sag_p3_iso_INV2 (*tfl3d1_16ns) [13] ORIGINAL PRIMARY M ND NORM
     8 -  192 MR images 11:59:18 t1_mp2rage_sag_p3_iso_UNI_Images (*tfl3d1_16ns) [14] DERIVED PRIMARY M ND UNI
     9 -   30 MR images 12:01:45 t2_tse_tra (*tse2d1_18) [15] ORIGINAL PRIMARY M ND NORM
    10 -  102 MR images 12:03:36 ep2d_diff_b3k_90dir_11b0_AP (*ep_b3000#27) [16] ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC
    11 -    9 MR images 12:33:34 ep2d_diff_b3k_1dir7b0_PA180 (*ep_b3000#8) [17] ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC
    12 -   13 MR images 12:38:58 ep2d_diff_B1000 12 DIRECTIONS (*ep_b1000#3) [18] ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC
  mrconvert: [100%] reading DICOM series "ep2d_diff_b3k_90dir_11b0_AP"
  mrconvert: [100%] reformatting DICOM mosaic images
  mrconvert: [100%] copying from "15/MHS/94 ...ep2d_diff_b3k_90dir_11b0_AP" to "rawdataAP.mif"

```

To check that this was performed correctly, we can look at the converted image:

```

  $ mrinfo rawdataAP.mif
  ************************************************
  Image:               "rawdataAP.mif"
  ************************************************
    Dimensions:        128 x 128 x 90 x 102
    Voxel size:        1.71875 x 1.71875 x 1.7 x ?
    Data strides:      [ 1 2 3 4 ]
    Format:            MRtrix
    Data type:         unsigned 16 bit integer (little endian)
    Intensity scaling: offset = 0, multiplier = 1
    Transform:                0.996     0.03461     0.08242      -115.6
                           -0.02333      0.9907     -0.1341      -80.63
                            -0.0863      0.1316      0.9875      -42.11
    EchoTime:          0.082
    PhaseEncodingDirection: j-
    TotalReadoutTime:  0.0473
    command_history:   mrconvert "HIRF_MRI" "rawdataAP.mif" "-stride" "+1,2,3,4"  (version=3.0_RC2-117-gf098f097)
    comments:          15/MHS/94 PE002 (MHS94002) [MR] ep2d_diff_b3k_90dir_11b0_AP
                       study: Research Brain Christine's FMRI [ ORIGINAL PRIMARY DIFFUSION NONE ND MOSAIC ]
                       DOS: 03/02/2016 12:03:36
    dw_scheme:         0,0,0,0
    [102 entries]      0,0,0,0
                       ...
                       0.48021215,-0.85957265000000005,-0.17473174999999999,3000
                       0,0,0,0
    mrtrix_version:    3.0_RC2-117-gf098f097

```

Do the same for the PA-encoded image. Copy these files to the Raw folder in your working directory. If the Raw folder does not exist, create it with:

```

  $ cd /working/your_lab_here/your_username/your_working_dir
  $ mkdir Raw/

```

## Running the advanced preprocessing

NOTE: RUN `processFSall` BEFORE RUNNING THIS SCRIPT!

We can run the advanced pipeline on our diffusion images, using the structural images to constrain the tract generation (as described in http://mrtrix.readthedocs.io/en/latest/quantitative_structural_connectivity/act.html). We can use the script advfulldiffsetup to process our diffusion images automatically. Make sure the settings in this file are set correctly. These parameters are:

`ismultiband`: If the diffusion acquisition is multi-band, make sure this is set to `1`. If not, set to `0`.

`parc`: The default (and currently only atlas supported) is `DST` (Destrieux). Do not change this.

`ismultishell`: If the diffusion acquisition is multi-shell, this needs to be set to `1`. Again, if not, set to `0`.

`numfibers`: This can be changed, but the default of 25 million is enough to provide whole-brain coverage.

For example, if you wanted to process a single-shell, multi-band scanner setup with DST parcellation and 25 million fibers:

``` 
 $ cd ~/diffusion-pipeline
 $ vi advfulldiffsetup
 #!/bin/bash 
 #file: advfulldiffsteps

 subj=$1
 WORKDIR=$2
 #FS_DIR=$3

 #arguments to be set
 ismultiband=1
 parc=DST
 ismultishell=0
 numfibers=25M

  #Full diffusion pipeline, from pre-processing to connectome construction - using the advanced version

 #Advanced preprocessing
 #Parameters: multiband (1 if yes)

 advpreproc $subj $WORKDIR $ismultiband

 #Segmentation, parcellation and co-registration of T1 images

 segparcandcoregT1 $subj $WORKDIR $parc

 #Fiber construction and connectome construction

 advfibertrackandcntmecon $subj $WORKDIR $ismultishell $numfibers $parc

```

Note that currently the only atlas parcellation used in the pipeline is Destrieux (148 regions) (https://surfer.nmr.mgh.harvard.edu/fswiki/CorticalParcellation). This is planned to be replaced by the Glasser multi-modal parcellation (https://doi.org/10.1038/nature18933). 

## Setting up the scripts

Setup the subject batch scripts similarly to the FS processing command via:

```
  $ cd ~/diffusion-pipeline
  $ sh dticon /working/your_lab_here/your_username/your_working_dir/ advfulldiffsetup
  $ cd /working/your_lab_here/your_username/your_working_dir/batch
  $ qsub advfulldiffsetup_yoursub.sh

```

Check on the status of your jobs via:

  `$ qstat -n -u $USER`
  
