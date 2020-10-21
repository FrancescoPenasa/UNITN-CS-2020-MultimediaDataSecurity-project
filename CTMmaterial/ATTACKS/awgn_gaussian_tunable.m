
function [Iatt, string] = awgn_gaussian_tunable(Iw, mean, variance, seed)

rng(seed); % Seed random generator
string = strcat("AWGN: Gaussian, mean=", num2str(mean), " variance=", num2str(variance), " seed=", num2str(seed), "; ");
Iatt = imnoise(Iw,'gaussian', mean, variance); %0, 0.01 default

