%% Use the following command in windows cmd
% dir /s /b *. > file_paths.txt

close all;
clear all;
clc
format longg;
format compact;
listOfFolderNames = textread('E:\OPS\SK_For_Preprocessing\file_paths.txt','%s'); 
numberOfFolders = length(listOfFolderNames);
for k = 1: numberOfFolders %*****************************CHANGE*************

    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [uppertoupperPath, upper_Folder_name, ~] = fileparts(upperPath);
    if strcmp(Current_Folder_name,'Retaliation')
        copyfile (pwd, ['E:\OPS\SK_Preprocessed\Retaliation\' upper_Folder_name(10:20) '\' upper_Folder_name(1:8) '\Retaliation'] ) ;
    end
   
end