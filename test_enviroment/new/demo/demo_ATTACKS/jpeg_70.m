
function Iatt = jpeg_70(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 70);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




