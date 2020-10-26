%% INITIALIZATION
clear all; clc;

addpath('ATTACKS', 'WPSNR', 'Images_original', 'Images_watermarked');

imName='lena';
groupname='iquartz';
ext = 'bmp';
imagesAttacked='Images_attacked/'; 

original = sprintf('%s.%s', imName, ext);
watermarked = sprintf('%s_%s.%s', imName, groupname, ext);
%watermarked =  sprintf('%s_%s.%s', groupname, imName, ext);

%% RUNNING TIME <5s
dCPUStartTime = cputime;
%% If you want to see watermark extracted, add w and wa as output to 
% detection function and assign them after you extracted them
%[tr, cWPSNR, w, wa] = detection_iquartz(original, watermarked, watermarked);

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
Im1 = imread(watermarked);

%Im1a = awgn_gaussian_mid(Im1);
%Im1a = awgn_speckle_high(Im1);
%Im1a = blur_mid(Im1);
%Im1a = jpeg_20(Im1);
%Im1a = median_high(Im1);
%Im1a = resize_low(Im1);
Im1a = sharpening_high(Im1);

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
    [tr, cWPSNR] = new_detection_iquartz(original, watermarked, fullFileName);
    if tr==1
    	fprintf('ERROR! Watermark found with in %s\n', baseFileName);
    end
    disp("Wpsnr " + cWPSNR);
end
