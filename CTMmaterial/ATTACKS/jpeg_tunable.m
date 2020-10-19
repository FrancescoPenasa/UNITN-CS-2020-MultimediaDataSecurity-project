
function Iatt = jpeg_tunable(Iw, QF)

imwrite(Iw, 'SSatt.jpg', 'Quality', QF);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




