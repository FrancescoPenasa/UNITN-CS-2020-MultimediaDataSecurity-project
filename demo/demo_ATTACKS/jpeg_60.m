
function Iatt = jpeg_60(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 60);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




