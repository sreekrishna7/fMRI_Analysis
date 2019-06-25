%% Use the following command in windows cmd
% dir /s /b *. > file_paths.txt

close all;
clear all;
clc
format longg;
format compact;
listOfFolderNames = textread('E:\OPS\SK_Preprocessed\Emotional_Reactivity\TO_Do\folder_paths.txt','%s'); 
numberOfFolders = length(listOfFolderNames);
for k = 1 : numberOfFolders %*****************************CHANGE*************

    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [uppertoupperPath, upper_Folder_name, ~] = fileparts(upperPath);
%     if strcmp(Current_Folder_name,'Gambling')
%         copyfile (pwd, ['E:\OPS\SK_Preprocessed\Gambling\' upper_Folder_name '\Gambling'] ) ;
%     end
%     if strcmp(Current_Folder_name,'ANT')
%         copyfile (pwd, ['E:\OPS\SK_Preprocessed\ANT\' upper_Folder_name '\ANT'] ) ;
%     end
%     if strcmp(Current_Folder_name,'AXCPT')
%         copyfile (pwd, ['E:\OPS\SK_Preprocessed\AXCPT\' upper_Folder_name '\AXCPT'] ) ;
%     end
%     if strcmp(Current_Folder_name,'MSIT')
%         copyfile (pwd, ['E:\OPS\SK_Preprocessed\MSIT\' upper_Folder_name '\MSIT'] ) ;
%     end
%     if strcmp(Current_Folder_name,'Emotional_Reactivity')
%         copyfile (pwd, ['E:\OPS\SK_Preprocessed\Emotional_Reactivity\' upper_Folder_name '\Emotional_Reactivity'] ) ;
%     end
    if strcmp(Current_Folder_name,'Retaliation')
        copyfile (pwd, ['E:\OPS\SK_Preprocessed\Retaliation\' upper_Folder_name '\Retaliation'] ) ;
    end
end