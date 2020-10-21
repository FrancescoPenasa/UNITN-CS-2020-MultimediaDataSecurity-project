% list of all attacks
attacks_dir = "CTMmaterial/demo_ATTACKS";
attacks = {dir(attacks_dir).name};

% list of all images
images_dir = "CTMmaterial/demo_IMG";
images = {dir(images_dir).name};

% list all detections functions
detections_dir = "CTMmaterial/demo_DETECTIONS";
detections = {dir(detections_dir).name};


groups_list_file = "groupsList.txt";
output_file = "attack_results.csv";
groups= importdata(groups_list_file);
results_csv = ["Image","Group","WPSNR","Attack Parameters"];

% iquartz_groupB_imageName.bmp attacked
% imageName.bmp Original
% groupB_imageName.bmp watermarked


for i = 1:length(images)
    if (images(i) == ".") || (images(i) == "..") 
        continue;
    end
    disp("Image: " + images(i));    
    I = imread(strcat(images_dir, "/", images(i)));
    I = double(I);

    for i = 1:length(attacks)
        if (attacks(i) == ".") || (attacks(i) == "..")
            continue;
        end
        atk = strcat("", attacks(i), "");
        atk = erase(atk, ".m");
        disp("Atk: " + atk)
        
        
        fh = str2func(atk);
        Iatt = fh(I);
        
        
        q = WPSNR(I, Iatt);
        fprintf('Watermarks WPSNR = +%5.2f dB\n',q);

    end
    
end

