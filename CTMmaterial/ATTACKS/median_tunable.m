function [Iatt, string] = median_tunable(Iw,na,nb)
string = strcat("Median: ", num2str(na), "x", num2str(nb), "; ");
Iatt = medfilt2(Iw,[na nb]);
