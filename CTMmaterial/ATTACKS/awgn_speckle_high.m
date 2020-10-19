
function Iatt = awgn_speckle_high(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'speckle', 0.1);%0.05 default

