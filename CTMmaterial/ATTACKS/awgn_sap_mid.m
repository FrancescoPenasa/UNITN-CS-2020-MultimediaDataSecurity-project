
function Iatt = awgn_sap_mid(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'salt & pepper'); % 0.05

