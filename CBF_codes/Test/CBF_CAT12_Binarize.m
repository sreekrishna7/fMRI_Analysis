close all; clear all; clc;
format longg;
format compact;
%% Binarizes Segmented White matter and Gray Matter Masks (in mri folder) obtained from CAT12 
%% creates Marsbar ROIs from the binarized GM and WM images 
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
    if (strcmp(Current_Folder_name,'mri')) % Condition to Process only folders with relevant files  - Can be changed

            
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
            st = st(1,11:end);
            st_name = st_name(1,11:end);  
            clear matlabbatch;        
             b_ind = 1;
            % % Segment
            % %--------------------------------------------------------------------------
            matlabbatch{b_ind}.spm.util.imcalc.input = cellstr(['mwp1' st_name]);
            matlabbatch{b_ind}.spm.util.imcalc.output = ['GM_binary_' st_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1>0.6';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;

            matlabbatch{b_ind}.spm.util.imcalc.input = cellstr(['mwp2' st_name]);
            matlabbatch{b_ind}.spm.util.imcalc.output = ['WM_binary_' st_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1>0.6';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;
            
            spm_jobman('run',matlabbatch);
%% Creating marsbar ROI from binarized GM and WM masks
            marsbar('on');
            roi_path = currentDirectory;
            gm_roi_img  = ['GM_binary_' st_name];
            gm_vol = spm_vol(gm_roi_img);
            gm_nom = gm_roi_img(1:end-4);
            gm_o = maroi_image(struct('vol', gm_vol, 'binarize',1,...
                         'descrip', gm_nom, ...
                         'label', gm_nom));
            saveroi(maroi_matrix(gm_o), fullfile(roi_path,[gm_nom '_roi.mat']));
            
            wm_roi_img  = ['WM_binary_' st_name];
            wm_vol = spm_vol(wm_roi_img);
            wm_nom = wm_roi_img(1:end-4);
            wm_o = maroi_image(struct('vol', wm_vol , 'binarize',1,...
                         'descrip', wm_nom , ...
                         'label', wm_nom ));
            saveroi(maroi_matrix(wm_o), fullfile(roi_path,[wm_nom  '_roi.mat']));

        
    end
    
end