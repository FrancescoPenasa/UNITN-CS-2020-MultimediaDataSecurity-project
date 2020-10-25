function Iatt = resize_high(Iw)

n = size(Iw);
Iw = double(Iw);
Iatt = imresize(Iw, 0.5);
Iatt = imresize(Iatt, 1/0.5);
Iatt = uint8(Iatt(1:n(1), 1:n(2)));




