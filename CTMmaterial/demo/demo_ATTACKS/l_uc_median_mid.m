function Iatt = l_uc_median_mid(Iw)
f = @(x) medfilt2( x ,[3 3] );
Iatt = localized_attack(f, Iw, "upper center");
