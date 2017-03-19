# QIMR Diffusion Pipeline

## Setup information


### 1. Install the github package
   * Ensure your current working directory is your home directory on avalon. E.g. `cd  ~` or `cd /mnt/lustre/home/$USER`
   * `git clone https://github.com/breakspear/diffusion-pipeline.git`
### 2. Setup required software for the pipeline
   * Copy and paste the lines from the .bashrc file (located in the /data folder) into your user .bashrc file located in the home directory 
   * Or, copy the file directly into your home directory
   * You may need to restart your session browser for the software to be sourced correctly
### 3. Locate image files from the scanner DICOM folders
   * This DICOM data should be stored on the L-Drive or R-Drive (where users only have read access)
   * The scanner will presumably give you image data in a set of DICOM folders
   * Each folder should correspond to separate scanning sequences:
     ![folders](https://cloud.githubusercontent.com/assets/23441440/24085970/ec2e0d5e-0d51-11e7-905b-1a5991050e2a.png)
   * The image folders of interest here are the diffusion sequences for: 
     + A P diffusion sequence (AP_OCD_MB_BLOCK1_DIFF_88DIR_0011)
     + P A diffusion sequence (PA_OCD.. etc)
     + And, the structural T1-image (either MPRAGE or MP2RAGE)
### 4. Extract all the images with MRtrix
   * There should be a parent directory called Raw, with the subfolders corresponding to each subject:
     ![subfolders](https://cloud.githubusercontent.com/assets/23441440/24085971/f05c659c-0d51-11e7-9938-a7c83b3ed7b4.png)
   * Within each subject folder, unpack the DICOM’s into corresponding image files (note the strides are important!).
   * For example, 
     ```
     mrconvert /path/to/AP_OCD_MB_BLOCK_1_DIFF_88DIR_0012/ rawdataAP.mif -stride +1,2,3,4
     mrconvert /path/to/PA_DICOM rawdataAP.mif -stride +1,2,3,4
     mrconvert /path/to/T1_DICOM T1.nii -stride +1,2,3
     ```
### 5. Copy the Raw folder directory to the avalon /working space
   * Working directory is the scratch space
     + The storage capacity of each home directory (10GB, which is backed up nightly) is too small for diffusion purposes
   * The location of your working scratch space will depend on your group leader
     + For myself, it is /working/lab_michaebr/alistaiP
   * rsync the Raw folder into the desired project directory 
     + `rsync -vaz Raw /working/lab_michaebr/alistaiP/Park/`

## Processing the data
 
There are 4 scripts to be called 

1. `sh workingdirectory processFSall`
2. (perform all diffusion steps)
   ```
   edit include 
   sh workingdirectory dtiadvfullsetup
   ```
