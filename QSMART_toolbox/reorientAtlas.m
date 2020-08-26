function [atlaspath,brainmaskpath] = reorientAtlas(params)

atlas=niftiread(params.atlas);
brainmask=niftiread(params.atlas_brainmask);

atlas=permute(atlas,params.permuteAxis(1:3));
brainmask=permute(brainmask,params.permuteAxis(1:3));

if params.permuteAxis(4)
    atlas=flip(atlas,params.permuteAxis(4));
    brainmask=flip(brainmask,params.permuteAxis(4));
end

atlas_info=niftiinfo(params.atlas);

atlas_info.ImageSize=size(atlas,1,2,3);

atlas_info.PixelDimensions= atlas_info.PixelDimensions(params.permuteAxis(1:3));

nii=make_nii(atlas,atlas_info.PixelDimensions); save_nii(nii,'temp_reoriented_atlas.nii');

nii=make_nii(brainmask,atlas_info.PixelDimensions); save_nii(nii,'temp_reoriented_atlas_brainmask.nii');

atlaspath='temp_reoriented_atlas.nii';

brainmaskpath='temp_reoriented_atlas_brainmask.nii';


