function Iatt = localized_attack(attack_function, Iw, location)

[h, w] = size(Iw);

if location == "center"
    loc_start_row = round(h/3);
    loc_end_row = round(h*2/3);
    loc_start_col = round(w/3);
    loc_end_col = round(w*2/3);
    
elseif location == "center big"
    loc_start_row = round(h/5);
    loc_end_row = round(h*4/5);
    loc_start_col = round(w/5);
    loc_end_col = round(w*4/5);
    
elseif location == "left half"
    loc_start_row = 1;
    loc_end_row = h;
    loc_start_col = 1;
    loc_end_col = round(w/2);
    
elseif location == "right half"
    loc_start_row = 1;
    loc_end_row = h;
    loc_start_col = round(w/2);
    loc_end_col = w;
    
elseif location == "upper half"
    loc_start_row = 1;
    loc_end_row = round(h/2);
    loc_start_col = 1;
    loc_end_col = w;
    
elseif location == "lower half"
    loc_start_row = round(h/2);
    loc_end_row = h;
    loc_start_col = 1;
    loc_end_col = w;
    
elseif location == "upper right"
    loc_start_row = 1;
    loc_end_row = round(h/2);
    loc_start_col = round(w/2);
    loc_end_col = w;
    
elseif location == "upper left"
    loc_start_row = 1;
    loc_end_row = round(h/2);
    loc_start_col = 1;
    loc_end_col = round(w/2);
    
elseif location == "lower right"
    loc_start_row = round(h/2);
    loc_end_row = h;
    loc_start_col = rounf(w/2);
    loc_end_col = w;
    
elseif location == "lower left"
    loc_start_row = round(h/2);
    loc_end_row = h;
    loc_start_col = 1;
    loc_end_col = round(w/2);
end

to_attack = Iw(loc_start_row:loc_end_row, loc_start_col:loc_end_col);
attacked = attack_function(to_attack);
Iatt = Iw;
Iatt(loc_start_row:loc_end_row, loc_start_col:loc_end_col) = attacked;