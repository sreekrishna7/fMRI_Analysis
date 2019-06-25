close all;
clear all;
clc
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\SK_Preprocessed\Gambling');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
Out_filename = 'E:\OPS\SK_Preprocessed\Gambling\Gambling_Number_of_volumes.xlsx'; %Output  Filename
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
d(1,:) = {'Participant_ID','Date','Run_1_Num_Vols','Run_2_Num_Vols'};
ind = 1;
for k =  2 : numberOfFolders
    thisFolder = listOfFolderNames{k};
% 	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .eprime files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    [doubleupper_to_upperPath, Upper_to_upper_Folder_name, ~] = fileparts(upper_to_upperPath);
    if (strcmp(Current_Folder_name,'Gambling')) 
        cd Run_1;
        fn_file_info = spm_select('List',pwd,['Run_1_info' '.txt$']);
        fid = fopen(fn_file_info,'r');
        C = textscan(fid, '%s','Delimiter','');
        fclose(fid);
        C = C{:};
        position_of_str = ~cellfun(@isempty, strfind(C,'Number of volumes:'));
        Number_of_volumes_line = [C{find(position_of_str)}];
        Number_of_volumes1 =  str2double(Number_of_volumes_line(20:22)) 
        cd ..
        cd Run_2;
        fn_file_info = spm_select('List',pwd,['Run_2_info' '.txt$']);
        fid = fopen(fn_file_info,'r');
        C = textscan(fid, '%s','Delimiter','');
        fclose(fid);
        C = C{:};
        position_of_str = ~cellfun(@isempty, strfind(C,'Number of volumes:'));
        Number_of_volumes_line = [C{find(position_of_str)}];
        Number_of_volumes2 =  str2double(Number_of_volumes_line(20:22)) 
        cd ..
        
        d(ind+1,:) = {Upper_to_upper_Folder_name,Upper_Folder_name,Number_of_volumes1,Number_of_volumes2};
        ind = ind+1;
    end
end                                                                                                                                     
xlswrite(Out_filename,d,sheet_name,xlRange);
