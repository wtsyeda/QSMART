function [mean_bg, var_bg] = getBackgroundGaussianNoise(all_data,EchoTimes,iSlice,region,disp_bg)

bg_reg = (squeeze(all_data(region(1):region(2),region(3):region(4),iSlice,:)));

 for i = 1:length(EchoTimes)
     
    sig = double(squeeze(bg_reg(:,:,i)));
    mean_bg(i) = mean(sig(:)); 
    var_bg(i) = var(sig(:)); 

 end
all_data(region(1):region(2),region(3):region(4),iSlice,1) = max(all_data(:));

if disp_bg
    imagesc(all_data(:,:,iSlice))
end
 

 