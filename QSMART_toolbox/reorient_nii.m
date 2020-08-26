function reorient_nii(nii)

system(sprintf('module load fsl; fslswapdim %s x -y z %s_reoriented',nii,nii)); 

 system(sprintf('module load fsl; fslcpgeom  dicom2nii/*.nii.gz %s -d',nii)); 