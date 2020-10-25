function Iatt = c_sap_median(Iw)
    rng(42); % Seed random generator
    Iw = imnoise(Iw,'salt & pepper');
    Iatt = medfilt2(Iw,[3 3]);