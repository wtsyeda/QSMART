function QSM_iLSQR
%[Susceptibility]= QSM_iLSQR(TissuePhase,BrainMask,'H',H,'voxelsize',voxelsize,'padsize',padsize,'niter',niter,'TE',TE,'B0',B0);
%[Susceptibility]= QSM_iLSQR(TissuePhase,NewMask,'params',params);
%
% [4] iLSQR: Quantative Susceptibility Mapping
%
% Inputs:
% TissuePhase: tissue phase
% SpatialRes: Spatial resolution
% padsize: size for padarray to increase numerical accuracy
% H: the field direction, e.g. H=[0 0 1];
% ninter: number of iterations. e.g. niter=30.
% 
% ------------ usage 1 -----------------------
%[Susceptibility]= QSM_iLSQR(TissuePhase,BrainMask,'H',H,'voxelsize',voxelsize,'padsize',padsize,'niter',niter,'TE',TE,'B0',B0);
%
% If optional inputs are not assigned, the following default values will be used.
% H=[0 0 1];
% voxelsize=[1 1 1];
% padsize=[0 0 0];
% B0=3;
% TE=40; 
%
% ------------ usage 2 -----------------------
% params.H=H;
% params.voxelsize = voxelsize;
% params.padsize = padsize;
% params.niter = max_niter;
% params.cropsize = cropsize;
% params.TE = TE;
% params.B0 = B0;
% params.tol_step1 = tol_step1;
% params.tol_step2 = tol_step2;
% params.Kthreshold = Kthreshold;
% 
% [Susceptibility]= QSM_iLSQR(TissuePhase,NewMask,'params',params);
%
% --------------------------------------------------
% Part of STI_Suite_v2.2
% Wei Li, PhD
% Chunlei Liu, PHD
% Brain Imaging And Analysis Center, Duke Uiversity.
% --------------------------------------------------
