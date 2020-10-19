close all; clear; clc;

config_constants;

% todo add original image stuff
% TODO: uniformare la naming convention (w o _wat) tra qua e insertion

%% Read original image and convert it to double
I = imread('lena.bmp');
I  = double(I);

%% Read watermarked image and convert it to double
I_w = imread('lena_iquartz.bmp');
Iwd = double(I_w); 

%% Attacks
if attack
    QF = 50;
    imwrite(I_w, 'SSatt.jpg', 'Quality', QF);
    Iatt = imread('SSatt.jpg');
    delete('SSatt.jpg');

    q = WPSNR(I, uint8(Iatt));
    fprintf('Images (original-watermarked) WPSNR = +%5.2f dB\n',q);
end

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');

[w_x, w_y] = size(w);
w_vec = reshape(w,1,w_x*w_y);

%% Perform DWT
% watermarked
if attack
    [cAw, cHw, cVw, cDw] = dwt2(Iatt, 'Haar');
else
    [cAw, cHw, cVw, cDw] = dwt2(I_w, 'Haar');
end

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
if on8x8blocks
    Yw = blkproc(cVw,[8 8],@apdcbt);
else
    [Yw, Vw] = apdcbt(cVw);
end
[dimxw,dimyw] = size(Yw);
Yw_vec = reshape(Yw,1,dimxw*dimyw);

if on8x8blocks
    Y = blkproc(cV,[8 8],@apdcbt);
else
    [Y, V] = apdcbt(cV);
end
[dimx,dimy] = size(Y);
Y_vec = reshape(Y,1,dimx*dimy);

%% Coefficient selection (hint: use sign, abs and sort functions)
Y_sgn = sign(Y_vec);
Y_mod = abs(Y_vec);
Yw_mod = abs(Yw_vec);
[Y_sort,Y_index] = sort(Y_mod,'descend');

%% Extraction
w_rec = zeros(1, w_x*w_y);
k = 2;
for j = 1: w_x*w_y
    m = Y_index(k);
    w_rec(j) = round(((Yw_mod(m)/Y_mod(m)) - 1) / alpha);
    %todo the other way too
    k = k+1;
end

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
T = t + 0.1*t

%% Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

w_rec = reshape(w_rec, w_x, w_y);

q = WPSNR(w, w_rec);
fprintf('Watermarks WPSNR = +%5.2f dB\n',q);

if show_images
    % suptitle('Original Image(Left)and Watermarked DWT-DCT(Right)');
    subplot(1,2,1);
    %imshow(uint8([A1img,H1img; V1img,D1img]));
    imshow(w);
    subplot(1,2,2);
    %imshow(uint8([A1img,H1img; V1img_wat,D1img]));
    imshow(w_rec);
end