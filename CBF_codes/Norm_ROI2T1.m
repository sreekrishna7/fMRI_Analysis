%% Use iy_ to move ROIs to the T1 space

close all; clear all; clc;
format longg;
format compact;
ROI_folder = 'C:\Users\ramakrs\Documents\Task_ROIs\AAL\marsbar_aal_0_2';
ROIout_folder = 'AAL_ROIs_T1_space';
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\BHS_Brain\BHS_Brain_DATA');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
addpath C:\Users\ramakrs\Documents\spm12 
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
for k = 1: numberOfFolders 
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
    if (strcmp(Current_Folder_name,'ASL') && Num_of_files ~= 0) % Condition to Process only folders with relevant files  - Can be changed
          
            %--------------------------------------------------------------------------
            data_path = fileparts(mfilename(pwd));
            if isempty(data_path), data_path = pwd; end
            fprintf('%-40s:', 'Downloading rest dataset...');
            fprintf(' %30s\n', '...done');

            % Initialise SPM
            %--------------------------------------------------------------------------
            spm('Defaults','fMRI');
            spm_jobman('initcfg');
            inv_transformation_file = spm_select('List',pwd,'^iy_.*\.nii$');
            matlabbatch{1}.spm.spatial.normalise.write.subj.def =cellstr(inv_transformation_file); 
            %%
            
            ROI_files_to_transform = spm_select('ExtFPList',ROI_folder,'^MNI.*\.nii$');
            matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(ROI_files_to_transform);
            %%
            matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -90 -70
                                                                      78 110 85];
            matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
            matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
            spm_jobman('run',matlabbatch);
            mkdir(ROIout_folder);
            movefile([ROI_folder '\w*'],[pwd '\' ROIout_folder])
            
    end
    
end


