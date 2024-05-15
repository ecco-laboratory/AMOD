
%% regression analyses
% t = readtable('IAPS_data_UPDATED_Zscores.csv');
t = readtable('OASIS_data_UPDATED_Zscores.csv');

for s = 1:20

    tsub = t(t.subject==s,:);

    lme_sub = fitlme(tsub,'amy_enc_pred ~ 1  + val_full_z + arous_full_z + val_full_z:arous_full_z + median_red_z + median_green_z + median_blue_z + high_freq_z + low_freq_z ');

    betas(s,:)=lme_sub.Coefficients.Estimate;

    %calculate predicted yhat values using only val, arous, and val:arous from full regression equation for each subject for each IAPS image (20 yhats per image)
    yhat(s,:)= [ones(height(tsub),1) tsub.val_full_z tsub.arous_full_z tsub.val_full_z.*tsub.arous_full_z]*lme_sub.Coefficients.Estimate([1:3 end]);    %predict(lme,tsub); %if including all predictor's' coefficiencts 

end

yhat = mean(yhat);

xnodes = -2.5:.2:2.5;
ynodes = -2:.2:2;

g = gridfit(double(tsub.val_full_z),double(tsub.arous_full_z),yhat,xnodes,ynodes, 'smoothness',1,'interp','triangle','regularizer','gradient');

figure;

hold on;

surf(-2.5:.2:2.5,-2:.2:2,g)

xlabel Valence
ylabel Arousal
zlabel 'Predicted Amygdala Response'

hold on;

scatter3(double(tsub.val_full_z),double(tsub.arous_full_z),double(yhat),100,'marker','.')

colorbar; grid on;


%% OLD lme
% lme = fitlme(t,'amy_enc_pred~val_full_z+arous_full_z+val_full_z:arous_full_z+median_red_z+median_green_z+median_blue_z+low_freq_z+high_freq_z+(1|subject)'); %full regression model
% lme = fitlme(t,'amy_enc_pred~val_full_z+arous_full_z+val_full_z:arous_full_z+(1|subject)'); %valence and arousal only regression model
 
%%
%t = readtable('subset_IAPS_data_predictY.csv')
%
%X = table2array(t(:,2:end)); % val_full = X(:,1), arous_full = X(:,2), median_red_z = X(:,3), median_green_z = X(:,4), median_blue_z = X(:,5), high_freq_z = X(:,6), low_freq_z = X(:,7), predictedY = X(:,8)
%
% val_full = X(:,1), arous_full = X(:,2), predictedY = X(:,8)
%xnodes = 1:.5:8.5;
%ynodes = 1:.5:8.5;
%g = gridfit(double(X(:,1)),double(X(:,2)),double(X(:,8)),xnodes,ynodes, 'smoothness',1);
%figure;
%subplot(1,2,1);hold on;
%surf(1:.5:8.5,1:.5:8.5,g)
%xlabel Valence
%ylabel Arousal
%zlabel 'Predicted Arousal'
%hold on;
%scatter3(double(X(:,1)),double(X(:,2)),double(X(:,8)),100,C(IAPS_pred_label,:),'marker','.')
%colormap bone;grid on
%caxis([4 5.5]);view([-65 10])
%set(gca,'ZLim',[2.5 6.5]);


