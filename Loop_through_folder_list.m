close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFolderNames = textread('E:\BHS_Brain\BHS_Brain_DATA\file_paths.txt','%s'); 

numberOfFolders = length(listOfFolderNames);
for k =  1 : numberOfFolders
   thisFolder = listOfFolderNames{k};
   fprintf('Processing folder %s\n', thisFolder);
%% Do Something 
   cd (thisFolder);
   copyfile('ASL_Backup','ASL_Backup1')
end