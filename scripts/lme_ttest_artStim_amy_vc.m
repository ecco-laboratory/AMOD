addpath(genpath('Github'))

t = readtable('artStim_encPred_color_spatialFreq_targetSub_ROI_data_Z.csv');

%% models for each subject

for s = 1:20

    tsub = t(t.enc_subject==s,:);

    % lme_sub = fitlme(tsub,'amy_enc_pred ~ 1  + target_roi + target_subject + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');
    lme_sub = fitlme(tsub,'vc_enc_pred ~ 1  + target_roi + target_subject + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');

    betas(s,:)=lme_sub.Coefficients.Estimate;

end

%group inference
[h, p, ci, st] = ttest(betas)

barplot_columns(betas(:,2:end))
