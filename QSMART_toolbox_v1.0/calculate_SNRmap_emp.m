function SNRimg= calculate_SNRmap_emp(data,params)

EchoTimes = params.iminfo.echo_times;

if ~isfield(params,'bg_iSlice')
    params.bg_iSlice = 30;
end
if ~isfield(params,'bg_region')
    params.bg_region = [2,4,70,120];
end

matrix = [size(data,1) size(data,2) size(data,3)];


[mean_bg_data, var_bg_data] = getBackgroundGaussianNoise(data,EchoTimes,params.bg_iSlice,params.bg_region,params.disp_bg);

% Rayleigh noise

sigma2 = (mean_bg_data/sqrt(pi/2)).^2;
sigma = sqrt(mean(sigma2));

% data normalization
norm_data = (data -mean(mean_bg_data'))./sqrt(mean(var_bg_data')); sigma = 1; 

norm_data = reshape(norm_data,[],length(EchoTimes));

maxima_loc_emp = zeros(matrix );

maxima_val_emp = zeros(matrix );


% Selecting voxel data

tot_size = prod(matrix);

parfor iP = 1:tot_size
    if(mod(iP,tot_size/matrix(3)) == 0)
        fprintf('%d ',iP/tot_size*matrix(3))
    end
    
    vox_signal = squeeze(norm_data(iP,:));
    
    if any(vox_signal)
        
        t0 = EchoTimes(1);
        s = EchoTimes(3)-EchoTimes(2);
        n = 1:length(EchoTimes);
        
        % Signal and signal models
        S = squeeze(vox_signal);

        for i = 1:length(EchoTimes)
            
            % Empirical SNR
            if i<=length(EchoTimes)
                gaussian_SNR(i) = mean(S(1:i))/sigma*sqrt(i);
            else
                gaussian_SNR(i) = nan;
            end
            
        end
        
        % Calculating optimum n
        try
            % Empirical maxima
            [maxima_val_emp(iP), maxima_loc_emp(iP)] = max(gaussian_SNR);
            gaussian_SNR = [];
        end
    end
    
end

SNRimg = maxima_val_emp;
delete(gcp('nocreate'));
