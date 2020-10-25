function Iatt = resize_low(Iw)

n = size(Iw);
Iw = double(Iw);
Iatt = imresize(Iw, 0.9);
Iatt = imresize(Iatt, 1/0.9);
Iatt = uint8(Iatt(1:n(1), 1:n(2)));




