function Iatt = l_rh_median_mid(Iw)
f = @(x) medfilt2( x ,[3 3] );
Iatt = localized_attack(f, Iw, "right half");
