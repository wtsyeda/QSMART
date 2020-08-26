function [mag_all,ph_all,params] = readComplexData(datapath,params)

if strcmp(params.datatype,'DICOM_Siemens')
    
    path_mag=searchFile(sprintf('%s/**/',datapath),'*_MAG_*');
    path_pha=searchFile(sprintf('%s/**/',datapath),'*_PHA_*');
    [mag_all,ph_all,params.iminfo]= readComplexDicoms(path_mag,path_pha);
    try
        mp2rage_dcm2nii(searchFile(sprintf('%s/**/',datapath),'*_UNI-DEN*'),params.path_qsm);
    end
    
elseif strcmp(params.datatype,'BRUKER')
    [mag_all,ph_all,params.iminfo]=readComplexBruker(datapath);
    
end
if ~isempty(params.use_echoes)
    mag_all=mag_all(:,:,:,params.use_echoes,:);
    ph_all=ph_all(:,:,:,params.use_echoes,:);
    params.iminfo.echo_times=params.iminfo.echo_times(params.use_echoes);
    params.iminfo.echoes=length(params.use_echoes);
    
end
