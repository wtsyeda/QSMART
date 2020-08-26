function mp2rage_dcm2nii(path_mag,outfolder)

nii_outfolder=sprintf('%s/dicom2nii/',outfolder);
mkdir(nii_outfolder)

mag_list = dir([path_mag '/**/*.dcm']);
dicom_folder=mag_list(1).folder;

system(sprintf('module load mricron; dcm2nii -o %s %s ',nii_outfolder,dicom_folder));


