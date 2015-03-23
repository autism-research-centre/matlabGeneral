function [output] = rb_threshold(input, sds) 

% determine threshold to get out outliers
tstd = sds*nanstd(input); %how many standard deviations do you want to threshold
threshold_p = nanmean(input)+tstd;
threshold_m = nanmean(input)-tstd;

% apply threshold
output = input(input<threshold_p);
output = input(input>threshold_m);

end
