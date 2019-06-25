close all
clear all
clc
tic



%%

addpath C:\Users\ramakrs\Documents\spm12


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
a = spm_select('ExtList',pwd, 'STRUCTURAL.nii$',1);

clear matlabbatch

% Realign
% --------------------------------------------------------------------------
matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(f)};
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];

% % Coregister
% %--------------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref    = cellstr('meanafunctional.nii');
matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(a);

% % Segment
% %--------------------------------------------------------------------------
matlabbatch{3}.spm.spatial.preproc.channel.vols  = cellstr(a);
matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{3}.spm.spatial.preproc.warp.write    = [0 1];

% % Normalise: Write
% %--------------------------------------------------------------------------
matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr('y_structural.nii');
matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(f);
matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];

matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr('y_structural.nii');
matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr('mstructural.nii');
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

% % Smooth
% %--------------------------------------------------------------------------
matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(f,'prefix','w'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];

spm_jobman('run',matlabbatch);
%%
toc

