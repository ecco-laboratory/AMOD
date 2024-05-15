addpath(genpath('Github'))

%% Assess IAPS and OASIS individually
% %t = readtable('IAPS_data_UPDATED_Zscores.csv');
% t = readtable('OASIS_data_UPDATED_Zscores.csv');
% 
% % models for each subject
% for s = 1:20
%     tsub = t(t.subject==s,:);
%     lme_sub = fitlme(tsub,'amy_enc_pred ~ 1  + val_full_z + arous_full_z + val_full_z:arous_full_z + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');
%     betas(s,:)=lme_sub.Coefficients.Estimate;
% 
%     lme_sub_vc = fitlme(tsub,'vc_enc_pred ~ 1  + val_full_z + arous_full_z + val_full_z:arous_full_z + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');
%     betas_vc(s,:)=lme_sub_vc.Coefficients.Estimate;
% end
% 
% % group inference
% %[h, p, ci, st] = ttest(betas)
% [h, p, ci, st] = ttest(betas-betas_vc)
% %
% barplot_columns(betas(:,2:end))



%% Average over IAPS and OASIS (for more compact set of results)
filenames = {'OASIS_data_UPDATED_Zscores' 'IAPS_data_UPDATED_Zscores'};

for f=1:length(filenames)
   t = readtable([filenames{f} '.csv']);

% models for each subject
   for s = 1:20
       tsub = t(t.subject==s,:);
       lme_sub = fitlme(tsub,'amy_enc_pred ~ 1  + val_full_z + arous_full_z + val_full_z:arous_full_z + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');
       betas(f,s,:)=lme_sub.Coefficients.Estimate;
 
      lme_sub_vc = fitlme(tsub,'vc_enc_pred ~ 1  + val_full_z + arous_full_z + val_full_z:arous_full_z + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');
       betas_vc(f,s,:)=lme_sub_vc.Coefficients.Estimate;
   end

end

%

[h, p, ci, st]=ttest(squeeze(mean(betas)));

[h, p, ci, st]=ttest(squeeze(mean(betas))-squeeze(mean(betas_vc)))

barplot_columns(squeeze(mean(betas))-squeeze(mean(betas_vc)),'dolines')