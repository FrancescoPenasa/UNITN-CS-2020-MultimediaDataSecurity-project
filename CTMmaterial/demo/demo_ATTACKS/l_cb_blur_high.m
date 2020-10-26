function Iatt = l_cb_blur_high(Iw)
f = @(x) imgaussfilt( x , 1 );
Iatt = localized_attack(f, Iw, "center big");


