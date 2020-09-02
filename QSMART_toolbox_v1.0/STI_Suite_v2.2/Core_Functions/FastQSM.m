function FastQSM
% [susceptibility_fs]=FastQSM(TissuePhase,NewMask,'H',H,'voxelsize',voxelsize,'padsize',padsize,'TE',TE,'B0',B0);
% 
%
% [5] Fast QSM
%
% Inputs:
% TissuePhase: tissue phase
% voxelsize: Spatial resolution
% padsize: size for padarray to increase numerical accuracy
% H: the field direction, e.g. H=[0 0 1];
% 
% If optional inputs are not assigned, the following default values will be used.
% voxelsize=[1 1 1];
% H=[0 0 1];
% B0=3;
% TE=1;
% padsize=[0 0 0];
%
% --------------------------------------------------
% Part of STI_Suite_v2.2
% Wei Li, PhD
% Chunlei Liu, PHD
% Brain Imaging And Analysis Center, Duke Uiversity.
% --------------------------------------------------

