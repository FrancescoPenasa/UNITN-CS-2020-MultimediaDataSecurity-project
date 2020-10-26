function Iatt = l_ul_median_low(Iw)
f = @(x) medfilt2( x ,[5 5] );
Iatt = localized_attack(f, Iw, "upper left");
