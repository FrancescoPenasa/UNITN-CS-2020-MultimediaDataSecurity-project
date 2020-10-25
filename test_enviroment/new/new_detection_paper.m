close all; clear; clc;

new_config_constants; 

% todo add original image stuff
% TODO: uniformare la naming convention (w o _wat) tra qua e insertion

 % Load Images
 original = 'demo_ORIGINAL/lena'; 
 watermarked = 'demo_WATERMARKED/iquartz_lena';
 attacked = 'attacked_lena';
I       = imread(original,'bmp');
I_wat   = imread(watermarked,'bmp');
I_att = I_wat;
%I_att   = imread(attacked,'bmp');

disp("Detecting watermark in: " + original);

% Extract Watermarks as 32x32 images
watermark          = extract_watermark_helper(I, I_wat, DWT_L2, W_SIZE, ALPHA);
watermark_attacked = extract_watermark_helper(I, I_att, DWT_L2, W_SIZE, ALPHA);

subplot(1,2,1);
imshow(watermark);
subplot(1,2,2);
imshow(watermark_attacked);

% Reshape Watermarks
w_vec     = reshape(watermark, 1, W_SIZE*W_SIZE);
w_att_vec = reshape(watermark_attacked, 1, W_SIZE*W_SIZE);

% Calculate Similarity between the Original and the Attacked Watermarks
SIM = w_vec * w_att_vec' / sqrt(w_att_vec * w_att_vec');

%SIM = watermark * watermark_attacked' / sqrt (watermark_attacked * watermark_attacked');

    
%% Compute threshold
%999 matrici da 32x32? o vettori da 1024?
randWatermarks = round(rand(999,size(w_vec,2))); 
x = zeros(1,1000);
 
x(1) = SIM;  
for i = 1:999
    w_rand = randWatermarks(i,:);
    x(i+1) = w_vec * w_rand' / sqrt( w_rand * w_rand' );
end

plot(x)

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

% Calculate the WPSNR between the Watermarked and the Attacked Image
wpsnr_value = WPSNR(I_wat, I_att);
fprintf('WPSNR watermarked - attacked = +%5.2f dB\n', wpsnr_value);

if wpsnr_value < 35  % return 0
    contains = 0;  
end

q = WPSNR(w_vec, w_att_vec);
fprintf('Watermarks WPSNR = +%5.2f dB\n',q);




