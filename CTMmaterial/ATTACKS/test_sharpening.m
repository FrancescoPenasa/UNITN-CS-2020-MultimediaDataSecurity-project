function Iatt = test_sharpening(Iw, nRad, nPower, thr)

    Iatt = imsharpen(Iw, 'Radius', nRad, 'Amount', nPower, 'Threshold', thr);



