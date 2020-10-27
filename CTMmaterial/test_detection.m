%% INITIALIZATION
clear all; clc;

addpath('ATTACKS', 'WPSNR', 'Images_original', 'Images_watermarked');

%% == MODIFY THIS PARAMETERS WITH THE CORRECT ONES
imName='lena';
groupname='iquartz';
ext = 'bmp';
imagesAttacked='Images_attacked/'; 

original = sprintf('%s.%s', imName, ext);
%% == CHECK WHICH ONE OF THIS == %%
%watermarked = sprintf('%s_%s.%s', imName, groupname, ext); % TO CHECK OUR GROUP
watermarked =  sprintf('%s_%s.%s', groupname, imName, ext); % TO CHECK OTHER GROUP

%% RUNNING TIME <5s
dCPUStartTime = cputime;
%% If you want to see watermark extracted, add w and wa as output to 
% detection function and assign them after you extracted them
%[tr, cWPSNR, w, wa] = detection_iquartz(original, watermarked, watermarked);

%% == MODIFY WITH THE CORRECT DETECTION FUNCTION == %%
[tr, cWPSNR] = detection_iquartz(original, watermarked, watermarked);
dElapsed = cputime - dCPUStartTime;
if dElapsed > 5
    disp('ERROR! Takes too much to run')
end

%subplot(1,2,1);
%imshow(w);
%subplot(1,2,2);
%imshow(wa);

%% MUST BE FOUND IN WATERMARKED
if tr==0
    disp('ERROR! Watermark not found in watermarked image');
end

%% MUST NOT BE FOUND IN ORIGINAL
[tr, cWPSNR] = detection_iquartz(original, watermarked, original);
if tr==1
    disp('ERROR! Watermark found in original');
end



%% CHECK DESTROYED IMAGES
Iw = imread(watermarked);

%% == use the attacks that you want to try == %%
%Im1a = awgn_gaussian_tunable(Iw, mean, variance, seed)
%Im1a = imnoise(Iw,'poisson');
%Im1a = awgn_sap_tunable(Iw, noisePower, seed)
%Im1a = awgn_speckle_tunable(Iw, noisePower, seed)
%Im1a = median_tunable(Iw,na,nb)
%Im1a = resize_tunable(Iw, nPower)
Im1a = jpeg_tunable(Iw, 70)

%Im1a = blur_tunable(Iw, noisePower)
%Im1a = sharpening_tunable(Iw, nRad, nPower, thr);

imshow(Im1a);

path = sprintf("%s%s_%s", imagesAttacked, imName, "_attacked_gaus.bmp");
imwrite(Im1a, path);

[tr, cWPSNR] = detection_iquartz(original, watermarked, path);

fprintf("WPSNR " + cWPSNR + "Contains: " + tr);


%% CHECK UNRELATED
myFiles = dir(fullfile('Images_original','*.bmp'));
for k = 1:length(myFiles)
	baseFileName = myFiles(k).name;
	fullFileName = fullfile('Images_original', baseFileName);
    [tr, cWPSNR] = detection_iquartz(original, watermarked, fullFileName);
    if tr==1
    	fprintf('ERROR! Watermark found with in %s\n', baseFileName);
    end
    disp("Wpsnr " + cWPSNR);
end
