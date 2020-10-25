function Iatt = c_resize_jpeg(Iw)
    n = size(Iw);
    Iw = double(Iw);
    Iw = imresize(Iw, 0.75);
    Iw = imresize(Iw, 1/.75);
    Iw = uint8(Iw(1:n(1), 1:n(2)));
    imwrite(Iw, 'SSatt.jpg', 'Quality', 80);
    Iatt = imread('SSatt.jpg');
    delete('SSatt.jpg');