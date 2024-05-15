addpath(genpath('/home/gjang/RainCloudPlots')) %'C:\Users\phili\OneDrive - Emory University\Documents\temp\D\WorkData\video_frames'
addpath(genpath('Github'))

load('/home/gjang/amygdala_subregions_atanh.mat')

figure;

cb = hsv(4);

for r=1:4;
hold on;
h1 = raincloud_plot(avg_atanh_subregion(:,r), 'box_on', 1, 'color', cb(r,:), 'alpha', 0.5,... 
     'box_dodge', 1, 'box_dodge_amount', .25*r, 'dot_dodge_amount', .25*r,...
     'box_col_match', 0);
 set(gca,'XLim', [-.05 .25],'YLim',[-35 25]);

end

box off


barplot_columns(avg_atanh_subregion)
set(gca,'XTickLabels',{'CM' 'SF' 'AStr' 'LB'})
xlabel 'Amygdala Subregions'
ylabel 'Fisher''s Z'



%%
% figure;
% cm = 1;
% 
% for m = [1, 6, 11, 16, 21] 
%     
%     subplot(1,5,cm)
%     d{1} = pred_activation(:,m); d{2} = pred_activation(:,m+1); d{3} = pred_activation(:,m+2); d{4} = pred_activation(:,m+3); d{5} = pred_activation(:,m+4);
% 
%     h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', [.8 .2 .2], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', .2, 'dot_dodge_amount', .35,...
%         'box_col_match', 1);
%     h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', [.2 .2 .2], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', .55, 'dot_dodge_amount', .7,...
%         'box_col_match', 1);
%     h3 = raincloud_plot(d{3}, 'box_on', 1, 'color', [.2 .2 .8], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', .9, 'dot_dodge_amount', 1.05,...
%         'box_col_match', 1);
%     h4 = raincloud_plot(d{4}, 'box_on', 1, 'color', [.2 .8 .2], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', 1.25, 'dot_dodge_amount', 1.4,...
%         'box_col_match', 1);
%     h5 = raincloud_plot(d{5}, 'box_on', 1, 'color', [.8 0 .8], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', 1.6, 'dot_dodge_amount', 1.75,...
%         'box_col_match', 1);
%         
%     legend([h1{1} h2{1} h3{1} h4{1} h5{1}], {'Amygdala Activation', 'Astr Activation', 'CM Activation', 'LB Activation', 'SF Activation'});
%     box off
%     xlabel(['Predicted Activation'])
%     title(['Optimize ' titles{cm} ' Activity'])
%     % save
%     view([90 -90]);
%     axis ij
%     axis tight
% %     set(gca,'yLim',[-2, 5])
%     set(gca,'xLim',[-2, 5], 'FontSize',12)
%     cm = cm+1;
% 
% end



%%
% figure; 
% subplot(1,3,1);
% montage(imageDatastore([pwd filesep '*sub*amygdala.png']))
% subplot(1,3,2);
% montage(imageDatastore([pwd filesep '*sub*visualcortex.png']))
% subplot(1,3,3);
% montage(imageDatastore([pwd filesep '*sub*itcortex.png']))
