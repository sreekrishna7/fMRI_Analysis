  close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('GroupB');
Num_DV_1  = 4; % Dicard first Num_DV volumes to Preprocess
High_number = 550;
Num_DV = Num_DV_1+1;
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
for k = 2 : numberOfFolders 
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
%     if (strcmp(Current_Folder_name,'run1')||strcmp(Current_Folder_name,'run2')) % Condition to Process only folders with relvant files
    if (strcmp(Current_Folder_name,'Resting_State')) % Condition to Process only folders with relvant files        
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.cat.vols = cellstr(spm_select('ExtList',pwd, '^sw',Num_DV:High_number));
        %%
        matlabbatch{1}.spm.util.cat.name = '4D.nii';
        matlabbatch{1}.spm.util.cat.dtype = 4;

        spm_jobman('run',matlabbatch);
    end
end