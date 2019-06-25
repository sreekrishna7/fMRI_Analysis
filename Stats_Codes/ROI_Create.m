%% Input 
clear;
addpath C:\Users\ramakrs\Documents\spm8\toolbox\marsbar-0.44\
addpath C:\Users\ramakrs\Documents\spm12\
sheet           = 'Retaliation_Watching';
[num, txt, raw] = xlsread('Retaliation_ROIs.xlsx',sheet);
%%
% RUN UNTIL HERE and See variables 'num' and 'txt' to set the following parameters
%%
Name_start      = 3; %Row number at which Name starts  -check variable 'txt'
Name_col        = 1; %Colomn number with Names         -check variable 'txt'
Region_Names    = txt(Name_start:end,Name_col);
Coord_cols      = 1:3 ; %colomn numbers for cordinates  -check variable 'num'
Centers         = round(num(1:end,Coord_cols)); 
radius          = 3;
%%
marsbar('on');
rois = {};
for roi_no = 1:size(Centers, 1)
    %Refer maroi.m for params
    description = sprintf('%d mm radius sphere', radius);
    params      = struct('centre', Centers(roi_no, :), 'radius', radius, 'label', Region_Names(roi_no), 'descrip', description);
    roi         = maroi_sphere(params);
    saveroi(roi, sprintf('%s_roi.mat', cell2mat(Region_Names(roi_no))));
    rois{end+1} = roi;
end
