
function Iatt = jpeg_50(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 50);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




