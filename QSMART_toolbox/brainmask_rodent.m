function mask=brainmask_rodent(mag_all,params)

% Setting MATLAB path to call ANTs
% myPATH=[getenv('PATH') sprintf(':%s',params.antspath)];
% setenv('PATH',myPATH);
% setenv('ANTSPATH',params.antspath);

% Generating magnitude image from uncombined complex data
mag_sos = sqrt(sum(mag_all.^2,5));

% Optimal echo averaging
SNRimg= calculate_SNRmap_emp(mag_sos,params);
nii=make_nii(SNRimg,params.iminfo.resolution);
save_nii(nii,'MGE_mag_SNR.nii',params.iminfo.resolution);

% Biasfield correction
system('module load ants/1.9.v4; N4BiasFieldCorrection -d 3 -i MGE_mag_SNR.nii -o mag_SNR_n4bfc_img.nii')

if strcmp(params.brainmaskmethod,'FSL')
    
    % Manuplating voxel size to work with human BET
    nii=load_nii('mag_SNR_n4bfc_img.nii'); nii=make_nii(nii.img); save_nii(nii,'MGE_mag_SNR_res1.nii');
    
    %BET
    system(sprintf('module load fsl/6.0.3; bet MGE_mag_SNR_res1.nii brain -m  -f %f',params.fslbet.f));
    system('rm MGE_mag_SNR_res1.nii');
    
elseif strcmp(params.brainmaskmethod,'ANTS')
    
    % Registering to mouse brain atlas
    [atlaspath,brainmaskpath] = reorientAtlas(params);
    system(sprintf('module load ants/1.9.v4; antsRegistrationSyN.sh -d 3 -f %s -m mag_SNR_n4bfc_img.nii -o atlas_mag_SNR_ -n 8',atlaspath))
    
    % Estimating mask
    system(sprintf('module load ants/1.9.v4; antsApplyTransforms -d 3 -i %s -t [atlas_mag_SNR_0GenericAffine.mat, 1] -t atlas_mag_SNR_1InverseWarp.nii.gz -r mag_SNR_n4bfc_img.nii -n NearestNeighbor -o brain_mask.nii.gz',brainmaskpath))
    
    % Removing temp atlas files
    system(sprintf('rm %s',atlaspath));
    system(sprintf('rm %s',brainmaskpath));
    
end

% reading in mask
mask= single(niftiread('brain_mask.nii.gz'));
nii = load_nii('mag_SNR_n4bfc_img.nii');
BET_map=single(nii.img).*mask;

if params.adaptive_threshold
     params.mag_threshold = prctile(BET_map(BET_map~=0),params.mag_thresh_percentile);
     fprintf('Setting adaptive magnitue threshold at %2.2f \n',params.mag_threshold);
end

mask(BET_map<params.mag_threshold)=0;
mask = bwmorph3(mask,'majority');
% close the mask
SE = strel('sphere',params.sph_radius1);
mask = imclose(mask,SE);
nii = make_nii(double(mask),params.iminfo.resolution);
save_nii(nii,'brain_mask_processed.nii');


