
function Iatt = awgn_poisson(Iw)

rng(42); % Seed random generator

Iatt = imnoise(Iw,'poisson');

