function Iatt = sharpening_tunable(Iw, nRad, nPower, thr)

    Iatt = imsharpen(Iw, 'Radius', nRad, 'Amount', nPower, 'Threshold', thr);



