function mask = genBrainmask(data,type,params)

if strcmp(type,'human') && params.genMask
    
    mask=brainmask_human(data,params);
    
elseif strcmp(type,'rodent') && params.genMask
    
    mask=brainmask_rodent(data,params);
    
elseif params.fovMask
    
    mask = ones(params.iminfo.matrix);

elseif params.niftiMask
    
    mask = niftiread(params.maskPath);
    
    if ~isempty(params.permuteMask)
        mask = permute(mask,params.permuteMask);
    end
        
    
end