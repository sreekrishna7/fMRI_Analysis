close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\IMAGINGHEADSUP\IMAGINGHEADSUP_fMRI_data');
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
for k = 1 : numberOfFolders 
    % Replace this for loop with parfor if using parellel computing tool box - Not installed in cluster Matlab
    % Windows matlab - not connected cluster - Should try once Ram gives Samba access
    % To submit these jobs to cluster - repeat the code outide the loop to in bash script. PBS/torque scheduler
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    if (strcmp(Current_Folder_name,'Food_Preference') )
%     if (strcmp(Current_Folder_name,'1') || strcmp(Current_Folder_name,'2') || strcmp(Current_Folder_name,'3')) % Condition to Process only folders with relevant files  - Can be changed
        
        Respdata = spm_select('List',pwd,'^RESPData');
        a = load(Respdata);

        len1 = length(a);
        new_a = zeros(1,2*len1-1);
        new_a(1:2:end) = a;
        for i = 2:2:length(new_a)
            new_a(i) = (new_a(i-1)+new_a(i+1))/2;
        end
        new_a(2*len1) = new_a(end)+(new_a(len1-1) -new_a(len1-2));
        new_a = new_a';
        a =new_a;
        len1 = length(a);
        new_a = zeros(1,2*len1-1);
        new_a(1:2:end) = a;
        for i = 2:2:length(new_a)
            new_a(i) = (new_a(i-1)+new_a(i+1))/2;
        end
        new_a(2*len1) = new_a(end)+(new_a(len1-1) -new_a(len1-2));
        new_a = new_a';

        [m n] = size(new_a);
        save(Respdata,'new_a','-ascii');
        PPGdata = spm_select('List',pwd,'^PPGData');
        b = load(PPGdata);

    end
    
end