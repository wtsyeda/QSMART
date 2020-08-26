clc; clear all; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
% This script is a demo of QSMART pipeline developed                %
% at the Melbourne Brain Centre Imaging Unit.                       %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('./QSMART_toolbox'));

%%% Defining data paths and string IDs%%%
  
complex_datapath='/home/wtsyeda/am35_scratch/Warda/QSMART_240420/Data/Human/raw_data/';
out_path='/scratch/am35/Warda/QSMART_240420/QSM_out/';
% Path to utility code
qsm_params.mexEig3volume=which('eig3volume.c');

%%% Setting QSM Parameters %%%

% Scanner/Imaging Parameters
qsm_params.species='human';               % 'human' or 'rodent'
qsm_params.field=7;                       % Tesla
qsm_params.gyro=2.675e8;                  % Proton gyromagnetic ratio  
qsm_params.datatype='DICOM_Siemens';      % options: DICOM_Siemens, BRUKER, 'AAR_Siemens', 'ZIP_Siemens'
qsm_params.phase_encoding='unipolar';     % 'unipolar' or 'bipolar'

% Brain mask method
qsm_params.genMask=1;  % Set to 0 if providing mask
qsm_params.fovMask=0;  % Set to 1 if QSM over entire FOV
qsm_params.niftiMask=0; % Set this parameter if providing external mask, provide mask as a nifit file
qsm_params.allMasksPath=''; % Set this parameter if providing external mask, place all masks in a separate folder with sufolder name same as data subfolder

% Phase unwrapping 
qsm_params.ph_unwrap_method='laplacian';    %options: 'laplacian','bestpath'

% Threshold parameters
qsm_params.mag_threshold=100;
qsm_params.sph_radius1=2;
qsm_params.sph_radius_vasculature = 8;

% Frangi filter parameters
qsm_params.frangi_scaleRange=[0.5 6];
qsm_params.frangi_scaleRatio=0.5;
qsm_params.frangi_C=500;

% Multiecho fit parameters
qsm_params.fit_threshold=40;

% Background field removal

% Spatial dependent filtering parameters
qsm_params.sdf_sp_radius=8;
qsm_params.s1.sdf_sigma1=10;
qsm_params.s1.sdf_sigma2=0;
qsm_params.s2.sdf_sigma1=8;
qsm_params.s2.sdf_sigma2=2;

% RESHARP Parameters
qsm_params.resharp.smv_rad = 1;
qsm_params.resharp.tik_reg = 5e-4;
qsm_params.resharp.cgs_num = 500;

% iLSQR Parameters
qsm_params.cgs_num = 500;
qsm_params.inv_num = 500;
qsm_params.smv_rad = .1;

% Adaptive threshold parameters
qsm_params.seg_thres_percentile = 100;
qsm_params.smth_thres_percentile = 100;                % iLSQR-smoothing high-susc segmentation

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
