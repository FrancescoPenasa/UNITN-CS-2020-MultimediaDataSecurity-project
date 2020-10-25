
function Iatt = jpeg_30(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 30);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




