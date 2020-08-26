function [mag_all,ph_all,param]=readComplexBruker(datapath)

[foldernames,nFolders] = getFolderNames(datapath);

for iFolder = 1:nFolders
    
    if str2num(foldernames{iFolder})
        currFolder=sprintf('%s/%s',datapath,foldernames{iFolder});
        sequence=getBrukerSequence(currFolder);
        
        if strcmp(sequence,'MGE')
            MGEpath=currFolder;
        end
    end
end

if any(MGEpath)
    [image, param]=Bruker_MGE_3D(MGEpath);
    param.z_prjs=[1 0 0];
    param.echo_times=param.echo_times*1e-3;   % converting to sec
end

mag_all = abs(image);
ph_all = angle(image);