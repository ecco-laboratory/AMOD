function [phat, null_dist] = permutation_test_multiway_clusters(pred_label,test_label)

nit=5000;

num_samples=length(pred_label);
num_scrambled=num_samples; %number of labels to 'corrupt'

for it=1:nit
    tl=randi(max(test_label),num_samples,1); %create ground truth labels
    pl=tl; %create perfect match predictions
    randvec=randperm(num_samples); %create a random ordering of predictions
    toscramble=pl(randvec(1:num_scrambled));
    pl(randvec(1:num_scrambled))=toscramble(randperm(length(toscramble))); %permute to get random values
    [~,sim_stats(it)]=cluster_confusion_matrix(pl,tl);
end


phat = 1-(sum(mean(pred_label==test_label)>[sim_stats(:).optimalAccuracy])/(nit+1));

null_dist = [sim_stats(:).optimalAccuracy];
end

