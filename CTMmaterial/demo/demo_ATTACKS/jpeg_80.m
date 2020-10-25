
function Iatt = jpeg_80(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 80);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




