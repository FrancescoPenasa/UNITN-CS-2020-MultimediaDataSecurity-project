
function [Iatt, string] = awgn_sap_tunable(Iw, noisePower, seed)

rng(seed); % Seed random generator

string = strcat("AWGN: Salt & pepper, noise=", num2str(noisePower), " seed=", num2str(seed), "; ");
Iatt = imnoise(Iw,'salt & pepper',noisePower); % 0.05

