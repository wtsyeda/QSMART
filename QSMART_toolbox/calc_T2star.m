function calc_T2star(img,BW,TE,vox,bg)

dims=size(img);
TE=reshape(TE,[],1);
img=double(img);

% range of slices that should be fit
slice = 1:dims(3);

% Rayleigh noise
noise  = reshape(img(bg(1):bg(2),bg(3):bg(4),end,1:end),[],length(TE)); 
sigma2 = (squeeze((mean(noise)'))/sqrt(pi/2)).^2;

% reshape data [#voxel,TEs]
Ivec = reshape(img(:,:,slice,:),[],length(TE));
brainMask = BW(:,:,slice); % load brain mask

T2_exp     = zeros(dims(1),dims(2),length(slice)); % T2 component from exp model
M0_exp      = zeros(dims(1),dims(2),length(slice)); % initial magnetization

tic;
parfor iP = 1:size(Ivec,1)

    if(mod(iP,dims(1)*dims(2)) == 0)
        disp(['slice: ', num2str(iP/(dims(1)*dims(2)))]);
    end
    
    if(brainMask(iP) > 0)
        sig = Ivec(iP,:)';
        try
        % Rician objective function for exponential model
        rice_obj_exp = @(x) sum((sig.^2+(x(2)*exp(-TE.*x(1))).^2)./(2*sigma2)  ...
            -log(besseli(0,sig.*(x(2)*exp(-TE.*x(1)))./sigma2,1)) ...
            -abs(real(sig.*(x(2)*exp(-TE.*x(1)))./sigma2)));
        
        % Exp model estimation
        options = optimset('MaxFunEvals',1000000, 'MaxIter', 10000, 'Display', 'off');
        
        Init_cond_exp = [1/30,sig(1)];
        
        [r_est, fval,residual]   = fmincon(rice_obj_exp,Init_cond_exp, [],[],[],[],[0,0],[Inf,Inf],[],options);
        
        T2_exp(iP) = 1./r_est(1);
        M0_exp(iP)  = r_est(2);
        end
    end
end
toc;

nii=make_nii(T2_exp,vox); save_nii(nii,'T2star_exp.nii');
nii=make_nii(M0_exp,vox); save_nii(nii,'M0_exp.nii');

