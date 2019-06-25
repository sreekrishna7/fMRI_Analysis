%% Author: Sreekrishna Ramakrishna Pillai
clear;
addpath C:\Users\ramakrs\Documents\spm12;
%%
ROIout_folder = 'AAL_ROIs_T1_space';
% ROIout_folder = 'Braodmann_ROIs_T1_space';
Char_Participant_name = 1:11; % Characters in file name with Participant ID
Char_Date = 17:24;            % Characters in file name with Date
filename = 'stats_CBF_AAL_ROIs_OnlyGM.xlsx'; %Output  Filename
% filename = 'stats_CBF_Brodmann_ROIs_OnlyGM.xlsx'; %Output  Filename
xlRange = 'A1';
%% 
% Define a starting folder.
start_path = fullfile('E:\BHS_Brain\BHS_Brain_DATA');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
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

for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    sub_ind = 1;
    if (strcmp(Current_Folder_name,'ASL') && Num_of_files ~= 0)
        cd (ROIout_folder) ;
        ROI_files_Full_path = spm_select('ExtFPList',pwd,'^wMNI.*\.nii$');
        ROI_file_names = spm_select('List',pwd,'^wMNI.*\.nii$');
        cd ..
        [num_roi, xx]= size(ROI_file_names);
        GM_CBFfile = spm_select('List',pwd, '^GrayMatter_CBF.*\.nii$');
            
        for i = 1:num_roi
            Stats_xlsx{1,i} =  ROI_file_names(i,:);
            spm('Defaults','fMRI');
            spm_jobman('initcfg');
            matlabbatch{1}.spm.util.imcalc.input = [cellstr(GM_CBFfile);cellstr(ROI_files_Full_path(i,:))];
            matlabbatch{1}.spm.util.imcalc.output = 'Temp_out';
            matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
            matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
            matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{1}.spm.util.imcalc.options.mask = 0;
            matlabbatch{1}.spm.util.imcalc.options.interp = 1;
            matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
            spm_jobman('run',matlabbatch);
            GM = spm_vol('Temp_out.nii');
            GM_vals = spm_read_vols(GM);
            GM_mean = mean(nonzeros(GM_vals));
            Stats_xlsx{sub_ind+1,i}=GM_mean;
                    
        end
        sub_ind = sub_ind+1
    end
end
xlswrite(filename,Stats_xlsx,Current_Folder_name,xlRange);