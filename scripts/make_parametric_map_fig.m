addpath(genpath('Github'))

% step one-- UPDATED: load fmri data and apply amygdala mask for each subject (originally, load fmri for only one subject)
subjects = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20'}

for s = 1:length(subjects)
        
    %load BOLD data for each subject
    dat = fmri_data(['/home/data/eccolab/OpenNeuro/ds002837/derivatives/sub-' subjects{s} '/func/sub-' subjects{s} '_task-500daysofsummer_bold_blur_censor.nii.gz']);
    
    % masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('glasser'),{'Ctx_V1', 'Ctx_V2', 'Ctx_V3'})); %mask for early layers of visual cortex (V1-V3)
    % masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('canlab2018'),{'Amy'})); %mask for amygdala (252 voxels)
    masked_dat = apply_mask(dat,select_atlas_subset(load_atlas('glasser'),{'Ctx_TE2', 'Ctx_TF'})); %mask for inferotemporal cortex (TE2a, TE2p, TF)

    excluded_voxels(s,:) = masked_dat.removed_voxels %ADDED: create a variable that evaluates each subject for removed voxels. This will make a matrix of all voxels (1032) in IT across subjects (20) that have any data 

end

% step two -- load n subj x n voxel amygdala output (atanh) for layer
load('/home/gjang/OutputNNDb/NNDb_Output/ImageFeatures/Stats/FC7/Inverted_IT/IT_fc7_invert_imageFeatures_output_matrix_atanh.mat')

atanh_matrix(atanh_matrix==0) = NaN %ADDED: this line assigns any 0 value as NaN

% step three -- perform a ttest on that output
[h, p, ci, stats] = ttest(atanh_matrix);

% step four create a statistic image object
stats_object = statistic_image;
stats_object.volInfo = masked_dat.volInfo;
stats_object.removed_voxels = all(excluded_voxels); %MODIFIED: originally "stats_object.removed_voxels = masked_dat.removed_voxels"

% step five assign t values to that object
stats_object.dat = stats.tstat';

% step six (threshold if we want) and write out as nifti image
stats_object.fullpath = '/home/gjang/tstat_FisherZ_itcortex_imageFeatures_fc7_threshold.nii';
write(stats_object,'overwrite');

save('itcortex_fc7_parametric_mapping_workspace.mat')


%% write thresholded objects

% thresholded by p < 0.001
th_stats_object = stats_object;
th_stats_object.dat(~(p<.001))=NaN;
th_stats_object.fullpath = '/home/gjang/tstat_FisherZ_itcortex_imageFeatures_fc7_threshold_p001.nii';
write(th_stats_object,'overwrite');

% thresholded by (FDR) False Discovery Rate's version of p = q < 0.05
th_stats_object = stats_object;
th_stats_object.dat(~(p<FDR(p,.05)))=NaN;
th_stats_object.fullpath = '/home/gjang/tstat_FisherZ_itcortex_imageFeatures_fc7_threshold_q05.nii'; %use THIS one to generate thresholded parametric maps
write(th_stats_object,'overwrite');
