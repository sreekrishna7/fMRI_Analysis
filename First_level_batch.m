close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Instructions: Input the TR correctly, Delete Existing glm folder(those folders will have .nii which is the search condition for excecuting the main loop)
% Define a starting folder.

start_path = fullfile('MR_MAIN_DATA');
%% Folder location to move the contrast files for second level analysis
Cont_Folder  = 'E:\MR_MAIN\MR_MAIN_for_2ndLevel';
% con_idx = 1;%index to contrast file 
%%
Num_DV_1 = 4 ; % Dicard first Num_DV volumes from Analysis
Estimate_GLM  = 1; % Yes = 1; No = 0
GLM_foldername = 'glm'; 
RunContrast_File = 'E:\MR_MAIN\RunContrast_MR_Main_inCon_Con.mat'; % mat file with contrast vector 
% MatConditions_File = 'E:\FMRI_DATA\keelyDataTest_SK\keely_sk2.mat';
%%
High_number = 800;
Num_DV = Num_DV_1+1;%Do not edit
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
% Analyze image files in those folders.
for k = 1 : numberOfFolders 
    % Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    if (strcmp(Current_Folder_name,'ANT') || strcmp(Current_Folder_name,'STROOP')) % Condition to Process only folders with relevant files  - Can be changed
        rmdir(GLM_foldername,'s');
        mkdir(GLM_foldername);
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.stats.fmri_spec.dir = {GLM_foldername};
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
                      
        fn_file_info = spm_select('List',pwd,[Current_Folder_name '_info' '.txt$']);
        fid = fopen(fn_file_info,'r');
        C = textscan(fid, '%s','Delimiter','');
        fclose(fid);
        C = C{:};
        position_of_str = ~cellfun(@isempty, strfind(C,'Repetition time (ms):'));
        Repetition_time_line = [C{find(position_of_str)}];
        TR =  str2double(Repetition_time_line(23)); %TR in seconds
        
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR; %read from info.txt for ops
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
        %%
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(spm_select('ExtList',pwd, '^sw',Num_DV:High_number));
                                                     
        %%
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
       
        MatConditions_File = spm_select('List',pwd,[Current_Folder_name '.mat$']);
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi = cellstr(MatConditions_File(1,:));% USE the name and correct this like done in BHS Brain
        
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(spm_select('List',pwd, '^Physio_regressor'));
        matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh =-Inf;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {'C:\Users\ramakrs\Documents\spm12\toolbox\160122_RESTplus_V1.1\mask\BrainMask_05_53x63x46.img,1'};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

        spm_jobman('run',matlabbatch);
        if (Estimate_GLM  == 1)
            cd (GLM_foldername);
            load('SPM');
            spm_spm(SPM);
            clear SPM;
            clear matlabbatch;
            load(RunContrast_File);
            matlabbatch{1, 1}.spm.stats.con.spmmat{1, 1} = [pwd '\SPM.mat']; %Reads in the SPM.mat for the current scan
            spm_jobman('run',matlabbatch);
         %% For moving Contrast files for 2nd Level analysis
%             new_name_format = '%dcon_0001.nii';
%             new_name = sprintf(new_name_format,con_idx);
            new_name  =  [fn_file_info(1:34) Current_Folder_name '_con_0001.nii'];
            copyfile('con_0001.nii',[Cont_Folder '\' new_name]);
%             con_idx = con_idx+1;
         %%
            cd ..
             
        end
        clear matlabbatch;
        clear MatConditions_File TR fn_file_info new_name
        
    end
end