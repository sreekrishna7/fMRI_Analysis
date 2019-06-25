close all;
clear all;
clc;
addpath C:\Users\ramakrs\Documents\spm12
%file = spm_select('List',pwd,'^functional.nii');
fileip = 'FUNCTIONAL';
file = [fileip '.nii'];
%%
n_slices = 45;
%%
sliceOrder = [n_slices:-1:1];
refSlice = n_slices;
%%
TR = 3;
%%
TA = TR - (TR/n_slices);
time1 = TA/n_slices;
time2 = TR - TA;
timing(1) = time1;
timing(2) = time2;
spm_slice_timing(file, sliceOrder, refSlice, timing);

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

f = spm_select('ExtList',pwd, '^a',5:550);
st = spm_select('ExtList',pwd, 'STRUCTURAL.nii$',1);
st_name = spm_select('List',pwd,'STRUCTURAL.nii$');
clear matlabbatch

% Realign
% --------------------------------------------------------------------------
matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(f)};
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
[fileip 'Resliced' '.nii']
% % Coregister
% %--------------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr(['mean' 'a' fileip '.nii']);
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