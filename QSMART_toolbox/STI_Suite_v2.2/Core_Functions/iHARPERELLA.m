function iHARPERELLA
% [TissuePhase]=iHARPERELLA(Laplacian,BrainMask,'voxelsize',voxelsize,'niter',niter);
%
% [2] HARPERELLA: Integrated phase unwrapping and background phase removal
%
% Inputs:
% Laplacian: tissue Laplacian
% BrainMask: Binary Brain Mask
% voxelsize: Spatial resolution, e.g. SpatialRes=[1 1 1];
% niter: Number of Iterations, e.g. nIter= 40;
%
% If optional inputs are not assigned, the following default values will be used.
% voxelsize=[1 1 1];
% niter=100;
% NewMask=BrainMask;
%
% --------------------------------------------------
% Part of STI_Suite_v2.2
% Wei Li, PhD
% Chunlei Liu, PHD
% Brain Imaging And Analysis Center, Duke Uiversity.
% --------------------------------------------------
