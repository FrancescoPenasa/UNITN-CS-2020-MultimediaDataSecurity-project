close all; clear; clc;

config_constants;

%% Read original image and convert it to double
I = imread('lena.bmp');
Id = double(I); % TODO: needed?

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');
[w_x, w_y] = size(w);
w_vec = reshape(w,1, w_x*w_y);

%% Perform DWT on Carier Image
[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);

Level1=[A1img,H1img; V1img,D1img];
% imshow(uint8([A1img,H1img; V1img,D1img]));

%% Perform Block-Based APDCBT on HL Sub-band
if on8x8blocks
    Y = blkproc(cV,[8 8],@apdcbt);
else
    [Y, V] = apdcbt(cV); % Decide what sub-band to use
end

[dimx,dimy] = size(Y);

%% SVD TODO: riscrivere bene
%[YU, YS, YV] = svd(Y);
YS = Y;
%Reshape the Y coefficient into a vector
Y_vec = reshape(YS, 1, dimx*dimy);

%% Coefficient selection (hint: use sign, abs and sort functions)
Y_sgn = sign(Y_vec);
Y_mod = abs(Y_vec);
[Y_sort,Y_index] = sort(Y_mod,'descend');

%% Embedding
Yw_mod = Y_mod; 

k = 2;
for j = 1: w_x*w_y
    m = Y_index(k);
    Yw_mod(m) = Y_mod(m)*(1+alpha*w(j));
    %Itw_mod(m) = It_mod(m) + (alpha*w_vec(j));
    k = k+1;
end

% Restore the sign and go back to matrix representation using reshape
Y_new = Yw_mod.*Y_sgn;
Y_new = reshape(Y_new,dimx,dimy);

% Inverse SVD
%[YUw, YSw, YVw] = svd(Y_new);
%Y_new = YUw*YSw*YVw';

% Invert
if on8x8blocks
    cV_wat = blkproc(Y_new,[8 8],@iapdcbt);
else
    cV_wat = iapdcbt(Y_new);
end

V1img_wat = wcodemat(cV_wat,255,'mat',1);

%Reverse wavelet
I_wat = uint8(idwt2(cA, cH, cV_wat, cD, 'Haar'));

q = WPSNR(I, I_wat);
fprintf('Images (original-watermarked) WPSNR = +%5.2f dB\n',q);

q = PSNR(I, I_wat);
fprintf('Images (original-watermarked) PSNR = +%5.2f dB\n',q);

if show_images
    % suptitle('Original Image(Left)and Watermarked DWT-DCT(Right)');
    subplot(1,2,1);
    imshow(uint8([A1img,H1img; V1img,D1img]));
    imshow(I);
    subplot(1,2,2);
    imshow(uint8([A1img,H1img; V1img_wat,D1img]));
    imshow(I_wat);
end

imwrite(I_wat,"lena_iquartz.bmp");
