close all; clear; clc;
%% SIMPL SPREAD SPECTRUM DWT+DCT INSERTION
%% Read original image and convert it to double
I = imread('lena.bmp');
[dimx,dimy] = size(I);
Id = double(I); % TODO: needed?

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');
imshow(w);
[w_x, w_y] = size(w);
%reshape watermark as vector
w_vec = reshape(w,1,w_x*w_y);

%% Perform DWT on Carier Image
[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);

Level1=[A1img,H1img; V1img,D1img];
imshow(uint8([A1img,H1img; V1img,D1img]));

%% Perform DCT on Horizontal Component

cH_dct = dct2(cH);
[dimx,dimy] = size(cH_dct);

%imshow(log(abs(cH_dct)),[]);
%colormap(gca,jet(64));
%colorbar;

%Reshape the DCT into a vector
It_re = reshape(cH_dct,1,dimx*dimy);

%% Watermark
alpha = 0.5;

%% Coefficient selection (hint: use sign, abs and sort functions)
It_sgn = sign(It_re);
It_mod = abs(It_re);
[It_sort,Ix] = sort(It_mod,'descend');

%% Embedding
Itw_mod = It_mod; 

k = 2;
for j = 1: w_x*w_y
    m = Ix(k);
    Itw_mod(m) = It_mod(m)*(1+alpha*w(j));
    %Itw_mod(m) = It_mod(m) + (alpha*w_vec(j));
    k = k+1;
end

% Restore the sign and go back to matrix representation using reshape
It_new = Itw_mod.*It_sgn;
cH_dct_new=reshape(It_new,dimx,dimy);

% Invert
cH_wat = idct2(cH_dct_new);

H1img_wat = wcodemat(cH_wat,255,'mat',1);
imshow(uint8([A1img,H1img; V1img,D1img]));

%Reverse wavelet
I_wat = uint8(idwt2(cA, cH_wat, cV, cD, 'Haar'));
imshow(uint8(I_wat));

q = WPSNR(I, uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q);

%plot the two images
suptitle('Original Image(Left)and Watermarked DWT-DCT(Right)');
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I_wat);

imwrite(I_wat,"lena_wat.bmp");

%DCT block based
%cH_block= blkproc(cH,[8 8],@dct2);
%imshow(log(abs(cH_block)),[]);
%colormap(gca,jet(64));
%colorbar;

%Reconstruct cH from DCT domain
%fun = @(x) idct2(x);
%cH_wat= uint8(blkproc(cH_block,[8 8],fun));

%% Perform Block-Based APDCBT on horizontal Sub-band
%[Y, V] = apdcbt(cH); % Obtain DC Coefficients

%% Get DC Coefficient Matrix M and Perform SVD on M
%M = [Y, V];         % Create a Matrix from DC Coefficients
%[U, S, V] = svd(M); % Singular value decomposition

%cHwat = iapdcbt(M);

%% Watermark Insertion
%a = 1; % TODO: Scaling Factor
%Sw = S + a * w;
%[Uw, Sw1, Vw] = svd(Sw);
%Mw = U * Sw1 * V.'; % Watermarked DC coefficient Matrix
%HLw = iapdcbt(Mw);
