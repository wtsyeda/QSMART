function QSMART(path_mag,path_pha,params,path_out)

params.ppm= (params.gyro*params.field)/1e6; %ppm multiplier

% define output directories
params.path_qsm = sprintf('%s/%s/',path_out,params.outfoldername);
mkdir(params.path_qsm); %creates the folder
cd(params.path_qsm); %goes to the new created folder

% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
[mag_all,ph_all,params.iminfo]= readComplexDicoms(path_mag,path_pha);

% initial quick brain mask
mask=brainmask(data,params);

% coil combination
[ph_corr,mag_corr]=coil_comb(mag_all,ph_all,params.iminfo.resolution,params.iminfo.echo_times,mask,params.phase_encoding,params.coilcombmethod);

% Generating mask of vasculature
vasc_only= vasculature_mask(mag_corr,mask,params);

% Phase unwrapping
unph=unwrap_phase(ph_corr,mask,params.iminfo.resolution, params.ph_unwrap_method);

% Echo fit - fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs,R_0] = echofit(unph,mag_corr,0,params);

% cleaning the total field shift to find local field shift
lfs_sdf = QSMART_SDF(tfs,mask,R_0,[],1,params);
   
disp('---runnig QSM inversion step 1---');
chi_iLSQR_1 = QSM_iLSQR(lfs_sdf,mask.*R_0,'H',params.iminfo.z_prjs,'voxelsize',params.iminfo.resolution,...
              'niter',50,'TE',1000,'B0',params.field);
nii = make_nii(chi_iLSQR_1,params.iminfo.resolution); save_nii(nii,'QSM_1.nii');

disp('---runnig QSM inversion step 2---');
lfs_sdf_2 = QSMART_SDF(tfs,mask,R_0,vasc_only,2,params);
chi_iLSQR_2 = QSM_iLSQR(lfs_sdf_2,mask.*vasc_only.*R_0,'H',params.iminfo.z_prjs,'voxelsize',params.iminfo.resolution,...
              'niter',50,'TE',1000,'B0',params.field);
nii = make_nii(chi_iLSQR_2,params.iminfo.resolution); save_nii(nii,'QSM_2.nii');

% Combining 2-stage chi maps
adjust_offset(mask.*R_0 - vasc_only,lfs_sdf,chi_iLSQR_1,chi_iLSQR_2,params);

% Resharp for comparison
if params.resharp.doResharp
    resharp_chi(tfs,mask.*R_0,params);
end
    
 disp('--- Process Finished ---');