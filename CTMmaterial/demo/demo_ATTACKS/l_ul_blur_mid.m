function Iatt = l_ul_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f, Iw, "upper left");
