clc; clear all; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
% This script is a demo of QSMART pipeline developed                %
% at the Melbourne Brain Centre Imaging Unit.                       %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defining data paths

addpath(genpath('./QSMART_toolbox'));
 
complex_datapath='/scratch/am35/Warda/QSMART_240420/Data/Rat/invivo_4dot7T/raw_data/';
out_path='/scratch/am35/Warda/QSMART_240420/QSM_out/Rat/invivo_4dot7T/';
qsm_params.outfoldername = 'QSM_MEGE';

% Path to utility code
qsm_params.mexEig3volume=which('eig3volume.c');

%%% Setting QSM Parameters %%%

% Scanner/Imaging Parameters
qsm_params.species='rodent';               % 'human' or 'rodent'
qsm_params.field=4.7;                       % Tesla
qsm_params.gyro=2.675e8;                  % Proton gyromagnetic ratio  
qsm_params.datatype='BRUKER';      % options: DICOM_Siemens, BRUKER, 'AAR_Siemens', 'ZIP_Siemens'
qsm_params.phase_encoding='unipolar';     % 'unipolar' or 'bipolar'

% Brain mask method
qsm_params.genMask=1;  % Set to 0 if providing mask
qsm_params.fovMask=0;  % Set to 1 if QSM over entire FOV
qsm_params.niftiMask=0; % Set this parameter if providing external mask, provide mask as a nifit file
qsm_params.allMasksPath=''; % Set this parameter if providing external mask, place all masks in a separate folder with sufolder name same as data subfolder

% Mask erosion parameters
qsm_params.sph_radius1=1;
qsm_params.sph_radius_vasculature = 1;

% Rodent mask params
qsm_params.brainmaskmethod='FSL';        % 'FSL' or 'ANTS' 
qsm_params.fslbet.f = 0.2;
qsm_params.bg_iSlice =70;
qsm_params.bg_region=[1,78,1,8];
qsm_params.disp_bg=1;
qsm_params.atlas=which('Flipped_WHS_SD_rat_T2star_resample2.nii.gz');
qsm_params.atlas_brainmask=which('Flipped_WHS_SD_rat_atlas_v2_brain_mask_resample_2_filled.nii.gz');
qsm_params.permuteAxis=[1 2 3]; % Set atlas permutation order depending on data orientation for ants registration (permutes atlas)

% Multiecho fit threshold
qsm_params.fit_threshold=500;   

% Frangi filter parameters
qsm_params.frangi_scaleRange=[0.01 0.5];
qsm_params.frangi_scaleRatio=0.1;
qsm_params.frangi_C=50;

% Phase unwrapping 
qsm_params.ph_unwrap_method='laplacian';    %options: 'laplacian','bestpath'

% Background field removal

% Spatial dependent filtering parameters
qsm_params.sdf_sp_radius=8;  % Set this sphere radius for indent map
qsm_params.s1.sdf_sigma1=5;
qsm_params.s1.sdf_sigma2=5;
qsm_params.s2.sdf_sigma1=5;
qsm_params.s2.sdf_sigma2=5;

% RESHARP Parameters
qsm_params.resharp.smv_rad = 0.1;
qsm_params.resharp.tik_reg = 1e-6;
qsm_params.resharp.cgs_num = 500;

% Data output
qsm_params.save_raw_data=0;

%%% Main loop to read in data and masks and peform QSM analysis on each 
%%% subject.

% Determining total number of datasets to process

folder_names = getFolderNames(complex_datapath);
n_folders = length(folder_names);

for iFile = 1:n_folders
    
    foldername=folder_names{iFile};
    
    fprintf('Processing folder: %s ...\n',foldername);
    
    session_datapath=sprintf('%s/%s',complex_datapath,foldername);
    
    session_outpath=sprintf('%s%s/',out_path,foldername); mkdir(session_outpath);
    
    
    if qsm_params.niftiMask
    
        % Loading mask
    
        mask_file=getFileNames(sprintf('%s%s/',qsm_params.allMasksPath,foldername));
    
        qsm_params.maskPath=sprintf('%s%s/%s',qsm_params.allMasksPath,foldername,mask_file{1});
    
        qsm_params.genMask=0; qsm_params.fovMask=0; 

    end
    
    QSMART(session_datapath,qsm_params,session_outpath);    
    
end
