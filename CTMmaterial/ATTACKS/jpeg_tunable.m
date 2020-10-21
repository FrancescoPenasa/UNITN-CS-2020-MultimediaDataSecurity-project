function [Iatt, string] = jpeg_tunable(Iw, QF)
string = strcat("JPEG: QF ", num2str(QF), "; ");

imwrite(Iw, 'SSatt.jpg', 'Quality', QF);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');




