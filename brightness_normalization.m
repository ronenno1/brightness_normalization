function brightness_normalization(new_brightness)
    imgs_dir = uigetdir();
    if ~imgs_dir
        return
    end

    if ~exist([imgs_dir filesep 'new'], 'file')
        mkdir([imgs_dir filesep 'new']);
    end
    clc
    
    table_original = check_files(imgs_dir, 'original');
    nargin
    
    if nargin <1
        new_brightness = ceil(mean(table_original.brightness_original));
    end
    
    files = [dir([imgs_dir filesep '*.png']); dir([imgs_dir filesep '*.jpg'])];
    files = {files.name}';
    for img_id = 1:size(files, 1)
        clc
        disp(['fix image number ' num2str(img_id)]);

        img        = files{img_id};
        image      = imread([imgs_dir filesep img]);
        brightness = 255;
        try_id = 0;
        while abs(brightness - new_brightness)>.1 && try_id<128
            try_id = try_id+1;
            if brightness > new_brightness
                image = image-1;
            else
                image = image+1;
            end
            brightness =  mean2(rgb2gray(image));
        end
        imwrite(image, [imgs_dir filesep 'new' filesep img]);
    end
    
    table_new = check_files(imgs_dir, 'new');
    
    clc
    disp('Done!');
    output_table = [table_original, table_new];
    writetable(output_table, [imgs_dir filesep 'output_table.csv']); 
end

function table = check_files(imgs_dir, type)
    files = [dir([imgs_dir filesep '*.png']); dir([imgs_dir filesep '*.jpg'])];
    files = {files.name}';
    for img_id = 1:size(files, 1)
        img    = files{img_id};
        clc
        disp(['check image number ' num2str(img_id)]);
        image      = imread([imgs_dir filesep img]);
        brightness =  mean2(rgb2gray(image));
        b.(char(['img_' type])){img_id, :} = [imgs_dir filesep img];
        b.(char(['brightness_' type]))(img_id, :) = brightness;
    end
    table = struct2table(b);
end