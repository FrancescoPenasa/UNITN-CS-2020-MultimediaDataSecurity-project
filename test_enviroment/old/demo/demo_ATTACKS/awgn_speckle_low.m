
function Iatt = awgn_speckle_low(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'speckle', 0.01);%0.05 default

