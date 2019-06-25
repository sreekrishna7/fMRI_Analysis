close all;
clear all;
clc
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\SK_Preprocessed\Retaliation');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
Out_filename = 'E:\OPS\SK_Preprocessed\Retaliation\Task1_Folder_List.xlsx'; %Output  Filename
sheet_name = 'Folder_List';
xlRange = 'A1';

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
d(1,:) = {'Participant_ID','Date'};
ind = 1;
for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
% 	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .eprime files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    [doubleupper_to_upperPath, Upper_to_upper_Folder_name, ~] = fileparts(upper_to_upperPath);
    [tripleupper_to_upperPath, doubleUpper_to_upper_Folder_name, ~] = fileparts(doubleupper_to_upperPath);
    if (strcmp(Current_Folder_name,'Task_1')) 
        d(ind+1,:) = {doubleUpper_to_upper_Folder_name,Upper_to_upper_Folder_name};
        ind = ind+1;
    end
end                                                                                                                                     
xlswrite(Out_filename,d,sheet_name,xlRange);
