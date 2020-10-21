%% Global constants to import in files

% Perform apdcbt on 8x8 blocks
on8x8blocks = true;
% In the detection: perform attacks on the watermarked image
attack = false;
show_images = true;
if on8x8blocks
    alpha = 30;
else
    alpha = 1.7
end

%chose DWT component
%dwt_comp = 1; %Top Left, horizontal
%dwt_comp = 2; %Bottom Right, vertical
dwt_comp = 2; %Bottom Left, diagonal

svd_insertion = true;