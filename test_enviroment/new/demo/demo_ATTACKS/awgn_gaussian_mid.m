
function Iatt = awgn_gaussian_mid(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'gaussian');%0, 0.01 default

