function Iatt = l_cc_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f, Iw, "center");
