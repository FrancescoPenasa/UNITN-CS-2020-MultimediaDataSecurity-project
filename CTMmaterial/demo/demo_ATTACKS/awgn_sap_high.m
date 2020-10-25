
function Iatt = awgn_sap_high(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper', 0.1); % 0.05

