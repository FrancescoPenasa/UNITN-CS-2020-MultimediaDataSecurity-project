%This is just a dummy code to show you the structure or your detection
%function

function [tr, q1] = detection_groupName(input1, input2, input3)
    I = imread(input1);
    J = imread(input3);
    K = imread(input2);
    tr = randi([0, 1], 1);
    q1 = WPSNR(uint8(J),uint8(I));
end