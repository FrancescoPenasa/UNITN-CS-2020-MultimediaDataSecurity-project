%% Global constants to import in files

% Perform apdcbt on 8x8 blocks
on8x8blocks = true;
% In the detection: perform attacks on the watermarked image
attack = true;
show_images = false;
if on8x8blocks
    alpha = 0.9;
else
    alpha = 1.7
end
