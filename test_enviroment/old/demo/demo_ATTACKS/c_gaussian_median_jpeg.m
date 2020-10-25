function Iatt = c_gaussian_median_jpeg(Iw)
    rng(42); % Seed random generator
    Iw = imnoise(Iw,'gaussian');%0, 0.01 default
    Iw = medfilt2(Iw,[3 3]);
    imwrite(Iw, 'SSatt.jpg', 'Quality', 80);
    Iatt = imread('SSatt.jpg');
    delete('SSatt.jpg');





