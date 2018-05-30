.. conversion to nifti:

Converting to NiFTI
======================

To convert your structural (T1-weighted) scans from DICOMs (the format that will most likely come be given to you from the scanner), you will need to do the following:

.. code-block:: console

  $ mrinfo HIRF_MRI/
  mrinfo: [done] scanning DICOM folder "HIRF_MRI"
  Select series ('q' to abort):
   0 -  192 MR images 11:33:16 t1_mprage_sag_p2_iso (*tfl3d1_16ns) [6] ORIGINAL PRIMARY M ND NORM
   1 -   30 MR images 11:36:33 t2_tirm_tra_dark-fluid (*tir2d1_16) [7] ORIGINAL PRIMARY M ND NORM
   2 -   96 MR images 11:45:11 Mag_Images (*swi3d1r) [8] ORIGINAL PRIMARY M ND NORM
   3 -   96 MR images 11:45:12 Pha_Images (*swi3d1r) [9] ORIGINAL PRIMARY P ND
   4 -   89 MR images 11:45:23 mIP_Images(SW) (*swi3d1r) [10] ORIGINAL PRIMARY MNIP ND NORM
 ?

You should then enter the integer corresponding to the image set of interest. For example, for the structural images in this study:

.. code-block:: console

  ...

  ? 5
  mrinfo: [100%] reading DICOM series "t1_mprage_sag_p2_iso"
  ************************************************
  Image:               "15/MHS/94 PE002 (MHS94002) [MR] t1_mprage_sag_p2_iso"
  ************************************************
    Dimensions:        192 x 256 x 256
    Voxel size:        0.9 x 0.9375 x 0.9375
    Data strides:      [ 3 -1 -2 ]
    Format:            DICOM
    Data type:         unsigned 16 bit integer (little endian)
    Intensity scaling: offset = 0, multiplier = 1
    Transform:               0.9963     0.01191     0.08533      -96.39
                         -0.01386      0.9997     0.02238      -95.59
                         -0.08503    -0.02348      0.9961      -93.81
    EchoTime:          0.00232
    PhaseEncodingDirection: j-
    TotalReadoutTime:  0
    comments:          15/MHS/94 PE002 (MHS94002) [MR] t1_mprage_sag_p2_iso
                       study: Research Brain Christine's FMRI [ ORIGINAL PRIMARY M ND NORM ]
                       DOS: 03/02/2016 11:33:16


Processing this file to NiFTI:
-----------------------------

Using the following command, we can convert our scanner images to the right format for use in the diffusion pipeline:

.. code-block:: console

  $ echo "0" | mrconvert HIRF_MRI/ T1.nii -strides +1,2,3
  mrconvert: [done] scanning DICOM folder "HIRF_MRI/"
  Select series ('q' to abort):
   0 -  192 MR images 11:33:16 t1_mprage_sag_p2_iso (*tfl3d1_16ns) [6] ORIGINAL PRIMARY M ND NORM
   1 -   30 MR images 11:36:33 t2_tirm_tra_dark-fluid (*tir2d1_16) [7] ORIGINAL PRIMARY M ND NORM
   2 -   96 MR images 11:45:11 Mag_Images (*swi3d1r) [8] ORIGINAL PRIMARY M ND NORM
   3 -   96 MR images 11:45:12 Pha_Images (*swi3d1r) [9] ORIGINAL PRIMARY P ND
   4 -   89 MR images 11:45:23 mIP_Images(SW) (*swi3d1r) [10] ORIGINAL PRIMARY MNIP ND NORM
  mrconvert: [100%] reading DICOM series "t1_mprage_sag_p2_iso"
  mrconvert: [100%] copying from "15/MHS/94 ...) [MR] t1_mprage_sag_p2_iso" to "T1.nii"

We use the option ``-strides +1,2,3`` as it provides the orientation of the cardinal directions of images and +1,2,3 puts it in "radiographer's" format. NOTE: This command is only valid for MRtrix release candidate 3.0. Otherwise use the option

.. code-block:: console

  -stride +1,2,3

We can also pipe the output e.g.:

.. code-block:: console

  $ echo "0" |

To automatically select our set of interest in the ``mrconvert`` command. This raw structural image (i.e. T1.nii) will need to be sent to our study directory in the following structure:

.. code-block:: console

  $ tree my-working-dir/

  |-- Raw
  |   `-- sub1
  |       |-- rawdataAP.mif
  |       |-- rawdataPA.mif
          `-- T1.nii

Where ``sub1`` is simply the name of your subject. If you have more than one subject, make sure they each have their own folder in the Raw directory with their corresponding raw files inside as above.

  
