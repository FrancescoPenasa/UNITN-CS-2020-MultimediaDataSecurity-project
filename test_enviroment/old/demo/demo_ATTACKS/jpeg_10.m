
function Iatt = jpeg_10(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 10);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




