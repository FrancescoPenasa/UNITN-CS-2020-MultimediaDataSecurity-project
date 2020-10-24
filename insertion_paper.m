close all; clear; clc;

config_constants;

%% Read original image and convert it to double
I = imread('lena.bmp');
Id = double(I); % TODO: needed?

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');
w = rescale(w, -1,1);

%Try random watermarks
%randWatermark = round(rand(1,1024)); 
%w = randWatermark;

[w_x, w_y] = size(w);
w_vec = reshape(w,1, w_x*w_y);

%% Perform DWT on Carier Image
[cA, cH, cV, cD] = dwt2(I, 'Haar');

A1img = wcodemat(cA,255,'mat',1);
H1img = wcodemat(cH,255,'mat',1);
V1img = wcodemat(cV,255,'mat',1);
D1img = wcodemat(cD,255,'mat',1);

Level1=[A1img,H1img; V1img,D1img];
%imshow(uint8([A1img,H1img; V1img,D1img]));

%% Perform Block-Based APDCBT on a high pass Sub-band
if on8x8blocks
    if dwt_comp == 2
       Y = blkproc(cV,[8 8],@apdcbt);
    elseif dwt_comp == 3
       Y = blkproc(cD,[8 8],@apdcbt);
    end
else
    [Y, V] = apdcbt(cV); % Decide what sub-band to use
end

[dimx,dimy] = size(Y);
if show_images
    imshow(log(abs(Y)),[]);
    colormap(gca,jet(64));
    colorbar;
end

%% Obtain the DC coefficients matrix M (vector M_vec)
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


%% SVD of M + wat + 
if svd_insertion
    % to matrix representation
    M = reshape(M_vec, blocks_x, blocks_y);
    % DC coefficient matrix has transposed values after reshape
    M = M';

    [MU, MS, MV] = svd(M);
    
    MSw = MS + alpha*w;
    
    [MUw, MSw1, MVw] = svd(MSw);
    
    Mw = MU * MSw * MV';

else

    %% Insert watermark

    Mw_vec = M_vec;
    for i=1:w_x*w_y
        Mw_vec(i) = M_vec(i) + alpha*w_vec(i);
        %Mw_vec(i) = M_vec(i)*(1 + alpha*w_vec(i));
    end

    Mw = reshape(Mw_vec, blocks_x, blocks_y);
    %for some reason, DC coefficient matrix has transposed values
    %after reshape
    Mw = Mw';

end

%% Insert watermarked coefficients back in Y
Y_new = Y;
if on8x8blocks
   for i=1:blocks_x
       for j=1:blocks_y
           % where to insert back the information
           yi = (i-1)*8+1;
           yj = (j-1)*8+1;
           Y_new(yi,yj) = Mw(i,j);
           %Y_from_M(i-1)= M(i,j);
       end
   end
end

%% OLD CODE 
%% SVD TODO: riscrivere bene
%[YU, YS, YV] = svd(Y);
%YS = Y;

%Reshape the Y coefficient into a vector
%Y_vec = reshape(YS, 1, dimx*dimy);


%% Coefficient selection (hint: use sign, abs and sort functions)
%Y_sgn = sign(Y_vec);
%Y_mod = abs(Y_vec);
%[Y_sort,Y_index] = sort(Y_mod,'descend');

%% Embedding
%Yw_mod = Y_mod; 

%k = 2;
%for j = 1: w_x*w_y
%    m = Y_index(k);
%    Yw_mod(m) = Y_mod(m)*(1+alpha*w(j));
    %Itw_mod(m) = It_mod(m) + (alpha*w_vec(j));
%    k = k+1;
%end

% Restore the sign and go back to matrix representation using reshape
%Y_new = Yw_mod.*Y_sgn;
%Y_new = reshape(Y_new,dimx,dimy);

% Inverse SVD
%[YUw, YSw, YVw] = svd(Y_new);
%Y_new = YUw*YSw*YVw';

%% CONTINUATION
% Invert APDCBT
if on8x8blocks
    if dwt_comp == 2
        cV_wat = blkproc(Y_new,[8 8],@iapdcbt);
    elseif dwt_comp == 3
        cD_wat = blkproc(Y_new,[8 8],@iapdcbt);
    end
else
    cV_wat = iapdcbt(Y_new);
end

if dwt_comp == 2
    V1img_wat = wcodemat(cV_wat,255,'mat',1);
elseif dwt_comp == 3
    D1img_wat = wcodemat(cD_wat,255,'mat',1);
end

%Reverse wavelet
if dwt_comp == 2
    I_wat = uint8(idwt2(cA, cH, cV_wat, cD, 'Haar'));
elseif dwt_comp == 3
    I_wat = uint8(idwt2(cA, cH, cV, cD_wat, 'Haar'));
end 


D1img_wat = wcodemat(cD_wat,255,'mat',1);
imshow(uint8([A1img,H1img; V1img,D1img_wat]));

q = WPSNR(I, I_wat);
fprintf('Images (original-watermarked) WPSNR = +%5.2f dB\n',q);

q = PSNR(I, I_wat);
fprintf('Images (original-watermarked) PSNR = +%5.2f dB\n',q);

if show_images
    % suptitle('Original Image(Left)and Watermarked DWT-DCT(Right)');
    subplot(1,2,1);
    imshow(uint8([A1img,H1img; V1img,D1img]));
    %imshow(I);
    subplot(1,2,2);
    if dwt_comp == 2
       imshow(uint8([A1img,H1img; V1img_wat,D1img]));
    elseif dwt_comp == 3
       imshow(uint8([A1img,H1img; V1img,D1img_wat]));
    end
    %imshow(I_wat);
end

imwrite(I_wat,"lena_iquartz.bmp");

