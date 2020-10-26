function Iatt = l_rh_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f, Iw, "right half");
