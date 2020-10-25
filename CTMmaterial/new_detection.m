%% INITIALIZATION
clear all; clc;

addpath('ATTACKS', 'WPSNR', 'Images_original', 'Images_watermarked');
imName='lena';
groupname='iquartz';
ext = 'bmp';

original = sprintf('%s.%s', imName, ext);
watermarked = sprintf('%s_%s.%s', imName, groupname, ext);

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
imwrite(Im1a, 'attacked.bmp')

[tr, cWPSNR] = new_detection_iquartz(original, watermarked, 'lena_attacked.bmp');
if tr==1
    fprintf('ERROR! Watermark found with WPSNR = %f\n', cWPSNR);
end


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
