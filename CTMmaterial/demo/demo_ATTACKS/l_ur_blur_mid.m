function Iatt = l_ur_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f,Iw, "upper right");
