function Iatt = l_lc_median_mid(Iw)
f = @(x) medfilt2( x ,[3 3] );
Iatt = localized_attack(f, Iw, "lower center");
