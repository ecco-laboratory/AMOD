
% subject = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};
%roi = {'amy' 'vc'};

% subj_inds=1:20;

% get IAPS/OASIS images
% read number of IAPS/OASIS images based on runs into list
imgs = dir(['/home/data/eccolab/OASIS/Images/*.jpg']);
%imgList= dir(['/home/data/eccolab/OASIS/Images/*.jpg']);
c = 0;

[x,y] = meshgrid(1:227,1:227); 
f = sqrt((x-227/2).^2+(y-227/2).^2); 

low_freq = f < 30; 
high_freq = f > 50;

for i = 1:length(imgs)
    c = c + 1;

    % get image name for artificial stimuli
    newImage = ([imgs(i).folder '/' imgs(i).name]);
    % read artificial stim as images and get red green blue (rgb) values
    % rgb = imread([imgName]);
    % imshow(rgb);
    img = readAndPreprocessImage(newImage);

    r(c,:) = imhist(img(:,:,1));
    g(c,:) = imhist(img(:,:,2));
    b(c,:) = imhist(img(:,:,3));
   
    psd = abs(fftshift(fft2(img))).^2;
    spatial_power(c,:) = single(psd(:));

    high_f(c) = mean(psd(high_freq));
    low_f(c) = mean(psd(low_freq));

    %mean_red(c) = mean(r);
    %mean_green(c) = mean(g);
    %mean_blue(c) = mean(b);

%     for s = 1:length(subject)
%        red_full(c) = mean_red(f);
%        green_full(c) = mean_green(f);
%        blue_full(c) = mean_blue(f);
%    end

end

median_red = median(r');
median_green = median(g');
median_blue = median(b');

save(['compare_images_OASIS_color_red.mat'],'median_red');
save(['compare_images_OASIS_color_green.mat'],'median_green');
save(['compare_images_OASIS_color_blue.mat'],'median_blue');
save(['compare_images_OASIS_spatialFreq_high.mat'],'high_f');
save(['compare_images_OASIS_spatialFreq_low.mat'],'low_f');