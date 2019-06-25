close all;
clear all;
clc
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('New_todo');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
%% Ask user to confirm or change.
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


addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  2 : numberOfFolders
    thisFolder = listOfFolderNames{k};
% 	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .eprime files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    if (strcmp(Current_Folder_name(1),'2')) 
        fprintf ([Current_Folder_name(1:8) '\n']);
%         mkdir(['E:\DEB_Pilot\' Current_Folder_name(10:20)])
    end
end                                                                                                                                     

