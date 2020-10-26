function Iatt = l_lc_median_low(Iw)
f = @(x) medfilt2( x ,[5 5] );
Iatt = localized_attack(f, Iw, "lower center");
