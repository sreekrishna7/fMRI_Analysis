close all; clear;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
% listOfFileNames = textread('E:\OPS\SK_Preprocessed\AXCPT\sw_func_filepaths.txt','%s'); 
listOfFileNames = textread('E:\OPS\SK_Preprocessed\AXCPT\func_filepaths.txt','%s'); 
numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
%     sw_x    = spm_vol(thisFile);
%     sw_img  = spm_read_vols(sw_x);
%     num_dis = 4; % number of volumes to discard
%     num_vol = size(sw_x,1);
%     sw_sig  = zeros(1,num_vol-num_dis);
%     nn=1;
%     for i = num_dis+1:num_vol 
%         sw_sig(nn) = mean(mean(mean(nonzeros(sw_img(:,:,:,i)))));
%         nn = nn+1;
%     end
%     sw_data(k).Signal = sw_sig;
%     sw_data(k).ParticipantID = Current_File_name(4:14);
%     sw_data(k).Date = Current_File_name(20:27);
%  plot(sw_data(k).Signal); hold on;
    x    = spm_vol(thisFile);
    img  = spm_read_vols(x);
    num_dis = 4; % number of volumes to discard
    num_vol = size(x,1);
    sig  = zeros(1,num_vol-num_dis);
    nn=1;
    for i = num_dis+1:num_vol 
        sig(nn) = mean(mean(mean(nonzeros(img(:,:,:,i)))));
        nn = nn+1;
    end
    data(k).Signal = sig;
    data(k).ParticipantID = Current_File_name(1:11);
    data(k).Date = Current_File_name(17:24);
end
save('Signals.mat', 'data');

for i = 1:147
    plot(sw_data(i).Signal);plotbrowser on; grid; 
    xlabel('Volumes Index --->');ylabel('Average Signal Value  --->')
    hold on;

end
