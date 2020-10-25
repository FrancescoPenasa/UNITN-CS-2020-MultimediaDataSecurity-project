close all; clear; clc;

% list of all attacks
attacks_dir = "demo/demo_ATTACKS";
attacks = {dir(attacks_dir).name};

% list of all watermarked images
watermarked_dir = "demo/demo_WATERMARKED";
watermarked = {dir(watermarked_dir).name};

% list of all images
originals_dir = "demo/demo_ORIGINAL";
originals = {dir(originals_dir).name};

% list all detections functions
detections_dir = "demo/demo_DETECTIONS";
detections = {dir(detections_dir).name};


%groups_list_file = "groupsList.txt";
output_file = "attack_results.csv";
%groups= importdata(groups_list_file);
results_csv = ["Image","Group","w", "WPSNR","Attack Parameters"];

% iquartz_groupB_imageName.bmp attacked
% imageName.bmp Original
% groupB_imageName.bmp watermarked


results_csv = ["Image","Group","w", "WPSNR","Attack Parameters"];

for i = 1:length(watermarked)
    if (watermarked(i) == ".") || (watermarked(i) == "..") 
        continue;
    end
    disp("Image: " + watermarked(i));    
    
    % read watermarked image "groupName_nameImage.bmp"
    Iw = imread(strcat(watermarked_dir, "/", watermarked(i)));

    
    % find original image "nameImage.bmp"
    groupName = split(watermarked(i), '_');
    original = groupName(2);
    groupName = groupName(1);
    
    I = imread(strcat(originals_dir, "/", original));
        
    % check detection = check the dir for detection_iquartz
    detection_function = strcat("detection_", groupName, "");
    detection_fh = str2func(detection_function);
    
    for j = 1:length(attacks)
        if (attacks(j) == ".") || (attacks(j) == "..")
            continue;
        end
        atk = strcat("", attacks(j), "");
        atk = erase(atk, ".m");
        disp("Atk: " + atk)
        
        % perform attack
        atk_fh = str2func(atk);
        Iatt = atk_fh(Iw);
        
        % Check result
        
        imwrite(uint8(Iatt),"attacked.bmp");
        imwrite(uint8(Iw),"watermarked.bmp");
        imwrite(uint8(I),"original.bmp");
        [contains, wpsnr_value] = detection_iquartz("original.bmp", "watermarked.bmp", "attacked.bmp");
        if (contains == 1)
            disp("FAIL: " + atk + " on " + watermarked(i))
        else
            disp("SUCCESS: " + atk + " on " + watermarked(i))
            if (wpsnr_value >= 35)
                disp("SUPER SUCCESS: " + atk + " on " + watermarked(i))
                fprintf('Watermarks WPSNR = +%5.2f dB\n',wpsnr_value);
            end
        end
        
        new_csv = [watermarked(i), groupName, contains, wpsnr_value, atk];
        results_csv = [results_csv; new_csv];

    end
    
end

writematrix(results_csv, output_file);

