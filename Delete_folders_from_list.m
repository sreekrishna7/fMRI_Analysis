close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFolderNames = textread('E:\BHS_Brain\BHS_Brain_DATA\filepaths.txt','%s'); 

numberOfFolders = length(listOfFolderNames);
for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.txt']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
   
    cd STROOP;
%     rmdir ('glm','s');
    rmdir ('glm_incon_con','s');
    
end