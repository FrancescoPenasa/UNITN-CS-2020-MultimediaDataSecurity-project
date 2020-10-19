
function Iatt = awgn_speckle_low(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'speckle', 0.01);%0.05 default

