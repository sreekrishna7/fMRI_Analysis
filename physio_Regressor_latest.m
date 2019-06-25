addpath C:\Users\ramakrs\Documents\spm12
addpath C:\Users\ramakrs\Documents\PhysIO_r811\code

close all; clear; clc;
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
    if (strcmp(Current_Folder_name,'Food_Preference')) % Condition to Process only folders with relevant files  - Can be changed
        PPGData  = spm_select('List',pwd,'^PPGData');
        RESPData = spm_select('List',pwd,'^RESPData');
        currentDirectory = pwd;
        [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);

        fn_file = spm_select('List',pwd,[Current_Folder_name '.nii$']); % OPS and Keely's study - folder names has tags to functional file  

        VI = spm_vol(fn_file(1,:));
        n_slices = VI(1,1).dim(3); % Reading Number of slices

        [n_volumes,xx] = size(VI);

        physio = tapas_physio_new();
        physio.log_files.vendor = 'GE';
        physio.log_files.cardiac = {PPGData};
        physio.log_files.respiration = {RESPData};
        physio.log_files.sampling_interval = 0.025;
        physio.log_files.relative_start_acquisition = 0;
        physio.log_files.align_scan = 'last';
        physio.scan_timing.sqpar.Nslices = n_slices;
        physio.scan_timing.sqpar.NslicesPerBeat = n_slices;
        physio.scan_timing.sqpar.TR = 3;
        physio.scan_timing.sqpar.Ndummies = 10;
        physio.scan_timing.sqpar.Nscans = n_volumes;
        physio.scan_timing.sqpar.onset_slice = floor(n_slices/2);
        physio.scan_timing.sync.method = 'nominal';
        physio.preproc.cardiac.modality = 'PPU';
        physio.preproc.cardiac.initial_cpulse_select.method = 'auto_matched';
        physio.preproc.cardiac.initial_cpulse_select.file = 'initial_cpulse_kRpeakfile.mat';
        physio.preproc.cardiac.initial_cpulse_select.min = 0.4;
        physio.preproc.cardiac.posthoc_cpulse_select.method = 'off';
        physio.preproc.cardiac.posthoc_cpulse_select.percentile = 80;
        physio.preproc.cardiac.posthoc_cpulse_select.upper_thresh = 60;
        physio.preproc.cardiac.posthoc_cpulse_select.lower_thresh = 60;
        physio.model.orthogonalise = 'none';
        physio.model.output_multiple_regressors = 'multiple_regressors.txt';
        physio.model.output_physio = 'physio.mat';
        physio.model.retroicor.include = true;
        physio.model.retroicor.order.c = 3;
        physio.model.retroicor.order.r = 4;
        physio.model.retroicor.order.cr = 1;
        physio.model.rvt.include = false;
        physio.model.rvt.delays = 0;
        physio.model.hrv.include = false;
        physio.model.hrv.delays = 0;
        physio.model.noise_rois.include = false;
        physio.model.noise_rois.thresholds = 0.9;
        physio.model.noise_rois.n_voxel_crop = 0;
        physio.model.noise_rois.n_components = 1;
        physio.model.movement.include = false;
        physio.model.movement.order = 6;
        physio.model.movement.outlier_translation_mm = 1;
        physio.model.movement.outlier_rotation_deg = 1;
        physio.model.other.include = false;
        physio.verbose.level = 2;
        physio.verbose.process_log = cell(0, 1);
        physio.verbose.fig_handles = zeros(0, 1);
        physio.verbose.use_tabs = false;
        physio.ons_secs.c_scaling = 1;
        physio.ons_secs.r_scaling = 1;

        physio = tapas_physio_main_create_regressors(physio);

        art_regression_outliers_and_movement_file  = spm_select('List',pwd,'^art_regression_outliers_and_movement');
        load(art_regression_outliers_and_movement_file)
        a = load('multiple_regressors.txt');
        a = a(5:end,:);
        R = [R a];
        save('Physio_regressor.mat','R');
        clear R;
    end
end