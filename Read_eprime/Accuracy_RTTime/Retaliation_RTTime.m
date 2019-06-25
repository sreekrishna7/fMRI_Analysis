%% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear;
clc
format longg;
format compact;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
%% Inputs
%Run the windows_cmd_for_file_paths.txt
%dir /b /s /a:-D > results.txt
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Retaliation\results.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\Retaliation\OPS_Retaliation_RTTime.xlsx'; 
xlRange = 'A1';
Retaliation_stat_xlsx{1,1} = 'Subject_ID';    
Retaliation_stat_xlsx{1,2} = 'Date';        
Retaliation_stat_xlsx{1,3} = 'Time_Point'; 
Retaliation_stat_xlsx{1,4} = 'Retaliation_RTTime'; 

Retaliation_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    load (thisFile);
    
    RT_Time = mean(durations{1, 1});
    
    
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,1} = Current_File_name(1:11); %Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,2} = [Current_File_name(17:20) Current_File_name(13:14) Current_File_name(15:16)];%Date
%       Retaliation_stat_xlsx{Retaliation_ind,1} = Current_Folder_name; %Subject ID
%       Retaliation_stat_xlsx{Retaliation_ind,2} = PPGdata(1,21:28);    %Date
     Retaliation_stat_xlsx{Retaliation_ind,3} = Current_File_name(34:38);
     Retaliation_stat_xlsx{Retaliation_ind,4} = RT_Time;
     Retaliation_ind = Retaliation_ind+1;
     clearvars variables -except k Retaliation_stat_xlsx Retaliation_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,Retaliation_stat_xlsx,'Retaliation',xlRange);