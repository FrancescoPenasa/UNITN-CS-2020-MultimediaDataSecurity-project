close all; clear; clc;

%% Read original image and convert it to double
I = imread('lena.bmp');
[dimx,dimy] = size(I);
Id = double(I); % TODO: needed?

%% Load the watermark (variable w) of size 32x32
load('iquartz.mat');

%% Perform DWT on Carier Image
[LL, LH, HL, HH] = dwt2(I, 'Haar');

%% Perform Block-Based APDCBT on HL Sub-band
[Y, V] = apdcbt(HL); % Obtain DC Coefficients

%% Get DC Coefficient Matrix M and Perform SVD on M
M = [Y, V];         % Create a Matrix from DC Coefficients
[U, S, V] = svd(M); % Singular value decomposition

%% Watermark Insertion
a = 1; % TODO: Scaling Factor
Sw = S + a * w;
[Uw, Sw1, Vw] = svd(Sw);
Mw = U * Sw1 * V.'; % Watermarked DC coefficient Matrix
HLw = iapdcbt(Mw);k