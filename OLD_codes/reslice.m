close all;
clear all;
clc;
%file = spm_select('List',pwd,'^functional.nii');
fileip = 'A00-06-6899_SSS_20160922_1195_004_OPS_D36_3)_fMRI_Gambling_(TR_2000)_Run_1';
file = [fileip '.nii'];
n_slices = 32;
sliceOrder = [n_slices:-1:1];
refSlice = n_slices;
TR = 2;
TA = TR - (TR/n_slices);
time1 = TA/n_slices;
time2 = TR - TA;
timing(1) = time1;
timing(2) = time2;
spm_slice_timing(file, sliceOrder, refSlice, timing);
%Renaming
%fileout = ['a' file];
%movefile(fileout, [fileip 'Resliced' '.nii']);