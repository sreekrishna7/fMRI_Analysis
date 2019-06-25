close all; clear; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\ENS\ENS_fMRI_Data\To_Do');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
% Each participant folder must contain structural scan, functional scan,
% and corresponding info.txt files
Num_DV_1  = 4; % Dicard first Num_DV volumes to Preprocess
High_number = 700;% To Process from [5: inf] number of volumes
Num_DV = Num_DV_1+1;
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
    if (Num_of_files ~=0) % Condition to Process only folders with relevant files  - Can be changed
          
        fn_file = spm_select('List',pwd,[Current_Folder_name '.nii$']); % Selecting appropriate Funtional data: FOr OPS and Keely's study - folder names has tags to functional file  
        [pathstr,fn_file_name,ext] = fileparts(fn_file);
        %%
        VI = spm_vol(fn_file);
        n_slices = VI(1,1).dim(3); % Reading Number of slices
        
        %%
        sliceOrder = [n_slices:-1:1];
        refSlice = n_slices;
        %% To Read TR from the info file - should be added in header (From Ram)

        fn_file_info = spm_select('List',pwd,[Current_Folder_name '_info' '.txt$']);

        fid = fopen(fn_file_info,'r');
        C = textscan(fid, '%s','Delimiter','');
        fclose(fid);
        C = C{:};

        position_of_str = ~cellfun(@isempty, strfind(C,'Repetition time (ms):'));
        Repetition_time_line = [C{find(position_of_str)}];
        TR =  str2double(Repetition_time_line(23)) %TR in seconds
           
        %%
        TA = TR - (TR/n_slices);
        time1 = TA/n_slices;
        time2 = TR - TA;
        timing(1) = time1;
        timing(2) = time2;
        spm_slice_timing(fn_file, sliceOrder, refSlice, timing);

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

        f = spm_select('ExtList',pwd, '^a',Num_DV:High_number);
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
                
        clear matlabbatch

        % Realign
        % --------------------------------------------------------------------------
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(f)};
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
        
        % % Coregister
        % %--------------------------------------------------------------------------
        matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr(['mean' 'a' fn_file_name '.nii']);
        matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(st);

        % % Segment
        % %--------------------------------------------------------------------------
        matlabbatch{3}.spm.spatial.preproc.channel.vols  = cellstr(st);
        matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
        matlabbatch{3}.spm.spatial.preproc.warp.write    = [0 1];

        % % Normalise: Write
        % %--------------------------------------------------------------------------
        matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(['y_' st_name]);
        matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(f);
        matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];

        matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(['y_' st_name]);
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(['m' st_name]);
        matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

        % % Smooth
        % %--------------------------------------------------------------------------
        matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(f,'prefix','w'));
        matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];

        spm_jobman('run',matlabbatch);
    end
    clearvars variables -except k  High_number listOfFolderNames Num_DV Num_DV_1 numberOfFolders remain singleSubFolder start_path topLevelFolder

end