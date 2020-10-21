
function [Iatt, string] = awgn_speckle_tunable(Iw, noisePower, seed)

rng(seed); % Seed random generator

string = strcat("AWGN: Speckle, noise=", num2str(noisePower), " seed=", num2str(seed), "; ");
Iatt = imnoise(Iw,'speckle', noisePower); %0.05 default

