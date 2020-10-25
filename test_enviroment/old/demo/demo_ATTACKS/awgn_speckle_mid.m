
function Iatt = awgn_speckle_mid(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'speckle');%0.05 default

