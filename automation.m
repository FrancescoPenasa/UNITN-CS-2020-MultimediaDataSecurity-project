attacks_dir = "CTMmaterial/ATTACKS";
groups_list_file = "groupsList.txt";
output_file = "attack_results.csv";

groups= importdata(groups_list_file);
images = ["lena", "bridge", "..."];
attacks = {dir(attacks_dir).name};
results_csv = ["Image","Group","WPSNR","Attack Parameters"];


for i = 1:length(groups)
    if groups(i) == "iquartz"
        continue;
    end
    
    disp(" ")
    disp("Attacking group: " + groups(i))

    for img = images
        disp("    Image: " + img)
        
        for atk = attacks
            if (atk == ".") || (atk == "..")
                continue;
            end
            
            disp("        Performing attack: " + atk)
            
            file_to_read = groups(i) + "_" + img + ".bmp";
            file_to_write = "iquartz_" + file_to_read;
            disp("            " + file_to_read + " -> " + file_to_write);
            
            new_csv = [img, groups(i), "wpsn/todo", atk];
            results_csv = [results_csv; new_csv];
        end
    end
end

disp(" ")
disp("Writing results to " + output_file + "...")
writematrix(results_csv, output_file);