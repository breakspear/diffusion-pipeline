# Custom parcellations

Exploiting the common MNI 1mm template space, we can coregister individual subject diffusion images with custom parcellations. 
### Note: This step must be run after the main diffusion pipeline!
This script entails obtaining the parcellation you wish to use in MNI 1mm space, running `labelconvert` if the labels of the
parcellation don't start at 1 and increment sequentially (i.e. 1 to 300 for a 300 region parcellation), and then running the code as below:

```
sh dticon /working/... cntmecon_template *numfibers* *parc-(absolute)-location* *parcname*
```

Replace &ast;these&ast; with what you need. Notice there is also an option for specifying the number of fibres in the tractogram
you need. If the file doesn't exist (for instance, if you want more than 25M streamlines), the script will create that file for you.
For example, if you wanted to use the Schaefer 400 parcellation, you might run:

```
sh dticon /working/lab_here/your_name/working_dir/ cntmecon_template 50M ~/data/schaefer_in_MNI.nii Schaefer
cd /working/lab_here/your_name/working_dir/batch/
qsub cntmecon_template_sub1.sh
```
Once this is complete, you can find the files in `/working/lab_here/your_name/working_dir/Diff/sub1/preproc/parc_name/`. In this case
it would be `Schaefer`. This includes the parcellation in diffusion space and all of the connectomes as the main diffusion pipeline but
now accommodating the number of regions in your custom parcellation and the weights for the number of streamlines if you wanted to specify that.
