function Iatt = c_gaussian_median(Iw)
    rng(42); % Seed random generator
    Iw = imnoise(Iw,'gaussian');%0, 0.01 default
    Iatt = medfilt2(Iw,[3 3]);



