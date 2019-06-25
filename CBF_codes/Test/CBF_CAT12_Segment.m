close all; clear all; clc;
format longg;
format compact;
%% Takes in Structural image(T1) and segments it in to WM and GM and normalizes it in to MNI space

%% Inputs
% Define a starting folder.
start_path = fullfile('E:\OPS\BHS_Brain_Data');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
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
for k =1: numberOfFolders 
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
    if (strcmp(Current_Folder_name,'ASL')) % Condition to Process only folders with relevant files  - Can be changed
          
        fn_file = spm_select('List',pwd,['Cerebral_Blood_Flow.nii$']); % Selecting appropriate Funtional data: FOr OPS and Keely's study - folder names has tags to functional file  
       
        [pathstr,fn_file_name,ext] = fileparts(fn_file(1,:));
        if ~isempty(fn_file)
            
            spm fmri
            %--------------------------------------------------------------------------
            data_path = fileparts(mfilename(pwd));
            if isempty(data_path), data_path = pwd; end
            fprintf('%-40s:', 'Downloading rest dataset...');
            fprintf(' %30s\n', '...done');

            % Initialise SPM
            %--------------------------------------------------------------------------
            spm('Defaults','fMRI');
            spm_jobman('initcfg');
            % spm_get_defaults('cmdline',true);


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % SPATIAL PREPROCESSING
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            f = fn_file;
            st = spm_select('ExtList',pwd, 'FSPGR_BRAVO.nii$',1);
            st_name = spm_select('List',pwd,'FSPGR_BRAVO.nii$');
            if (strcmp(st,''))
                st = spm_select('ExtList',pwd, 'SAG_MPRAGE.nii$',1);
                st_name = spm_select('List',pwd,'SAG_MPRAGE.nii$');
            end
            if (strcmp(st,''))
                st = spm_select('ExtList',pwd, 'SAG_STRUCTURAL.nii$',1);
                st_name = spm_select('List',pwd,'SAG_STRUCTURAL.nii$');
            end
            st = st(1,:);
            st_name = st_name(1,:);  
            clear matlabbatch;        
             b_ind = 1;
            % % Segment
            % %--------------------------------------------------------------------------
           
            matlabbatch{b_ind}.spm.tools.cat.estwrite.data =  cellstr(st);
            matlabbatch{b_ind}.spm.tools.cat.estwrite.nproc = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.opts.tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii'};
            matlabbatch{b_ind}.spm.tools.cat.estwrite.opts.affreg = 'mni';
            matlabbatch{b_ind}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.APP = 1070;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.gcutstr = 0.5;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.cleanupstr = 0.5;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.registration.darteltpm = {'C:\Users\ramakrs\Documents\spm12\toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii'};
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.registration.shootingtpm = {'C:\Users\ramakrs\Documents\spm12\toolbox\cat12\templates_1.50mm\Template_0_IXI555_MNI152_GS.nii'};
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.registration.regstr = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.extopts.vox = 1.5;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.surface = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.ROI = 1;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.GM.native = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.GM.mod = 1;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.GM.dartel = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.WM.native = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.WM.mod = 1;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.WM.dartel = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.bias.warped = 1;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.jacobian.warped = 0;
            matlabbatch{b_ind}.spm.tools.cat.estwrite.output.warps = [0 0];

            
            spm_jobman('run',matlabbatch);
        end
        
        
    end
    
end