close all; clear; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.

start_path = fullfile('E:\ENS\Behavioural_Data\All_Data\');
%% Folder location to move the files

to_location = 'E:\ENS\Behavioural_Data\ENS_All_Conditions\';

%%
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
% Analyze image files in those folders.
for k = 1 : numberOfFolders 
    % Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*fMRIdata.mat']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [uppertoupperPath, upper_Folder_name, ~] = fileparts(upperPath);
    if (Num_of_files~=0) % Condition to Process only folders with relevant files  - Can be changed
            Participant_ID = upper_Folder_name(1:11);
            %%
%             Date = upper_Folder_name(12:19);
%%
            Backup_data = dir([thisFolder, '\*backup.mat']); %FOR ENS
            load (Backup_data.name);%FOR ENS
            Date = d1(1:11);%FOR ENS
%%
            new_name  =  [Participant_ID '_' Date '_'  DD.name];
            copyfile(DD.name,[to_location '\' new_name]);
    end
end