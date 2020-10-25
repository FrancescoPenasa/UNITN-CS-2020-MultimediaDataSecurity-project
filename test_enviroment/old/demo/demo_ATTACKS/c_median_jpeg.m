function Iatt = c_median_jpeg(Iw)
    Iw = medfilt2(Iw,[3 3]);
    imwrite(Iw, 'SSatt.jpg', 'Quality', 80);
    Iatt = imread('SSatt.jpg');
    delete('SSatt.jpg');

