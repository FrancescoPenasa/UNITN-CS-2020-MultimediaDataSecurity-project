
function Iatt = awgn_sap_mid(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper'); % 0.05

