
% get artificial stimuli images
% read number of artificial stimuli based on runs into list
imgs = dir(['/home/data/eccolab/AMax/online_behavior/Pavlovia/artificial_stim_used_v2-4_excluding_patterns/*.png']);

c = 0;

[x,y] = meshgrid(1:227,1:227);
f = sqrt((x-227/2).^2+(y-227/2).^2); 

% define frequencies
low_freq = f < 30; 
high_freq = f > 50;

% make empty arrays to contain target subject and target roi columns
target_subject_full = cell(length(imgs),1);
target_roi_full = cell(length(imgs),1);

for i = 1:length(imgs)
    c = c + 1;

    % get image name for artificial stimuli
    newImage = ([imgs(i).folder '/' imgs(i).name]);
    % read artificial stim as images and get red green blue (rgb) values
    % rgb = imread([imgName]);
    % imshow(rgb);

    % get target subject and roi
    splitName = split(newImage,"_");
    target_subject = splitName(9,:);
    target_roi = splitName(10,:);
    
    img = readAndPreprocessImage(newImage);

    r(c,:) = imhist(img(:,:,1));
    g(c,:) = imhist(img(:,:,2));
    b(c,:) = imhist(img(:,:,3));
   
    psd = abs(fftshift(fft2(img))).^2;
    spatial_power(c,:) = single(psd(:));

    high_f(c) = mean(psd(high_freq));
    low_f(c) = mean(psd(low_freq));

    target_subject_full{i} = target_subject;
    target_roi_full{i} = target_roi;

end

median_red = median(r');
median_green = median(g');
median_blue = median(b');

save(['compare_images_artStim_color_red.mat'],'median_red');
save(['compare_images_artStim_color_green.mat'],'median_green');
save(['compare_images_artStim_color_blue.mat'],'median_blue');
save(['compare_images_artStim_spatialFreq_high.mat'],'high_f');
save(['compare_images_artStim_spatialFreq_low.mat'],'low_f');