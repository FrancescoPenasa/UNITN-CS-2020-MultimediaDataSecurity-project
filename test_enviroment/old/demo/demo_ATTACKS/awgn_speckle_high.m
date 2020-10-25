
function Iatt = awgn_speckle_high(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'speckle', 0.1);%0.05 default

