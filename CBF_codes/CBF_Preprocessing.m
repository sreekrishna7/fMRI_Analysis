%% Segments the T1, Coregisters segmented gray matter probability map and CBF, binarizes segementaion outputs(GM,WM and CSF) and masks the CBF
close all; clear all; clc;
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('E:\BHS_Brain\BHS_Brain_DATA');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
addpath C:\Users\ramakrs\Documents\spm12 
final_op_location = 'E:\BHS_Brain\Normalized_CBF\';
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
    if (strcmp(Current_Folder_name,'ASL_Backup') && Num_of_files ~= 0) % Condition to Process only folders with relevant files  - Can be changed
          
        fn_file = spm_select('List',pwd,['Cerebral_Blood_Flow.nii$']); % Selecting appropriate Funtional data: FOr OPS and Keely's study - folder names has tags to functional file  
        if isempty(fn_file)
            addpath C:\Users\ramakrs\Documents\spm12\toolbox\NIfTI_20140122;
            ASL_file1    = spm_select('ExtList',pwd, 'ASL.nii',1); 
            ASL_file2    = spm_select('ExtList',pwd, 'ASL.nii',2);
          
            ASL_hdr1     = spm_vol(ASL_file1);
            ASL_hdr2     = spm_vol(ASL_file2);
            
            ASL1         = spm_read_vols(ASL_hdr1);
            ASL2         = spm_read_vols(ASL_hdr2);
            
            PW       = ASL2;  %Perfusion Weighted Image
            T1_b     = 1.6;  %T1 of Blood
            T1_t     = 1.2;  %T1 of Gray Matter
            epsilon  = 0.6;  %Inversion efficiency x Background Supression Efficiency 
            lamda    = 0.9;  %Cortex–blood partition coefficient
            LT       = 1.5;  %Labeling Duration
            S_T      = 2;    %Time of saturation performed before imaging
            PLD      = 2.025;%Postlabeling Delay 
            NEX      = 3;    % Number of Excitations of PW image
            SF       = 32;   %Scaling factor;
            PD       = ASL1; %Referance Image

            CBF_est       = (6000*lamda)*(((1-exp(-2/T1_t))*exp(PLD/T1_b))/(2*T1_b*(1-exp(-LT/T1_b))*epsilon*NEX))*(PW./(SF*PD)); %Estimated CBF
            CBF_est = round(CBF_est);
            CBF_est(isnan(CBF_est)) = 0;
            CBF_est(CBF_est>120) = 0;  
            CBF_est_structure  = make_nii(CBF_est);
            save_nii(CBF_est_structure,[ASL_file1(1:29) '_Estimated_Cerebral_Blood_Flow.nii']);
            fn_file = spm_select('List',pwd,['Cerebral_Blood_Flow.nii$']);
        end
        fn_file = fn_file(1,:);
        [pathstr,fn_file_name,ext] = fileparts(fn_file);
        if ~isempty(fn_file)
            
%             spm fmri
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
            matlabbatch{b_ind}.spm.spatial.preproc.channel.vols = cellstr(st_name);
            matlabbatch{b_ind}.spm.spatial.preproc.channel.biasreg = 0.001;
            matlabbatch{b_ind}.spm.spatial.preproc.channel.biasfwhm = 60;
            matlabbatch{b_ind}.spm.spatial.preproc.channel.write = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,1'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(1).ngaus = 1;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(1).native = [1 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(1).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,2'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(2).ngaus = 1;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(2).native = [1 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(2).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,3'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(3).ngaus = 2;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(3).native = [1 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(3).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,4'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(4).ngaus = 3;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(4).native = [1 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(4).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,5'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(5).ngaus = 4;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(5).native = [1 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(5).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii,6'};
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(6).ngaus = 2;
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(6).native = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.tissue(6).warped = [0 0];
            matlabbatch{b_ind}.spm.spatial.preproc.warp.mrf = 1;
            matlabbatch{b_ind}.spm.spatial.preproc.warp.cleanup = 1;
            matlabbatch{b_ind}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
            matlabbatch{b_ind}.spm.spatial.preproc.warp.affreg = 'mni';
            matlabbatch{b_ind}.spm.spatial.preproc.warp.fwhm = 0;
            matlabbatch{b_ind}.spm.spatial.preproc.warp.samp = 3;
            matlabbatch{b_ind}.spm.spatial.preproc.warp.write = [1 1];

            b_ind = b_ind+1;
            % % Coregister (Moving gray matter to  CBF space) .. ALSO White
            % Matter and T1
            % %--------------------------------------------------------------------------

            matlabbatch{b_ind}.spm.spatial.coreg.estimate.ref = cellstr([fn_file_name '.nii']);
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.source = cellstr(['c1' st_name]);
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.other = [cellstr(st_name);cellstr(['c2' st_name])];
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
            matlabbatch{b_ind}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
            b_ind = b_ind+1;
            %%   Normalizing to MNI Space
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.subj.vol = cellstr(st_name);
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.subj.resample = [cellstr([fn_file_name '.nii']); cellstr(['c1' st_name]); cellstr(['c2' st_name])];
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\Users\ramakrs\Documents\spm12\tpm\TPM.nii'};
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                         78 76 85];
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
            matlabbatch{b_ind}.spm.spatial.normalise.estwrite.woptions.interp = 4;
            b_ind = b_ind+1;

            % % Binarising Normalized Masks (Segmented Maps are thresholded)
            % %--------------------------------------------------------------------------
            matlabbatch{b_ind}.spm.util.imcalc.input = cellstr(['wc1' st_name]);
            matlabbatch{b_ind}.spm.util.imcalc.output = ['GrayMatter_binary_' st_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1>0.75';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;

            matlabbatch{b_ind}.spm.util.imcalc.input = cellstr(['wc2' st_name]);
            matlabbatch{b_ind}.spm.util.imcalc.output = ['WhiteMatter_binary_' st_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1>0.75';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;
                        
%             % % Masking the CBF map
%             % %--------------------------------------------------------------------------  
            matlabbatch{b_ind}.spm.util.imcalc.input = [cellstr(['w' f]);cellstr(['GrayMatter_binary_' st_name])];
            matlabbatch{b_ind}.spm.util.imcalc.output = ['GrayMatter_CBF_' fn_file_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1.*i2';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;
            
            matlabbatch{b_ind}.spm.util.imcalc.input = [cellstr(['w' f]);cellstr(['WhiteMatter_binary_' st_name])];
            matlabbatch{b_ind}.spm.util.imcalc.output = ['WhiteMatter_CBF_' fn_file_name];
            matlabbatch{b_ind}.spm.util.imcalc.outdir = {''};
            matlabbatch{b_ind}.spm.util.imcalc.expression = 'i1.*i2';
            matlabbatch{b_ind}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{b_ind}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.mask = 0;
            matlabbatch{b_ind}.spm.util.imcalc.options.interp = 1;
            matlabbatch{b_ind}.spm.util.imcalc.options.dtype = 4;
            b_ind = b_ind+1;
            
                    
            spm_jobman('run',matlabbatch);
            
            GM_CBF_to_copy = spm_select('List',pwd,'^GrayMatter_CBF_.*\.nii$');
            WM_CBF_to_copy = spm_select('List',pwd,'^WhiteMatter_CBF_.*\.nii$');
            copyfile(GM_CBF_to_copy,final_op_location);
            copyfile(WM_CBF_to_copy,final_op_location);
              
%             wCBF_to_copy = ['w' f]; 
%             copyfile(wCBF_to_copy,final_op_location);  
            
           
        end
        
        
    end
    
end