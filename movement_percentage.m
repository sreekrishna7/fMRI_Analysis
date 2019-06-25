 clear all;
clc;
art_regression_outliers_and_movement_file = spm_select('List',pwd,'^art_regression_outliers_and_movement'); % OPS and Keely's study - folder names has tags to functional file  
load(art_regression_outliers_and_movement_file);
load('outliers.mat')
[p q] = size(R);
len = length(out_idx);
movement = (len/p) *100
save('movement.txt','movement','-ASCII','-DOUBLE','-TABS');
