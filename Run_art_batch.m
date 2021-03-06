close all;
clear;
clc
addpath C:\Users\ramakrs\Documents\spm12;
addpath C:\Users\ramakrs\Documents\spm12\toolbox\art-2015-10\;
listOfFileNames = textread('E:\ENS\ENS_fMRI_Data\To_Do\spm_mat_file_paths.txt','%s'); 
% art_batch(listOfFileNames);
global_mean=1;                % global mean type (1: Standard 2: User-defined Mask)
motion_file_type=0;           % motion file type (0: SPM .txt file 1: FSL .par file 2:Siemens .txt file)
global_threshold=2.3;         % threshold for outlier detection based on global signal
motion_threshold=1.0;         % threshold for outlier detection based on motion estimates
use_diff_motion=1;            % 1: uses scan-to-scan motion to determine outliers; 0: uses absolute motion
use_diff_global=1;            % 1: uses scan-to-scan global signal change to determine outliers; 0: uses absolute global signal values
use_norms=0;                  % 1: uses composite motion measure (largest voxel movement) to determine outliers; 0: uses raw motion measures (translation/rotation parameters) 
mask_file=[];                 % set to user-defined mask file(s) for global signal estimation (if global_mean is set to 2) 
files=char(listOfFileNames);
for n1=1:size(files,1),
        cfgfile=fullfile(pwd,['art_config',num2str(n1,'%03d'),'.cfg']);
        fid=fopen(cfgfile,'wt');
        %[filepath,filename,fileext]=fileparts(deblank(files(n1,:)));
        load(deblank(files(n1,:)),'SPM');
        
        fprintf(fid,'# Automatic script generated by %s\n',mfilename);
        fprintf(fid,'# Users can edit this file and use\n');
        fprintf(fid,'#   art(''sess_file'',''%s'');\n',cfgfile);
        fprintf(fid,'# to launch art using this configuration\n');
        
        fprintf(fid,'sessions: %d\n',length(SPM.Sess));
        fprintf(fid,'global_mean: %d\n',global_mean);
        fprintf(fid,'global_threshold: %f\n',global_threshold);
        fprintf(fid,'motion_threshold: %f\n',motion_threshold);
        fprintf(fid,'motion_file_type: %d\n',motion_file_type);
        fprintf(fid,'motion_fname_from_image_fname: 1\n');
        fprintf(fid,'use_diff_motion: %d\n',use_diff_motion);
        fprintf(fid,'use_diff_global: %d\n',use_diff_global);
        fprintf(fid,'use_norms: %d\n',use_norms);
        fprintf(fid,'spm_file: %s\n',deblank(files(n1,:)));
        fprintf(fid,'output_dir: %s\n',fileparts(files(n1,:)));
        if ~isempty(mask_file),fprintf(fid,'mask_file: %s\n',deblank(mask_file(n1,:)));end
        fprintf(fid,'end\n');
        
        for n2=1:length(SPM.Sess),
            temp=[SPM.xY.P(SPM.Sess(n2).row,:),repmat(' ',[length(SPM.Sess(n2).row),1])]';
            fprintf(fid,'session %d image %s\n',n2,temp(:)');
        end
        fprintf(fid,'end\n');
        fclose(fid);
end

art_config_files=dir('*art_config*.cfg');
listOfFileNames ={art_config_files.name};


numberOfFiles = length(listOfFileNames);
for k =  1: numberOfFiles
    thisFile = listOfFileNames{k};% 	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    art('sess_file',thisFile);
    close;
end
