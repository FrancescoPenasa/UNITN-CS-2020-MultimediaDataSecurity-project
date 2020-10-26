function Iatt = l_lc_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f, Iw, "lower center");
