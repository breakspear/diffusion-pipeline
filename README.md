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
     + For myself, it is `/working/lab_michaebr/alistaiP`
   * rsync the Raw folder into the desired project directory
     + `rsync -vaz Raw /working/lab_michaebr/alistaiP/Park`

## The functionality of the pipeline

### 1. Calling the scripts
  * The scripts function in that everything is run by a master `dticon` command - located within the package folder
  * This `dticon` command is required to be called with the compulsory arguments:
     + The location of the project directory (i.e `/working/lab_michaebr/alistaiP/Park`)
     + And the desired script of diffusion preprocesing options. 
  * These individual preprocessing scripts include:
     + processFSall (using Freesurfer, cortical reconstruction of T1 images)
     + advpreproc (full diffusion preprocessing)
     + segparcandcoregT1 (FSL segmentation, parcellation, and co-registration of the T1 image)
     + advfibertrackandcntmecon (fiber tracking and connectome construction)
  * It picks up the basic template of the scripts from `dtiblank`, and inserts the subject-specific and script-specific details
  * Each subject-specific script will be then placed within the folder `batch`, where users can submit their jobs to the avalon PBS nodes
  
## Running the whole diffusion pipeline

### 1. Freesurfer construction of T1 images

   * For the diffusion  pipeline to be run, first the subjects must be processed using freesurfer's recon-all (https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all)

   * All that needs to be done, is call the `dticon` script - along with the project directory (make sure the last backspace is removed) and the script name as the arguments. For example,
     
     sh dticon /working/lab_michaebr/alistaiP/Park processFSall  
     cd batch
     find . -name "-sh" -exec qsub {} \; # (send all the jobs to the batch scheduler)
     ```
  
   * The Freesurfer output will be placed within a parent directory called `FS` (located within the project directory) - for which the subsequent pipeline steps will look for.
  
### 2. Perform the preprocessing, and fiber construction methods
  
   * To perform all the diffusion steps (i.e. from preprocessing to connectome construction), the individual scripts above are actualy embedded within a setup script `advfulldiffsetup`.
   * You will need to edit it's user-specific options before calling the `dticon` script
   * Required inputs are: 
    + ismosaic - is data acquired with moasic DICOM extraction (1 if yes)
    + isfullrevsequence - is a full sequence acquired in the opposite phase encoding direction (i.e. P A) (1 if yes)
    + ismultiband - is data acquired with multiple slice acquisition (1 if yes)
    + parc - FS parcellation to choose (options are DESIKAN "DES" or DESTRIEUX "DST")
    + ismultishell - is data acquired with multiple b-value weightings (1 if yes)
    + numfibers - number of whole brain fibers for whole brian tractography
  
  
  
  
  
There are 4 scripts to be called 

1. `sh workingdirectory processFSall`
2. (perform all diffusion steps)
   ```
   edit include 
   sh workingdirectory dtiadvfullsetup
   ```
