function Iatt = l_uc_blur_mid(Iw)
f = @(x) imgaussfilt( x);
Iatt = localized_attack(f, Iw, "upper center");
