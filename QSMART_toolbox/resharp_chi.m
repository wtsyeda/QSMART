function [chi_iLSQR_resharp,lfs_resharp,mask_resharp] = resharp_chi(tfs,mask,params)

tic
[lfs_resharp, mask_resharp,fid_term,reg_term] = resharp(tfs,mask,params.iminfo.resolution,params.resharp.smv_rad,params.resharp.tik_reg,params.resharp.cgs_num);
lfs_resharp=lfs_resharp*params.ppm;
toc
% save nifti
str_lambda=num2str(params.resharp.tik_reg);
nii = make_nii(lfs_resharp,params.iminfo.resolution);
save_nii(nii,['lfs_resharp_smvrad1_' str_lambda '.nii']);

chi_iLSQR_resharp = QSM_iLSQR(lfs_resharp,mask_resharp,'H',params.iminfo.z_prjs,'voxelsize',params.iminfo.resolution,...
                    'niter',50,'TE',1000,'B0',params.field);
nii = make_nii(chi_iLSQR_resharp,params.iminfo.resolution); save_nii(nii,'QSM_resharp.nii');
try; reorient_nii('QSM_resharp.nii');end