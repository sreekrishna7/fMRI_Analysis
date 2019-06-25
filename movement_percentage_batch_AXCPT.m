close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\SK_Preprocessed\AXCPT');

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
xlsfilename = 'E:\OPS\SK_Preprocessed\AXCPT\OPS_AXCPT_Outlier_Percentage.xlsx'; 
xlRange = 'A1';
stat_xlsx{1,1} = 'Subject_ID';    
stat_xlsx{1,2} = 'Date';        
stat_xlsx{1,3} = 'Total_Outlier_Percentage'; 
stat_xlsx{1,4} = 'CueA_Outlier_Percentage'; 
stat_xlsx{1,5} = 'CueB_Outlier_Percentage'; 
stat_xlsx{1,6} = 'ProbeA_cue_Outlier_Percentage'; 
stat_xlsx{1,7} = 'ProbeB_Outlier_Percentage'; 
stat_xlsx{1,8} = 'TrialA_Outlier_Percentage'; 
stat_xlsx{1,9} = 'TrialB_Outlier_Percentage'; 


ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;



for k = 431 : numberOfFolders 
    % Replace this for loop with parfor if using parellel computing tool box - Not installed in cluster Matlab
    % Windows matlab - not connected cluster - Should try once Ram gives Samba access
    % To submit these jobs to cluster - repeat the code outide the loop to in bash script. PBS/torque scheduler
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	cd (thisFolder);

    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    
    %%
    if (strcmp(Current_Folder_name,'AXCPT')) 
        
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
            Total_mov  = vals(17);
            CueA_mov   = vals(18);
            CueB_mov   = vals(19);
            ProbeA_mov = vals(20);
            ProbeB_mov = vals(21);
            TrialA_mov = vals(22);
            TrialB_mov = vals(23);
                       
            stat_xlsx{ind,1} = Upper2_Folder_name; %Subject ID
            stat_xlsx{ind,2} = Upper_Folder_name;  %Date
            stat_xlsx{ind,3} = cell2mat(Total_mov);
            stat_xlsx{ind,4} = cell2mat(CueA_mov);
            stat_xlsx{ind,5} = cell2mat(CueB_mov);
            stat_xlsx{ind,6} = cell2mat(ProbeA_mov);
            stat_xlsx{ind,7} = cell2mat(ProbeB_mov);
            stat_xlsx{ind,8} = cell2mat(TrialA_mov);
            stat_xlsx{ind,9} = cell2mat(TrialB_mov);
          
            ind = ind+1;
        end
%         
        cd ..
    end
end
xlswrite(xlsfilename,stat_xlsx,'AXCPT',xlRange);