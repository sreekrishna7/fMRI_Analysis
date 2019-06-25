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
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Retaliation\ALL_text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\Retaliation\OPS_Retaliation_SliderValue.xlsx'; 
xlRange = 'A1';
Retaliation_stat_xlsx{1,1} = 'Subject_ID';    
Retaliation_stat_xlsx{1,2} = 'Date';        
Retaliation_stat_xlsx{1,3} = 'Time_Point'; 
Retaliation_stat_xlsx{1,4} = 'SV1'; 
Retaliation_stat_xlsx{1,5} = 'SV2'; 
Retaliation_stat_xlsx{1,6} = 'SV3'; 
Retaliation_stat_xlsx{1,7} = 'SV4'; 
Retaliation_stat_xlsx{1,8} = 'SV5'; 
Retaliation_stat_xlsx{1,9} = 'SV6'; 
Retaliation_stat_xlsx{1,10} = 'SV7'; 
Retaliation_stat_xlsx{1,11} = 'SV8'; 
Retaliation_stat_xlsx{1,12} = 'SV9'; 
Retaliation_stat_xlsx{1,13} = 'SV10'; 
Retaliation_stat_xlsx{1,14} = 'SV11'; 
Retaliation_stat_xlsx{1,15} = 'SV12'; 
Retaliation_stat_xlsx{1,16} = 'SV13'; 
Retaliation_stat_xlsx{1,17} = 'SV14'; 
Retaliation_stat_xlsx{1,18} = 'SV15'; 
Retaliation_stat_xlsx{1,19} = 'SV16'; 
Retaliation_stat_xlsx{1,20} = 'SV17'; 
Retaliation_stat_xlsx{1,21} = 'SV18'; 
Retaliation_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  147 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_Retaliation_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    DATA_Retaliation = read_edat_output_2008(thisFile);
    
    Win_Loss = DATA_Retaliation.TrialType;
    idx_Win = find(strcmp(DATA_Retaliation.TrialType, 'Win'));
    Video_resp = DATA_Retaliation.ProcedureSubTrial(idx_Win);
    
    Win_Slider_value = cellfun(@(xxx) xxx(9),Video_resp,'un',0);
    
    

%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,1} = Current_File_name(1:11); %Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,2} = [Current_File_name(17:20) Current_File_name(13:14) Current_File_name(15:16)];%Date
%       Retaliation_stat_xlsx{Retaliation_ind,1} = Current_Folder_name; %Subject ID
%       Retaliation_stat_xlsx{Retaliation_ind,2} = PPGdata(1,21:28);    %Date
     Retaliation_stat_xlsx{Retaliation_ind,3} = Current_File_name(34:38);
     Retaliation_stat_xlsx(Retaliation_ind,4:21) = Win_Slider_value';%Bracket changed from flower to normal
     Retaliation_ind = Retaliation_ind+1;
     clearvars variables -except k Retaliation_stat_xlsx Retaliation_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,Retaliation_stat_xlsx,'Retaliation',xlRange);