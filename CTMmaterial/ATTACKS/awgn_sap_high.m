
function Iatt = awgn_sap_high(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper', 0.1); % 0.05

