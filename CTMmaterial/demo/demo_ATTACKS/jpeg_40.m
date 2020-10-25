
function Iatt = jpeg_40(Iw)

imwrite(Iw, 'SSatt.jpg', 'Quality', 40);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




