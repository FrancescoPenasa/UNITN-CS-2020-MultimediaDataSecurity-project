function Iatt = sharpening_mid(Iw)

    Iatt = imsharpen(Iw, 'Radius', 1, 'Amount', 0.8, 'Threshold', 0.1);



