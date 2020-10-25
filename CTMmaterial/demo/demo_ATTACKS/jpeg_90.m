
function Iatt = jpeg_90(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 90);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




