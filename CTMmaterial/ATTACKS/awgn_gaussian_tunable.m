
function Iatt = awgn_gaussian_tunable(Iw, mean, noisePower, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'gaussian', mean, noisePower); %0, 0.01 default

