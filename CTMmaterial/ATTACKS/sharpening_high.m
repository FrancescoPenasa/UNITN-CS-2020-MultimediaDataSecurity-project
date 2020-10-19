function Iatt = sharpening_high(Iw)

    Iatt = imsharpen(Iw, 'Radius', 1.5, 'Amount', 1.2, 'Threshold', 0.7);



