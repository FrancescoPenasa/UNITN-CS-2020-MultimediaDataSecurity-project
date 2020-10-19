
function Iatt = jpeg_95(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 95);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




