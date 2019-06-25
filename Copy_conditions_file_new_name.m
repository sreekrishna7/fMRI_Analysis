close all;
clear;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Retaliation\Task_2\mat_file_paths.txt','%s'); 
to_location  = 'E:\OPS\SK_Preprocessed\Retaliation';
numberOfFiles = length(listOfFileNames);

% Analyze image files in those folders.
for k = 134: numberOfFiles 
    % Get this folder and print it out.
	thisFile = listOfFileNames{k};
 	fprintf('Copying File %s\n', thisFile);
    
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
  
    new_name  =  [Current_File_name(1:11) '_' Current_File_name(17:20) Current_File_name(13:16) Current_File_name(21:end) '.mat'];
%     copyfile(thisFile,[to_location '\' new_name(1:11) '\' new_name(13:20) '\Gambling\Run_1\' new_name]);
%     copyfile(thisFile,[to_location '\' new_name(1:11) '\' new_name(13:20) '\Gambling\Run_2\' new_name]);
%     copyfile(thisFile,[to_location '\' new_name(1:11) '\' new_name(13:20) '\Emotional_Reactivity\' new_name]);
     copyfile(thisFile,[to_location '\' new_name(1:11) '\' new_name(13:20) '\Retaliation\Task_2\' new_name]);

end
