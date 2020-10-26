function Iatt = l_lh_median_high(Iw)
f = @(x) medfilt2( x ,[3 1] );
Iatt = localized_attack(f, Iw, "left half");
