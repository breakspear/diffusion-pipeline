#!/bin/bash

# All required resource statements start with "#PBS -l"
# These will be interpreted by the job submission system (PBS pro)

cpus=8
#PBS -l select=1:ncpus=8:mem=8G
#
# *select* is the number of parallel processes
# *ncpus* is the number of cores required by each process
# *mem* is the amount of memory required by each process

#PBS -l walltime=47:00:00
# *walltime* is the total time required in hours:minutes:seconds
# to run the job. 
# Warning: all processes still running at the end of this period
# of time will be killed and any temporary data will be erased.

#PBS -m abe 
#NOTE : ENTER YOUR EMAIL HERE
# *m* situations under which to email a) aborted b) begin e) end
# *M* email address to send emails to

DIRECTORY=/working/lab_michaebr/alistaiP/diffusion-testing/1602/Diff/philrevb0

SUBJECTS_DIR=/working/lab_michaebr/alistaiP/diffusion-testing/1602/T1s
subj=MPRAGE

cd $DIRECTORY

#Extract encoding

mrinfo rawdataAP.mif -export_grad_mrtrix rawencoding.b
mrinfo rawdataPA.mif -export_grad_mrtrix rawrevencoding.b

mrconvert rawdataAP.mif rawdataAP.nii -force -nthreads $cpus
fslroi rawdataAP.nii rawdataAPrem 1 89

sed '1d' rawencoding.b > rawencodingrem.b
mrconvert rawdataAPrem.nii.gz rawdataAPrem.mif -force -grad rawencodingrem.b -stride +1,2,3,4

mv rawdataAPrem.mif rawdataAP.mif

dwiextract rawdataPA.mif -bzero rawdataPArem.mif -force
mv rawdataPArem.mif rawdataPA.mif

mkdir preproc 

rsync *rawdata* preproc

rsync T1.nii preproc

cd preproc

#Denoise

dwidenoise rawdataAP.mif rawdataAPdn.mif -force -nthreads $cpus
dwidenoise rawdataPA.mif rawdataPAdn.mif -force -nthreads $cpus

mrconvert rawdataAPdn.mif rawdataAPdnstr.mif -stride +1,2,3,4 -force -nthreads $cpus
mrconvert rawdataAPdnstr.mif  rawdataAPdn.mif  -force -nthreads $cpus

mrconvert rawdataPAdn.mif rawdataPAdnstr.mif -stride +1,2,3,4 -force -nthreads $cpus
mrconvert rawdataPAdnstr.mif  rawdataPAdn.mif -stride +1,2,3,4 -force -nthreads $cpus

rm rawdataAPdnstr.mif
rm rawdataPAdnstr.mif 

#Generate a b0 base image for each phase-encoding direction

mrconvert rawdataAPdn.mif b0AP.mif -coord 3 0 -force -nthreads $cpus
mrconvert rawdataPAdn.mif b0PA.mif -coord 3 0 -force -nthreads $cpus

#Preprocessing steps including eddy correction & bias correction

dwiextract rawdataAPdn.mif APb0s.mif -bzero -force

dwipreproc_mb -rpe_pair APb0s.mif  rawdataPAdn.mif -export_grad_mrtrix adjencoding.b AP rawdataAPdn.mif eddycorr.mif -nthreads $cpus -verbose -force

dwiextract eddycorr.mif -bzero - | mrmath -axis 3 - mean eddymeanb0.nii -force
bet2 eddymeanb0.nii eddymeanb0bet -m -f 0.15

dwibiascorrect -mask eddymeanb0bet_mask.nii.gz -fsl eddycorr.mif biascorr.mif -nthreads $cpus -force


#Create tensor and FA images

dwiextract biascorr.mif -bzero - | mrmath -axis 3 - mean biasmeanb0.nii -force

bet2 biasmeanb0.nii biasmeanb0bet -f 0.15 -m 

dwi2tensor biascorr.mif dt.nii -mask biasmeanb0bet_mask.nii.gz -nthreads $cpus -force

tensor2metric dt.nii -fa fa.nii -nthreads $cpus -force


#Prepare anatomical volume for segmentation, parcellation correction etc

#5ttgen freesurfer $SUBJECTS_DIR/$subj/mri/aparc.a2009s+aseg.mgz  5TTFS.nii -nocrop -sgm_amyg_hipp -lut $FREESURFER_HOME/FreeSurferColorLUT.txt

mrconvert $SUBJECTS_DIR/$subj/mri/brain.mgz brainFS.nii -stride +1,2,3 -nthreads $cpus -force

mrconvert $SUBJECTS_DIR/$subj/mri/T1.mgz FS.nii -stride +1,2,3 -nthreads $cpus -force

#flirt -in $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -ref brainFS.nii -omat mni2FS.mat -dof 12

#convert_xfm -omat FS2mni.mat -inverse mni2FS.mat

#flirt -in $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -ref brainFS.nii -omat FS2mni.mat -dof 12 -applyxfm -init FS2mni.mat

#5ttgen_alt brainFS.nii FS2mni.mat 5TTFSmasked.nii

bet2 T1.nii T1bet -f 0.15

mrconvert $SUBJECTS_DIR/$subj/mri/brain.mgz brainFSsp.nii -nthreads $cpus -force

flirt -ref T1bet.nii.gz -in brainFSsp.nii -dof 6 -out FS2FSL -omat FS2FSL.mat 

bet2 FS2FSL.nii.gz FS2FSLbet -f 0.15 -m

fslmaths T1bet.nii.gz -mas FS2FSLbet_mask.nii.gz T1betFSmasked.nii.gz

fast -B --nopve T1betFSmasked.nii.gz

5ttgen fsl T1betFSmasked.nii.gz -nocrop -premasked -sgm_amyg_hipp 5TTFSmasked.nii -nthreads $cpus -force
 
5tt2gmwmi 5TTFSmasked.nii 5TTgmwmi.nii -nthreads $cpus -force

labelconvert $SUBJECTS_DIR/$subj/mri/aparc.a2009s+aseg.mgz $FREESURFER_HOME/FreeSurferColorLUT.txt $MRtrix/src/connectome/tables/fs_a2009s.txt parc.nii -nthreads $cpus -force

flirt -ref T1bet.nii.gz -in parc.nii -applyxfm -init FS2FSL.mat -interp nearestneighbour -out parcFSL.nii.gz

rm parc_fixsubcort.nii

mrconvert parcFSL.nii.gz parcFSLtempstr.nii.gz -stride -1,2,3 -force -nthreads $cpus

labelsgmfix parcFSLtempstr.nii.gz T1betFSmasked_restore.nii.gz $MRtrix/src/connectome/tables/fs_a2009s.txt parc_fixsubcort.nii -sgm_amyg_hipp -premasked -nthreads $cpus

mrconvert parc_fixsubcort.nii parc_fixsubcortstr.nii -stride +1,2,3 

mv parc_fixsubcortstr.nii parc_fixsubcort.nii

rm parcFSLtempstr.nii.gz


#Coregistrations setup


#FSL co-registration of T1 to diffusion image (& subsequent 5TT file)

#flirt -ref eddyb0.nii -in T1.nii -omat T1FSLtoDiff.mat -dof 6

#transformconvert T1FSLtoDiff.mat T1.nii eddyb0.nii flirt_import T1FSLtoDiffMR.mat -force

#mrtransform 5TTFSL.nii -linear T1FSLtoDiffMR.mat r5TTFSL.nii -force

bbregister --s $subj --mov biasmeanb0bet.nii.gz --init-fsl --reg register.dat --dti --fslmat diff2FS.mat

transformconvert diff2FS.mat biasmeanb0bet.nii.gz $SUBJECTS_DIR/$subj/mri/brain.mgz flirt_import diff2FSMR.mat -force 

mrtransform FS.nii rFS.nii -linear diff2FSMR.mat -inverse -force

mrtransform FS.nii rFSrg.nii -linear diff2FSMR.mat -inverse -template fa.nii -force



#Move other files from T1 space

transformconvert FS2FSL.mat brainFSsp.nii T1bet.nii.gz flirt_import FS2FSLMR.mat -force

mrtransform 5TTFSmasked.nii 5TTFSspmasked.nii -linear FS2FSLMR.mat -inverse -force

mrtransform 5TTgmwmi.nii 5TTFSspgmwmi.nii -linear FS2FSLMR.mat -inverse -force

mrtransform 5TTFSspgmwmi.nii r5TTgmwmi.nii -linear diff2FSMR.mat -inverse -force

mrtransform 5TTFSspmasked.nii r5TT.nii -linear diff2FSMR.mat -inverse -force


convert_xfm -omat FSL2FS.mat -inverse FS2FSL.mat

flirt -ref brainFSsp.nii -in parc_fixsubcort.nii -applyxfm -init FSL2FS.mat -interp nearestneighbour -out parc_fixsubcortFS.nii.gz

convert_xfm -omat FS2diff.mat  -inverse diff2FS.mat

flirt -ref fa.nii -in parc_fixsubcortFS.nii.gz -applyxfm -init FS2diff.mat -out rparc_fixsubcort.nii.gz  -interp nearestneighbour

#mrtransform parc_fixsubcort.nii rparc_fixsubcort.nii -linear diff2FSMR.mat -inverse -interp nearest -template biasmeanb0bet.nii.gz -force


#FS co-registration of T1 to diffusion image (& subsequent 5TT file)


#mrconvert 5TTFSmasked.nii wmseg.nii -coord 3 2

#flirt -ref brain.nii -in fa.nii -out DiffinFS -omat DiffinFS.mat -dof 6 -cost bbr  -wmseg wmseg.nii

#transformconvert DiffinFS.mat b0bet.nii.gz brain.nii flirt_import DiffinFSMR.mat -force

#mrtransform T1FS.nii -linear DiffinFSMR.mat rT1FSbbr.nii -force -inverse

#mrtransform 5TTFSmasked.nii -linear FSinDiffMR.mat r5TTFSmasked.nii -force 


gunzip rparc_fixsubcort.nii.gz


#Multi-tissue spherical deconvolution

dwi2response msmt_5tt biascorr.mif r5TT.nii wm.txt gm.txt csf.txt -mask biasmeanb0bet_mask.nii.gz -nthreads $cpus -force

dwi2fod msmt_csd biascorr.mif wm.txt wm.mif gm.txt gm.mif csf.txt csf.mif -force -mask biasmeanb0bet_mask.nii.gz -nthreads $cpus

mrconvert wm.mif wmstr.mif -stride +1,2,3,4 -nthreads $cpus -force

mv wmstr.mif wm.mif

fod2dec wm.mif  foddec.mif -mask biasmeanb0bet_mask.nii.gz -force -nthreads $cpus

#Fiber tracking

tckgen wm.mif 50M.tck -act r5TT.nii -backtrack -crop_at_gmwmi -seed_dynamic wm.mif -maxlength 250 -number 50000000 -nthreads 10 -mask biasmeanb0bet_mask.nii.gz -output_seeds succeeds.txt -force -nthreads $cpus

tckmap 50M.tck 50M.mif -vox 0.5 -force -nthreads $cpus

tckgen wm.mif 1M.tck -act r5TT.nii -backtrack -crop_at_gmwmi -seed_dynamic wm.mif -maxlength 250 -number 1000000 -nthreads 10 -mask biasmeanb0bet_mask.nii.gz -output_seeds succeeds.txt -force -nthreads $cpus

tckmap 1M.tck 1M.mif -vox 0.5 -force -nthreads $cpus


#tcksift2

tcksift2 50M.tck wm.mif sift_weightfactor.txt -act r5TT.nii -fd_scale_gm -force -nthreads $cpus

tcksift2 1M.tck wm.mif 1Msift_weightfactor.txt -act r5TT.nii -fd_scale_gm -force -nthreads $cpus


#Connectome construction

tck2connectome 50M.tck rparc_fixsubcort.nii streamweights.csv -tck_weights_in sift_weightfactor.txt -assignment_radial_search 2 -zero_diagonal -out_assignments streamlineassignment.txt -force

tck2connectome 50M.tck rparc_fixsubcort.nii invlengthweights.csv -tck_weights_in sift_weightfactor.txt -assignment_radial_search 2 -zero_diagonal -scale_invlength -force

tck2connectome 50M.tck rparc_fixsubcort.nii invnodelengthweights.csv -tck_weights_in sift_weightfactor.txt -assignment_radial_search 2 -zero_diagonal -scale_invlength -scale_invnodevol -force

tck2connectome 50M.tck rparc_fixsubcort.nii meanfiberlengths.csv -tck_weights_in sift_weightfactor.txt -assignment_radial_search 2 -zero_diagonal -scale_length -stat_edge mean -force


#Alter sift tracks for visualisation

tckedit 1M.tck -tck_weights_in 1Msift_weightfactor.txt  1Msift.tck -force -nthreads $cpus

tckmap 1Msift.tck 1Msift.mif -vox 0.5 -force -nthreads $cpus

 
