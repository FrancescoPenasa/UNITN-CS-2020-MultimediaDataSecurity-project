
function Iatt = awgn_gaussian_high(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'gaussian', 0, 0.1); %0, 0.01 default
