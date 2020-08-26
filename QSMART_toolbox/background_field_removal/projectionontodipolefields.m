function lfs = projectionontodipolefields(tfs,mask,vox,weight,z_prjs)


if ~ exist('z_prjs','var') || isempty(z_prjs)
    z_prjs = [0, 0, 1]; % PURE axial slices
end


% add zero slices
tfs = padarray(tfs,[0 0 20]);
mask = padarray(mask,[0 0 20]);
weight = padarray(weight,[0 0 20]);



[Nx,Ny,Nz] = size(tfs);


% create K-space filter kernel D
%%%%% make this a seperate function in the future
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D = fftshift(D);




M = 1-mask; % region outside the mask
W = weight.*mask; % weights


b = M.*ifftn(D.*fftn(W.*W.*tfs));
b = b(:);

res = cgs(@Afun,b,1e-6, 200);
lfs = mask.*real(tfs-ifftn(D.*fftn(M.*reshape(res,[Nx,Ny,Nz]))));

function y = Afun(x)
    x = reshape(x,[Nx,Ny,Nz]);
    y = M.*ifftn(D.*fftn(W.*W.*ifftn(D.*fftn(M.*x))));
    y = y(:);
end



% remove added zero slices
lfs = lfs(:,:,21:end-20);

end
