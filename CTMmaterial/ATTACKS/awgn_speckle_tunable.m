
function Iatt = awgn_speckle_tunable(Iw, noisePower, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'speckle', noisePower); %0.05 default

