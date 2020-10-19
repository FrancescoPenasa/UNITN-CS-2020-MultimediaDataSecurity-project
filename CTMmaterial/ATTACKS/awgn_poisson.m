
function Iatt = awgn_poisson(Iw, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'poisson');

