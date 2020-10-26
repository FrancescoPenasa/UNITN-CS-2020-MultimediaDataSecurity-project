function Iatt = l_cb_blur_mid(Iw)
f = @(x) imgaussfilt( x );
Iatt = localized_attack(f, Iw, "center big");
