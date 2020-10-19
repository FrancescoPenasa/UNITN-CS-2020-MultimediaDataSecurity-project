
function Iatt = awgn_sap_tunable(Iw, noisePower, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper',noisePower); % 0.05

