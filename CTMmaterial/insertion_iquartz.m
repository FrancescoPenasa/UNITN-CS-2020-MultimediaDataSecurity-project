%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multimedia Data Security
% UNITN 2020/21
% Embedding strategy of group iquartz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc;

configuration;

img_name = "lena.bmp";
wat_name = "lena_iquartz.bmp";

%wat_folder = "Images_watermarked/";

%% Read original image and the watermark

I = imread(img_name);
I = double(I);

load('iquartz.mat');    %to variable w


% Debug mode
if SHOW_IMAGES
    imshow(w);
end


% Reshape watermark as vector
w_vec = reshape(w, 1, W_SIZE * W_SIZE);
if RESCALE_W
    w_vec = rescale(w_vec, -1, 1);
end


%% Perform DWT on Carier Image, Level 2
[cA, cH, cV, cD] = dwt2(I, 'Haar');

if SHOW_IMAGES
    A1img = wcodemat(cA,255,'mat',1);
    H1img = wcodemat(cH,255,'mat',1);
    V1img = wcodemat(cV,255,'mat',1);
    D1img = wcodemat(cD,255,'mat',1);
    Level1=[A1img,H1img; V1img,D1img];
end

%level 2
[cA2, cH2, cV2, cD2] = dwt2(cA, 'Haar');

if SHOW_IMAGES
    A2img = wcodemat(cA2,255,'mat',1);
    H2img = wcodemat(cH2,255,'mat',1);
    V2img = wcodemat(cV2,255,'mat',1);
    D2img = wcodemat(cD2,255,'mat',1);
    Level2 = [A2img,H2img; V2img,D2img];
    imshow(uint8([Level2,H1img; V1img,D1img]));
end

%% Perform Block-Based APDCBT 

% process subbands, 2nd or 1st level
if DWT_L2
    Yh = blkproc(cH2,[8 8],@apdcbt);
    Yv = blkproc(cV2,[8 8],@apdcbt);
else %apply on first level
    Yh = blkproc(cH,[8 8],@apdcbt);
    Yv = blkproc(cV,[8 8],@apdcbt);
end

[dimx, dimy] = size(Yh); %size is the same for both subbands

%% Embedding (works on 1st, 2nd, 3rd level without modification)
Yh_new = embed(Yh, w_vec, ALPHA);
Yv_new = embed(Yv, w_vec, ALPHA);

if SHOW_IMAGES
    % show original transforms
    subplot(2,2,1);
    imshow(log(abs(Yh)),[]);
    colormap(gca,jet(64));
    colorbar;
    subplot(2,2,2);
    imshow(log(abs(Yv)),[]);
    colormap(gca,jet(64));
    colorbar;
    % show watermarked transforms
    subplot(2,2,3);
    imshow(log(abs(Yh_new)),[]);
    colormap(gca,jet(64));
    colorbar;
    subplot(2,2,4);
    imshow(log(abs(Yv_new)),[]);
    colormap(gca,jet(64));
    colorbar;
end

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

%% Compute WPSNR
q = WPSNR(I, I_wat);
fprintf('Images (original-watermarked) WPSNR = +%5.2f dB\n',q);

imwrite(I_wat, wat_name);

if SHOW_IMAGES
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
end

