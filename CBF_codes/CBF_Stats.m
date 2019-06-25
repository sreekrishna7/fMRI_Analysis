close all;
clear all;
clc
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('BHS_Brain_Data');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
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
%% Output Excel Sheet
xlsfilename = 'E:\BHS_Brain\BHS_Brain_CBF_Values.xlsx'; 
xlRange = 'A1';
CBF_stat_xlsx{1,1} = 'Subject_ID';    
CBF_stat_xlsx{1,2} = 'Date';        
CBF_stat_xlsx{1,3} = 'GrayMatter_Average_CBF'; 
CBF_stat_xlsx{1,4} = 'WhiteMatter_Average_CBF'; 
CBF_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  2 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    if (Num_of_files ~=0) 
        clear GM_CBFfile WM_CBFfile;
        GM_CBFfile = spm_select('ExtList',pwd, 'GrayMatter_CBF.nii$');
        WM_CBFfile = spm_select('ExtList',pwd, 'WhiteMatter_CBF.nii$');
        if (~strcmp(GM_CBFfile,''))
            GM = spm_vol(GM_CBFfile);
            GM_vals = spm_read_vols(GM);
            WM = spm_vol(WM_CBFfile);
            WM_vals = spm_read_vols(WM);
            GM_mean = mean(nonzeros(GM_vals));
            WM_mean = mean(nonzeros(WM_vals));

%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
            CBF_stat_xlsx{CBF_ind,1} = Upper_Folder_name(10:20); %Subject ID
            CBF_stat_xlsx{CBF_ind,2} = Upper_Folder_name(1:8);%Date
%             CBF_stat_xlsx{CBF_ind,1} = Current_Folder_name; %Subject ID
%             CBF_stat_xlsx{CBF_ind,2} = PPGdata(1,21:28);    %Date
            CBF_stat_xlsx{CBF_ind,3} = GM_mean;
            CBF_stat_xlsx{CBF_ind,4} = WM_mean;
            CBF_ind = CBF_ind+1;
        end
    end
end
xlswrite(xlsfilename,CBF_stat_xlsx,'Average_CEREBRAL_BLOOD_FLOW',xlRange);
