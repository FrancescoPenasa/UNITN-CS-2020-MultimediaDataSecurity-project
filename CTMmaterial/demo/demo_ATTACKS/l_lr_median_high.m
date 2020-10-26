function Iatt = l_lr_median_high(Iw)
f = @(x) medfilt2( x ,[3 1] );
Iatt = localized_attack(f, Iw, "lower right");
