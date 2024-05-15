addpath(genpath('/home/data/eccolab/Code/GitHub/CanlabCore'))
addpath('/home/data/eccolab/Code/GitHub/spm12')
load netTransfer_20cat.mat

%%
subject = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'};
roi = {'amy' 'it' 'vc' 'AStr' 'CM' 'LB' 'SF'};

%%
% feed artificial stim into ANN for predicted activations
c=1;

% get artificial image activations from encoding model
for s = 1:length(subject)
  
  for g = 1:length(roi)
    % get betas
    % read the file into a table
    table = readtable(['/home/data/eccolab/AMax/encoding_models/betas/compare_images_mean_b/meanbeta_sub-' subject{s} '_' roi{g} '_fc7_invert_imageFeatures.csv']); % use mean_betas            
    % get betas from table
    betas(s,:,g) = table.Var1;       

  end

end

% betas = squeeze(mean(betas));
subj_inds=1:20;

% get artificial image activations from encoding model
for s = 1:length(subject)
  
  for g = 1:length(roi)
   
    
    % get artificial stimuli
    % read number of artificial stimuli based on runs into list
    imgList= dir(['/home/data/eccolab/AMax/online_behavior/Pavlovia/artificial_stim_used_v2-4/emonet_fc7_sub' subject{s} '_' roi{g} '_run*.png']);
    num_run = 1:length(imgList);

    for f = num_run
      % get image name for artificial stimuli
      imgName = ([imgList(f).folder filesep imgList(f).name]);
      image_name{c} = imgName;
      % read artificial stim as images
      img = imread([imgName]);
      I{c}=imresize(flipud(img),[512 512]);
      % get predicted activation for artificial stim in ANN
      acts(c,:) = activations(netTransfer, readAndPreprocessImage(img),'fc7');
       
      % get the predicted activations for artificial stim in the encoding models
      enc_prediction(c,:) = squeeze(acts(c,:))*squeeze(betas(s,:,:));
      enc_prediction_avg(s,c,:) = squeeze(acts(c,:))*squeeze(mean(betas(subj_inds~=s,:,:)));
      
      image_mat(c,:) = img(:);
      subj_full{c}=subject{s};
      roi_full{c}=roi{g};
      run_full(c)=f; 
      
      c=c+1;
        
    
    end
  end
end


%% create RMDS
RDM_pixel = 1-corr(double(image_mat'));
RDM_fc7 = 1-corr(double(acts'));
RDM_subj = 1- corr(condf2indic(categorical(subj_full))');
RDM_roi = 1- corr(condf2indic(categorical(roi_full))');
RDM_enc = 1- corr(double(enc_prediction'));

%% supervised learning, predict activation target (representational connectivity: respresentations in different regions of the same brain)

Y = zscore(condf2indic(categorical(roi_full)));

kinds = double(categorical(subj_full)); %train and test on images from different subjects
for k=1:max(kinds) 

    train = kinds~=k;
    test = ~train;

    [~,~,~,~,b] = plsregress(double(enc_prediction(train,:)),Y(train,:),7); % b = regression coefficient (beta)
    yhat(kinds==k,:)=[ones(length(find(kinds==k)),1) double(enc_prediction(kinds==k,:))]*b;

end

[~, pred_cat]=max(yhat,[],2);
[~, true_cat]=max(Y,[],2);

%[k,stats] = cluster_confusion_matrix(pred_cat,true_cat,'labels',roi','method', 'ward','dofig');

[k,stats] = cluster_confusion_matrix(pred_cat,true_cat,'labels',roi','method', 'ward','dofig','pairwise');

res = binotest(stats.optimalY(pred_cat)==stats.optimalY(true_cat),mean(crosstab(true_cat)./length(true_cat)));

%% tsne plot

Y = tsne(enc_prediction);

Y_avg = tsne(squeeze(mean(enc_prediction_avg)));

figure;%subplot(1,2,1); hold on;

plotOfImages = gscatter(Y(:,1),Y(:,2),roi_full',hsv(7));

% subplot(1,2,2); hold on
% 
% for i = 1:size(enc_prediction,1)
% % 
%         drawnow;
%         image(300*Y(i,1),300*Y(i,2),flipud(I{i}));
% 
% end

axis tight;clc

%subplot(1,3,2);
% plotOfImagesSub = gscatter(Y_avg(:,1),Y_avg(:,2),roi_full',hsv(11));

% savefig(plotOfImages, '/home/data/eccolab/MELD/Results/imagesByEmotion.fig')

% save('/home/data/eccolab/MELD/Results/extractedFeatures.mat','vidnames','speaker','emotion','sentiment','avg_features')

addpath(genpath('/home/data/eccolab/PMA/PositiveValenceMegaAnalysis/Code/manulera-UnivarScatter-462014d'))
%% for bar plots
% 
% for s=1:length(subject) 
%     for r=1:length(roi) 
%         data_to_plot(s,:,r) = mean(enc_prediction(strcmp(subj_full,subject{s}) & strcmp(roi_full,roi{r}),:));
%         data_to_plot_subject_independent(s,:,r) = mean(enc_prediction_avg(s,strcmp(subj_full,subject{s}) & strcmp(roi_full,roi{r}),:));
% 
%     end;
% end
% 
% 
% figure; 
% for r=1:11
%     subplot(11,1,r);UnivarScatter(squeeze(data_to_plot(:,r,:)),'MarkerFaceColor',hsv(11));
% 
% 
%     hold on;
%     h = findobj(gca,'Type','scatter');
% 
% end
% 
% set(gca,'XTickLabel',roi)