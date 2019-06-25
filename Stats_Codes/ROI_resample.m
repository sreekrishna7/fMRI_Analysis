roi_filename = 'R_superior_parietal_lobe_roi.mat';
my_roi = maroi(roi_filename);
my_roi = spm_hold(my_roi, 0); % set NN resampling
saveroi(my_roi, roi_filename);