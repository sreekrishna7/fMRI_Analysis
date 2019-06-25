close all; clear ; clc;
format longg;
format compact;
%% Inputs
addpath C:\Users\ramakrs\Documents\spm12
Estimate_GLM  = 1; % Yes = 1; No = 0
GLM_foldername = 'glm'; 
listOfFolderNames = textread('E:\ENS\ENS_Analysis\2nd_Level\2nd_level_folder_paths.txt','%s'); 
numberOfFolders = length(listOfFolderNames);
% Analyze image files in those folders.
for k = 1:numberOfFolders
    % Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));

    if (Num_of_files~=0)
%         rmdir glm s;
        mkdir (GLM_foldername);
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');

        fprintf('Selecting all .nii files in %s\n', pwd);
        matlabbatch{1}.spm.stats.factorial_design.dir = {GLM_foldername};
        %%
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(spm_select('ExtList',pwd, '.nii$'));
        %%
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
        spm_jobman('run',matlabbatch);
        if (Estimate_GLM  == 1)
            cd (GLM_foldername);
            load('SPM');
            spm_spm(SPM);%estimates results
            clear SPM;
            clear matlabbatch;
            cd ..

        end

    end
end