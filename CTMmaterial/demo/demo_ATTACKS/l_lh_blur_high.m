function Iatt = l_lh_blur_high(Iw)
f = @(x) imgaussfilt( x , 1);
Iatt = localized_attack(f, Iw, "left half");


