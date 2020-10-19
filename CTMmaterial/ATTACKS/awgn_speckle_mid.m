
function Iatt = awgn_speckle_mid(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'speckle');%0.05 default

