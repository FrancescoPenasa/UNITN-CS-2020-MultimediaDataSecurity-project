%% INITIALIZATION
clear all; clc;

addpath('ATTACKS', 'WPSNR', 'Images_original', 'Images_watermarked');

imName='lena';
groupname='iquartz';
ext = 'bmp';
imagesAttacked='Images_attacked/'; 

original = sprintf('%s.%s', imName, ext);
%watermarked = sprintf('%s_%s.%s', imName, groupname, ext);
watermarked =  sprintf('%s_%s.%s', groupname, imName, ext);

%% RUNNING TIME <5s
dCPUStartTime = cputime;
[tr, cWPSNR] = new_detection_iquartz(original, watermarked, watermarked);
dElapsed = cputime - dCPUStartTime;
if dElapsed > 5
    disp('ERROR! Takes too much to run')
end

%% MUST BE FOUND IN WATERMARKED
if tr==0
    disp('ERROR! Watermark not found in watermarked image');
end


%% MUST NOT BE FOUND IN ORIGINAL
[tr, cWPSNR] = new_detection_iquartz(original, watermarked, original);
if tr==1
    disp('ERROR! Watermark found in original');
end


%% CHECK DESTROYED IMAGES
Im1 = imread(watermarked);
Im1a = test_awgn(Im1, 0.1, 123);

Im1a = awgn_gaussian_mid(Im1);
%Im1a = awgn_speckle_low(Im1);
%Im1a = blur_high(Im1);
%Im1a = jpeg_20(Im1);
%Im1a = median_mid(Im1);
%Im1a = resize_mid(Im1);
%Im1a = sharpening_mid(Im1);

imshow(Im1a);

path = sprintf("%s%s_%s", imagesAttacked, imName, "_attacked_gaus.bmp");
imwrite(Im1a, path);

[tr, cWPSNR] = new_detection_iquartz(original, watermarked, path);

fprintf("WPSNR " + cWPSNR);

%% CHECK UNRELATED
myFiles = dir(fullfile('TESTImages','*.bmp'));
for k = 1:length(myFiles)
	baseFileName = myFiles(k).name;
	fullFileName = fullfile('TESTImages', baseFileName);
    [tr, cWPSNR] = new_detection_iquartz(original, watermarked, fullFileName);
    if tr==1
    	fprintf('ERROR! Watermark found with in %s\n', baseFileName);
    end
end
