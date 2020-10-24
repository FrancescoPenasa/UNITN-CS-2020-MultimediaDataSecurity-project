%% INITIALIZATION
clear all; clc;

addpath('ATTACKS', 'WPSNR', 'TESTImages');
imName='lena';
groupname='iquartz';
ext = 'bmp';

original = sprintf('%s.%s', imName, ext);
watermarked = sprintf('%s_%s.%s', imName, groupname, ext);

%% RUNNING TIME <5s
dCPUStartTime = cputime;
[tr, cWPSNR] = detection_iquartz(original, watermarked, watermarked);
dElapsed = cputime - dCPUStartTime;
if dElapsed > 5
    disp('ERROR! Takes too much to run')
end

%% MUST BE FOUND IN WATERMARKED
if tr==0
    disp('ERROR! Watermark not found in watermarked image');
end


%% MUST NOT BE FOUND IN ORIGINAL
[tr, cWPSNR] = detection_groupName(original, watermarked, original);
if tr==1
    disp('ERROR! Watermark found in original');
end


%% CHECK DESTROYED IMAGES
Im1 = imread(watermarked);
Im1a = test_awgn(Im1, 0.7, 123);
imwrite(Im1a, 'attacked.bmp')

[tr, cWPSNR] = detection_groupName(original, watermarked, 'attacked.bmp');
if tr==1
    fprintf('ERROR! Watermark found with WPSNR = %f\n', cWPSNR);
end


%% CHECK UNRELATED
myFiles = dir(fullfile('TESTImages','*.bmp'));
for k = 1:length(myFiles)
	baseFileName = myFiles(k).name;
	fullFileName = fullfile('TESTImages', baseFileName);

    [tr, cWPSNR] = detection_groupName(original, watermarked, fullFileName);
    if tr==1
    	fprintf('ERROR! Watermark found with in %s\n', baseFileName);
    end
end
