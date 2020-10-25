
function Iatt = awgn_sap_low(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper', 0.01); % 0.05

