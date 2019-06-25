function abk_4Dto3D(fname)
    % function abk_4Dto3D(fname)
    %
    % Splits a 4D nifti file into a series of 3D nifti files.
    % Needs SPM functions to work. If input file is fdata.nii,
    % the output files will have filenames like fdata_001.nii,
    % fdata_002.nii, etc.

    if (nargin < 1)
        [fname,sts] = spm_select;
        if (sts == 0)
            fprintf('abk_4Dto3D: Operation cancelled.\n');
            return;
        end
    end

    vol = spm_vol(fname);
    img = spm_read_vols(vol);
    sz = size(img);

    tvol = vol(1);
    tvol = rmfield(tvol,'private');
   

    [dn,fn,ext] = fileparts(fname);
 
    for ctr=1:sz(4)
        tvol.fname = sprintf('%s%s%s_%.3d%s',dn,filesep,fn,ctr,ext);
        fprintf('Writing %s\n',tvol.fname);
        spm_write_vol(tvol,img(:,:,:,ctr));
    end
    fprintf('done.\n');
end
    