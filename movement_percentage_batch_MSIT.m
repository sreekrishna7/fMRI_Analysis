close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\SK_Preprocessed\MSIT');

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
xlsfilename = 'E:\OPS\SK_Preprocessed\MSIT\OPS_MSIT_Outlier_Percentage.xlsx'; 
xlRange = 'A1';
stat_xlsx{1,1} = 'Subject_ID';    
stat_xlsx{1,2} = 'Date';        
stat_xlsx{1,3} = 'Total_Outlier_Percentage'; 
stat_xlsx{1,4} = 'Congruent_Outlier_Percentage'; 
stat_xlsx{1,5} = 'Incongruent_Outlier_Percentage'; 


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
    if (strcmp(Current_Folder_name,'MSIT')) 
        
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
            Total_mov       = vals(7);
            Congruent_mov   = vals(8);
            Incongruent_mov = vals(9);

            
            stat_xlsx{ind,1} = Upper2_Folder_name; %Subject ID
            stat_xlsx{ind,2} = Upper_Folder_name;  %Date
            stat_xlsx{ind,3} = cell2mat(Total_mov);
            stat_xlsx{ind,4} = cell2mat(Congruent_mov );
            stat_xlsx{ind,5} = cell2mat(Incongruent_mov );

            ind = ind+1;
        end
%         
        cd ..
    end
end
xlswrite(xlsfilename,stat_xlsx,'MSIT',xlRange);