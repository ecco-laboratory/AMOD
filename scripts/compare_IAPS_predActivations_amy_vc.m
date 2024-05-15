addpath(genpath('/home/data/eccolab/Code/GitHub'))
addpath(genpath('/home/data/eccolab/Code/GitHub/CanlabCore'))
load netTransfer_20cat.mat

%%
subject = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};
roi = {'amy' 'vc'};

%%
% feed artificial stim into ANN for predicted activations
c=1;

% get encoding models
for s = 1:length(subject)

    for g = 1:length(roi)
        % get betas
        % read the file into a table
        table = readtable(['/home/data/eccolab/AMax/encoding_models/betas/compare_images_mean_b/meanbeta_sub-' subject{s} '_' roi{g} '_fc7_invert_imageFeatures.csv']); % use mean_betas
        % get betas from table
        betas(s,:,g) = table.Var1;

    end

end

%%
% betas = squeeze(mean(betas));
subj_inds=1:20;

% get IAPS images
% read number of IAPS images based on runs into list
imgList= dir(['/home/data/eccolab/IAPS/*.jpg']);
num_run = 1:length(imgList);

for f = num_run
    % get image name for artificial stimuli
    imgName = ([imgList(f).folder filesep imgList(f).name]);
    % read artificial stim as images
    img = imread([imgName]);
    load(strrep(imgName,'.jpg','_valence.mat'));
    val(f)=X;
    load(strrep(imgName,'.jpg','_arousal.mat'));
    arousal(f)=X;
    %I{f}=imresize(flipud(img),[512 512]);
    % get predicted activation for artificial stim in ANN
    acts(f,:) = activations(netTransfer, readAndPreprocessImage(img),'fc7');
    %acts_fc8(c,:) = activations(netTransfer, readAndPreprocessImage(img),'fc');


    % get artificial image activations from encoding model
    for s = 1:length(subject)


        % get the predicted activations for artificial stim in the encoding models
        enc_prediction(c,:) = squeeze(acts(f,:))*squeeze(betas(s,:,:));
        enc_prediction_avg(c,:) = squeeze(acts(f,:))*squeeze(mean(betas(subj_inds~=s,:,:)));

        %image_mat(c,:) = img(:);
        subj_full{c}=subject{s};
        val_full(c)=val(f);
        arous_full(c)=arousal(f);
        %li=strfind(imgList(f).name,'_');
        %roi_full{c}=imgList(f).name(strfind(imgList(f).name,'fc8')+2:li(end)-1); %ASK: Why 'fc8' here? "Error using strfind. Not enough input arguements."

        c=c+1;


    end
end

%% correlate predicted activations with valence: for bar plots - change to RainCloudPlot (use line_plot_multisubject)
ap = prctile(arousal,[0:10:100]);

for s=1:length(subject)
        for a=2:length(ap)
            data_to_plot(s,a-1,:) = mean(enc_prediction(arous_full > ap(a-1) & arous_full < ap(a) & strcmp(subj_full,subject{s}),:));
            data_to_plot_subj_independent(s,a-1,:) = mean(enc_prediction_avg(arous_full > ap(a-1) & arous_full < ap(a) & strcmp(subj_full,subject{s}),:));
        end

        arousal_corr(s,:)=corr(enc_prediction(strcmp(subj_full,subject{s}),:),arous_full(strcmp(subj_full,subject{s}))');
end

[p tbl st]=friedman(squeeze(data_to_plot(:,:,1))) %note to self: (:,:,1)=amygdala, (:,:,2)= vc

multcompare(st)

barplot_columns(data_to_plot(:,:,1))

%[h p ci st]=ttest(squeeze(data_to_plot(:,:,1))*[-1 -4/5 -3/5 -2/5 -1/5 1/5 2/5 3/5 4/5 1]') % *zscore(1:10)'

%% correlate predicted activations with valence: for bar plots - change to RainCloudPlot (use line_plot_multisubject)
%vp = prctile(val,[0:10:100]);

% for s=1:length(subject)
%         for v=2:9
% 
%             data_to_plot(s,v-1,:) = mean(enc_prediction(val_full > v -1 & val_full < v & strcmp(subj_full,subject{s}),:));
%             data_to_plot_subj_independent(s,v-1,:) = mean(enc_prediction_avg(val_full > v -1 & val_full < v & strcmp(subj_full,subject{s}),:));
%         end
% 
%         valence_corr(s,:)=corr(enc_prediction(strcmp(subj_full,subject{s}),:),val_full(strcmp(subj_full,subject{s}),:));
% end
%
%[p tbl st]=friedman(squeeze(data_to_plot(:,:,1))) %note to self: (:,:,1)=amygdala,(:,:,2)= vc
%
%multcompare(st)
%
%barplot_columns(data_to_plot(:,:,1))
%
%[h p ci st]=ttest(squeeze(data_to_plot(:,:,1))*[-1 -4/5 -3/5 -2/5 -1/5 1/5 2/5 3/5 4/5 1]') % *zscore(1:10)'

%%
figure;
for r=1:2
    subplot(2,1,r);bar(squeeze(nanmean(data_to_plot(:,:,r))));
end