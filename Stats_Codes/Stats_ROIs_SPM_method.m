%% Author: Sreekrishna Ramakrishna Pillai
clear;
addpath C:\Users\ramakrs\Documents\spm12;
Char_Participant_name = 1:11; % Characters in file name with Participant ID
Char_Date = 17:24;            % Characters in file name with Date
filename = 'E:\OPS\ANT_Analysis\ANT_2nd_Level\OPS_stats_ANT_ROIs.xlsx'; %Output  Filename
xlRange = 'A1';
ROI_folder = 'C:\Users\ramakrs\Documents\Task_ROIs\ANT\ANT_Alerting';
Sheet_Name = 'ANT_Alerting';
%% 
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFileNames = textread('E:\OPS\ANT_Analysis\ANT_2nd_Level\Cont_file_paths.txt','%s'); 
numberOfFiles = length(listOfFileNames);

for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
    currentDirectory = pwd;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    Participant_name = Current_File_name(Char_Participant_name);
    Date =  Current_File_name(Char_Date);
    sub_ind = k+1;
%     cd (ROIout_folder) ;
    ROI_files_Full_path = spm_select('ExtFPList',ROI_folder,'^.*\.nii$');
    ROI_file_names = spm_select('List',ROI_folder,'^.*\.nii$');
%         cd ..
    [num_roi, xx]= size(ROI_file_names);
         
    for i = 1:num_roi
        Stats_xlsx{1,i} =  ROI_file_names(i,:);
        spm('Defaults','fMRI');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.imcalc.input = [cellstr(thisFile);cellstr(ROI_files_Full_path(i,:))];
        matlabbatch{1}.spm.util.imcalc.output = 'Temp_out';
        matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
        matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        spm_jobman('run',matlabbatch);
        ROI_reg = spm_vol('Temp_out.nii');
        ROI_reg_vals = spm_read_vols(ROI_reg);
        ROI_reg_mean = mean(nonzeros(ROI_reg_vals));
        Stats_xlsx{sub_ind,i}=ROI_reg_mean;
                    
    end

end

xlswrite(filename,Stats_xlsx,Sheet_Name,xlRange);