close all; clear; clc;

new_config_constants;

img_name = "capo.bmp";
wat_name = "capo_iquartz.bmp";

%% Read original image and the watermark

I = imread(img_name);
I = double(I);
load('iquartz.mat');    %to variable w
%w = rescale(w, -1,1);
imshow(w);
w_vec = reshape(w, 1, W_SIZE * W_SIZE);

%Try random watermarks
%randWatermark = round(rand(1,1024)); 
%w = randWatermark;


%% Perform DWT on Carier Image, Level 2
[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);
Level1=[A1img,H1img; V1img,D1img];

%level 2
[cA2, cH2, cV2, cD2] = dwt2(cA, 'Haar');

A2img = wcodemat(cA2,255,'mat',1);
H2img = wcodemat(cH2,255,'mat',1);
V2img = wcodemat(cV2,255,'mat',1);
D2img = wcodemat(cD2,255,'mat',1);
Level2 = [A2img,H2img; V2img,D2img];

imshow(uint8([Level2,H1img; V1img,D1img]));

%% Perform Block-Based APDCBT 

%process subbands, 2nd level
if DWT_L2
    Yh = blkproc(cH2,[8 8],@apdcbt);
    Yv = blkproc(cV2,[8 8],@apdcbt);
else %apply on first level
    Yh = blkproc(cH,[8 8],@apdcbt);
    Yv = blkproc(cV,[8 8],@apdcbt);
end

[dimx, dimy] = size(Yh); %size is the same for both subbands

%% Embedding (doesn't care if its 1st,2nd,3rd level)
Yh_new = embed(Yh, w_vec, ALPHA);
Yv_new = embed(Yv, w_vec, ALPHA);


subplot(2,2,1);
imshow(log(abs(Yh)),[]);
colormap(gca,jet(64));
colorbar;
subplot(2,2,2);
imshow(log(abs(Yv)),[]);
colormap(gca,jet(64));
colorbar;

subplot(2,2,3);
imshow(log(abs(Yh_new)),[]);
colormap(gca,jet(64));
colorbar;
subplot(2,2,4);
imshow(log(abs(Yv_new)),[]);
colormap(gca,jet(64));
colorbar;

%% Reverse IAPDCBT
if DWT_L2
    cH2_wat = blkproc(Yh_new,[8 8],@iapdcbt);
    cV2_wat = blkproc(Yv_new,[8 8],@iapdcbt);
else
    cH_wat = blkproc(Yh_new,[8 8],@iapdcbt);
    cV_wat = blkproc(Yv_new,[8 8],@iapdcbt);
end


%% Reverse wavelet
if DWT_L2
    H2img_wat = wcodemat(cH2_wat,255,'mat',1);
    V2img_wat = wcodemat(cV2_wat,255,'mat',1);

    Level2_wat = [A2img,H2img_wat; V2img_wat,D2img];

    cA_wat = idwt2(cA2, cH2_wat, cV2_wat, cD2, 'Haar');
    I_wat = uint8(idwt2(cA_wat, cH, cV, cD, 'Haar'));
else 
    H1img_wat = wcodemat(cH_wat,255,'mat',1);
    V1img_wat = wcodemat(cV_wat,255,'mat',1);
    Level1_wat = [A1img,H1img_wat; V1img_wat,D1img];
    I_wat = uint8(idwt2(cA, cH_wat, cV_wat, cD, 'Haar'));

end


%% OLD CODE 
%% SVD TODO: riscrivere bene
%[YU, YS, YV] = svd(Y);
%YS = Y;

% Inverse SVD
%[YUw, YSw, YVw] = svd(Y_new);
%Y_new = YUw*YSw*YVw';


%Reverse wavelet
q = WPSNR(I, I_wat);
fprintf('Images (original-watermarked) WPSNR = +%5.2f dB\n',q);


suptitle('Original Image(Left)and Watermarked DWT(Right)');


if DWT_L2
    subplot(1,2,1);
    imshow(uint8([Level2,H1img; V1img,D1img]));
    subplot(1,2,2);
    imshow(uint8([Level2_wat,H1img; V1img,D1img]));
else 
    subplot(1,2,1);
    imshow(uint8([A1img,H1img; V1img,D1img]));
    subplot(1,2,2);
    imshow(uint8(Level1_wat));
end

%imshow(I);

%imshow(I_wat);


imwrite(I_wat,wat_name);



