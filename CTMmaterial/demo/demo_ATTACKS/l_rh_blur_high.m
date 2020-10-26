function Iatt = l_rh_blur_high(Iw)
f = @(x) imgaussfilt( x , 1);
Iatt = localized_attack(f, Iw, "right half");


