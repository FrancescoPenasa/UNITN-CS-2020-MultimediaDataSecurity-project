
function Iatt = awgn_sap_low(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper', 0.01); % 0.05

