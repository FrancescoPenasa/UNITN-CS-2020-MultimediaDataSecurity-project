
function Iatt = awgn_gaussian_low(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'gaussian',0, 0.001);%0, 0.01 default

