function [Iatt,string] = sharpening_tunable(Iw, nRad, nPower, thr)
    string = strcat("Sharpening Radius: ", num2str(nRad), " Amount: ", num2str(nPower), " Threashold: ", num2str(thr), "; ");
    Iatt = imsharpen(Iw, 'Radius', nRad, 'Amount', nPower, 'Threshold', thr);
    


