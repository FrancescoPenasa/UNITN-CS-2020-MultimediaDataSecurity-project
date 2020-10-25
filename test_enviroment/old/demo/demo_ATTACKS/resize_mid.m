function Iatt = resize_mid(Iw)

n = size(Iw);
Iw = double(Iw);
Iatt = imresize(Iw, 0.75);
Iatt = imresize(Iatt, 1/.75);
Iatt = uint8(Iatt(1:n(1), 1:n(2)));




