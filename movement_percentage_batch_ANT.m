close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\SK_Preprocessed\ANT');

%%
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);
% Process image files in those folders.

%% Output Excel Sheet
xlsfilename = 'E:\OPS\SK_Preprocessed\ANT\OPS_ANT_Outlier_Percentage.xlsx'; 
xlRange = 'A1';
stat_xlsx{1,1} = 'Subject_ID';    
stat_xlsx{1,2} = 'Date';        
stat_xlsx{1,3} = 'Total_Outlier_Percentage'; 
stat_xlsx{1,4} = 'TrialCongruent_Outlier_Percentage'; 
stat_xlsx{1,5} = 'TrialIncongruent_Outlier_Percentage'; 
stat_xlsx{1,6} = 'TrialNo_cue_Outlier_Percentage'; 
stat_xlsx{1,7} = 'TrialCentre_cue_Outlier_Percentage'; 
stat_xlsx{1,8} = 'TrialSpatial_cue_Outlier_Percentage'; 
stat_xlsx{1,9} = 'TargetCongruent_Outlier_Percentage'; 
stat_xlsx{1,10} = 'TargetIncongruent_Outlier_Percentage'; 
stat_xlsx{1,11} = 'TargetNo_cue_Outlier_Percentage'; 
stat_xlsx{1,12} = 'TargetCentre_cue_Outlier_Percentage'; 
stat_xlsx{1,13} = 'TargetSpatial_cue_Outlier_Percentage'; 

ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;



for k = 2 : numberOfFolders 
    % Replace this for loop with parfor if using parellel computing tool box - Not installed in cluster Matlab
    % Windows matlab - not connected cluster - Should try once Ram gives Samba access
    % To submit these jobs to cluster - repeat the code outide the loop to in bash script. PBS/torque scheduler
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	cd (thisFolder);

    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    
    %%
    if (strcmp(Current_Folder_name,'ANT')) 
        
        addpath C:\Users\ramakrs\Documents\spm12
        
%% check for folders without art performed
%         art_regression_outliers_and_movement_file = spm_select('List',pwd,'^art_regression_outliers_and_movement'); % OPS and Keely's study - folder names has tags to functional file  
%         if strcmp (art_regression_outliers_and_movement_file,'')
%             fprintf('%s\n', pwd);
%         end
%% OLD
%         load(art_regression_outliers_and_movement_file)
%         load('outliers.mat')
%         [p q] = size(R);
%         len = length(out_idx);
%         movement = (len/p) *100;
%%        
        [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
        [upper_to_upper2Path, Upper2_Folder_name, ~] = fileparts(upper_to_upperPath);

        cd glm
        DD = dir([pwd, '\*SPM_outliers.txt']);% Checking if the folder has any .nii files
        Num_of_files = length(DD(not([DD.isdir])));
        outliers_file = spm_select('List',pwd,'^SPM_outliers');
        if (Num_of_files  ~= 0)
            vals = textread('SPM_outliers.txt','%s'); 
            Total_mov             = vals(27);
            TrialCongruent_mov    = vals(28);
            TrialIncongruent_mov  = vals(29);
            TrialNo_cue_mov       = vals(30);
            TrialCentre_cue_mov   = vals(31);
            TrialSpatial_cue_mov  = vals(32);
            TargetCongruent_mov   = vals(33);
            TargetIncongruent_mov = vals(34);
            TargetNo_cue_mov      = vals(35);
            TargetCentre_cue_mov  = vals(36);
            TargetSpatial_cue_mov = vals(37);
            
            stat_xlsx{ind,1} = Upper2_Folder_name; %Subject ID
            stat_xlsx{ind,2} = Upper_Folder_name;  %Date
            stat_xlsx{ind,3} = cell2mat(Total_mov);
            stat_xlsx{ind,4} = cell2mat(TrialCongruent_mov );
            stat_xlsx{ind,5} = cell2mat(TrialIncongruent_mov );
            stat_xlsx{ind,6} = cell2mat(TrialNo_cue_mov );
            stat_xlsx{ind,7} = cell2mat(TrialCentre_cue_mov);
            stat_xlsx{ind,8} = cell2mat(TrialSpatial_cue_mov);
            stat_xlsx{ind,9} = cell2mat(TargetCongruent_mov );
            stat_xlsx{ind,10} = cell2mat(TargetIncongruent_mov );
            stat_xlsx{ind,11} = cell2mat(TargetNo_cue_mov );
            stat_xlsx{ind,12} = cell2mat(TargetCentre_cue_mov);
            stat_xlsx{ind,13} = cell2mat(TargetSpatial_cue_mov);
        
            ind = ind+1;
        end
%         
        cd ..
    end
end
xlswrite(xlsfilename,stat_xlsx,'ANT',xlRange);