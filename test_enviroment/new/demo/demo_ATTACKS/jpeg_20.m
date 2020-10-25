
function Iatt = jpeg_20(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 20);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




