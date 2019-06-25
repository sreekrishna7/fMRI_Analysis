close all; clear all; clc;
format longg;
format compact;
%% Inputs
%% 

start_path = fullfile('GroupA');

%% Folder location to move the contrast files for second level analysis
ROI = 'MedialFrontalGyrus_L_roi'; % Folder with this name should be present
% ROI = 'MiddleFrontalGyrus_L_roi';
% ROI =  'PrecentralGyrus_L_roi';
% ROI =  'PrecentralGyrus_R_roi';
% ROI =  'Precuneus_L1_roi';
% ROI =  'Precuneus_L2_roi';
% ROI =  'Precuneus_R_roi';
% ROI =  'prePMD_L_roi';
% ROI =  'prePMD_R_roi';
% ROI =  'SuperiorParietalLobule_roi';
To_Folder_location1  = ['C:\Users\ramakrs\Documents\spm8\toolbox\BASCO\Neurodyne_data_FC\SecondLevel_Neurodyn_FC\GroupA\' ROI];

idx = 1;%index to contrast file 
From_Folder_name = 'betaseries'
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
% Anlayze image files in those folders.
for k = 2 : numberOfFolders 
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    if (strcmp(Current_Folder_name,From_Folder_name)) % Condition to Process only folders with relevant files  - Can be changed
              
       %% For moving Contrast files for 2nd Level analysis
            new_name_format1 = ['%dzfcmap_' ROI '_1.nii'];
            new_name1 = sprintf(new_name_format1,idx);
            copyfile(['zfcmap_' ROI '_1.nii'],[To_Folder_location1 '\' new_name1])

%             new_name_format2 = ['%dzfcmap_' ROI '_2.nii'];
%             new_name2 = sprintf(new_name_format2,idx);
%             copyfile(['zfcmap_' ROI '_2.nii'],[To_Folder_location1 '\' new_name2])
%                           
            idx = idx+1;    
        
    end
end