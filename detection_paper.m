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
    QF = 45;
    imwrite(I_w, 'SSatt.jpg', 'Quality', QF);
    Iatt = imread('SSatt.jpg');
    delete('SSatt.jpg');

    q = WPSNR(I, uint8(Iatt));
    fprintf('Images (original-attacked) WPSNR = +%5.2f dB\n',q);
end

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');
 
[w_x, w_y] = size(w);
w_vec = reshape(w,1,w_x*w_y);

%% Perform DWT
% original

[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);

Level1=[A1img,H1img; V1img,D1img];
if show_images
    imshow(uint8([A1img,H1img; V1img,D1img]));
end

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
if show_images
    imshow(uint8([A1imgw,H1imgw; V1imgw,D1imgw]));
end

%% Perform Block-Based APDCBT on horizontal Sub-band
%on original image
if on8x8blocks
   if dwt_comp == 2
       Y = blkproc(cV,[8 8],@apdcbt);
    elseif dwt_comp == 3
       Y = blkproc(cD,[8 8],@apdcbt);
   end
end
[dimx,dimy] = size(Y);
Y_vec = reshape(Y,1,dimx*dimy);

% on watermarked image
if on8x8blocks
    if dwt_comp == 2
       Yw = blkproc(cVw,[8 8],@apdcbt);
    elseif dwt_comp == 3
       Yw = blkproc(cDw,[8 8],@apdcbt);
    end
 else
    [Yw, Vw] = apdcbt(cVw);
end
[dimxw,dimyw] = size(Yw);
Yw_vec = reshape(Yw,1,dimxw*dimyw);

%% Obtain the DC coefficients matrix M (vector M_vec) ORIGINAL
blocks_x = dimx/8;
blocks_y = dimy/8;

M_vec = zeros(1, blocks_x*blocks_y); %32x32 in vector form 1x1024
mi = 1; 
if on8x8blocks
   for i=1:dimx
       for j=1:dimy
           if (mod(i,8) == 1) && (mod(j,8) == 1) 
               M_vec(mi) = Y(i,j);
               mi = mi+1;
           end
       end
   end
end

if svd_insertion
% Obtain SVD Matrix of original DC coefficients
    % M to matrix representation
    M_rec = reshape(M_vec, blocks_x, blocks_y);
    % DC coefficient matrix has transposed values after reshape
    M_rec = M_rec';
    
    [MU_rec, MS_rec, MV_rec] = svd(M_rec);
    
    [MUs_rec, MSs_rec, MVs_rec] = svd(MS_rec);
    
    MS_rec_star = MUs_rec*MS_rec*MVs_rec';
    
end

%% Obtain the DC coefficients matrix Mw (vector Mw_vec) from watermarked image
blocks_x = dimx/8;
blocks_y = dimy/8;

Mw_vec = zeros(1, blocks_x*blocks_y); %32x32 in vector form 1x1024
mi = 1; 
if on8x8blocks
   for i=1:dimx
       for j=1:dimy
           if (mod(i,8) == 1) && (mod(j,8) == 1) 
               Mw_vec(mi) = Yw(i,j);
               mi = mi+1;
           end
       end
   end
end

if svd_insertion
    % Obtain SVD Matrix of watermarked/attacked DC coefficients
     % Mw to matrix representation
    Mw_rec = reshape(Mw_vec, blocks_x, blocks_y);
    % DC coefficient matrix has transposed values after reshape
    Mw_rec = Mw_rec';
    
    [MUw_rec, MSw_rec, MVw_rec] = svd(Mw_rec);
    
    [Uw, Sw, Vw] = svd(MSw_rec); 
    
    MSw_rec_star =  Uw*MSw_rec*Vw;
end


%% Extract watermark
% I want final watermark to be in vectorial form
w_rec = zeros(1, w_x*w_y);
if svd_insertion
    %extract from MSw - MS matrix
    w_svd = (MSw_rec_star - MS_rec_star)/alpha;
    WT = 0.5;
    for i=1:32
        for j=1:32
            if w_svd(i,j) >= WT
                w_svd(i,j) = 1;
            else
                w_svd(i,j) = 0;
            end
        end
    end
    w_rec = reshape(w_svd,1,w_x*w_y);
else
    %extract directly from DC matrix
    for j = 1: w_x*w_y
       % Itw_mod(m) = It_mod(m) + (alpha*w_vec(j));
        w_rec(j) = (Mw_vec(j) - M_vec(j))/alpha;
    end
end


%% OLD CODE (works without DC coefficients)
%% Coefficient selection (hint: use sign, abs and sort functions)
%Y_sgn = sign(Y_vec);
%Y_mod = abs(Y_vec);
%Yw_mod = abs(Yw_vec);
%[Y_sort,Y_index] = sort(Y_mod,'descend');

%% Extraction
%w_rec = zeros(1, w_x*w_y);
%k = 2;
%for j = 1: w_x*w_y
%    m = Y_index(k);
%    w_rec(j) = round(((Yw_mod(m)/Y_mod(m)) - 1) / alpha);
    %todo the other way too
%    k = k+1;
%end


%% CONTINUATION

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