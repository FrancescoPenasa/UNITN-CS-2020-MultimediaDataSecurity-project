function Iatt = l_cc_blur_high(Iw)
f = @(x) imgaussfilt( x , 1);
Iatt = localized_attack(f, Iw, "center");


