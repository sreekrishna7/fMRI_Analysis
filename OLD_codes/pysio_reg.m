clear all;
clc;
load('art_regression_outliers_and_movement_swaA00-06-5652_PEM_20170413_1684_004_TRANSFER_LEARNING_fMRI_Transfer_Learning.mat')

a = load('multiple_regressors.txt');
a = a(5:end,:);
R = [R a];

save('Physio_regressor.mat','R');