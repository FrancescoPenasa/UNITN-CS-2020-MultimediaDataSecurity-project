function [Iatt, string] = blur_tunable(Iw, noisePower)

string = strcat("Blur: sigma ", num2str(noisePower), "; ");

Iatt = imgaussfilt(Iw,noisePower);


