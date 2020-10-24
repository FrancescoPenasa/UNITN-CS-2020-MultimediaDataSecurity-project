close all; clear; clc;

%% DETECTION FOR SIMPLE DWT + DCT Spread Spectrum
% todo add original image stuff

%% Read original image and convert it to double
I = imread('lena.bmp');
I  = double(I);

%% Read watermarked image and convert it to double
I_w = imread('lena_wat.bmp');
[dimx,dimy] = size(I_w);
Iwd = double(I_w); 

%% Attacks
%Iatt = imnoise(I_w,'gaussian');

%QF = 80; 
%imwrite(I_w, 'SSatt.jpg', 'Quality', QF);
%Iatt = imread('SSatt.jpg');
%delete('SSatt.jpg');

%q = WPSNR(I, uint8(Iatt));
%fprintf('WPSNR = +%5.2f dB\n',q);
%imshow(Iatt);

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');

imshow(w);
[w_x, w_y] = size(w);
w_vec = reshape(w,1,w_x*w_y);

%% Perform DWT
% watermarked 
[cAw, cHw, cVw, cDw] = dwt2(I_w, 'Haar');

%Per controllare quella attaccata: 
%[cAw, cHw, cVw, cDw] = dwt2(Iatt, 'Haar');

A1imgw = wcodemat(cAw,255,'mat',1);
H1imgw = wcodemat(cHw,255,'mat',1);
V1imgw = wcodemat(cVw,255,'mat',1);
D1imgw = wcodemat(cDw,255,'mat',1);

Level1w = [A1imgw,H1imgw; V1imgw,D1imgw];

% original

[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);

Level1=[A1img,H1img; V1img,D1img];

%% Perform Block-Based APDCBT on horizontal Sub-band
cH_dctw = dct2(cHw);
[dimxw,dimyw] = size(cH_dctw);

cH_dct = dct2(cH);
[dimx,dimy] = size(cH_dct);

%% Watermark
alpha = 0.5;
Itw_re = reshape(cH_dctw,1,dimxw*dimyw);
It_re = reshape(cH_dct,1,dimx*dimy);

%% Coefficient selection (hint: use sign, abs and sort functions)
It_sgn = sign(It_re);
It_mod = abs(It_re);
Itw_mod = abs(Itw_re);
[It_sort,Ix] = sort(It_mod,'descend');

%% Extraction
w_rec = zeros(1, w_x*w_y);
k = 2;
for j = 1: w_x*w_y
    m = Ix(k);
    %La formula è sbagliata?
    w_rec(j) = ((Itw_mod(m)/It_mod(m)) - 1) / alpha;
    %todo the other way too

    k = k+1;
end

%w_rec = reshape(w_rec, w_x, w_y);


%% Detection (Matrix multiply -> scalar as output?)
SIM = w_vec * w_rec' / sqrt( w_rec * w_rec' );

%% Compute threshold
%999 matrici da 32x32? o vettori da 1024?
randWatermarks = round(rand(999,size(w_vec,2))); 
x = zeros(1,1000);
 
x(1) = SIM;  
for i = 1:999
    w_rand = randWatermarks(i,:);
    x(i+1) = w_vec * w_rand' / sqrt( w_rand * w_rand' );
end

x = abs(x);
x = sort(x, 'descend');
t = x(2);
T = t + 0.1*t;

%% Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end