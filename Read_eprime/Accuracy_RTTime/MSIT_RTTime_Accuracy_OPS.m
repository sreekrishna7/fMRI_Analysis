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
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\MSIT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\MSIT\OPS_MSIT_RTTime_Accuracy.xlsx'; 
xlRange = 'A1';
MSIT_stat_xlsx{1,1} = 'Subject_ID';    
MSIT_stat_xlsx{1,2} = 'Date';        
MSIT_stat_xlsx{1,3} = 'MSIT_Congruent_RTTime'; 
MSIT_stat_xlsx{1,4} = 'MSIT_Incongruent_RTTime'; 
MSIT_stat_xlsx{1,5} = 'MSIT_Accuracy'; 
MSIT_stat_xlsx{1,6} = 'MSIT_Response_Rate';
MSIT_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_MSIT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_MSIT = read_edat_output_2008(Eprime_MSIT_Textfile);
    
    idx_Fixation_OnsetTime= find(~strcmp(DATA_MSIT.Fixation_OnsetTime, 'NULL'));
    MSIT_Acc = DATA_MSIT.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end);
    
    MSIT_Acc_mat = zeros(size(MSIT_Acc));
    for i = 1:length(MSIT_Acc)
       MSIT_Acc_mat(i)  = str2double(cell2mat(MSIT_Acc(i)));
    end
    
    
    idx_RT = find(~strcmp(DATA_MSIT.TrialDisplay_RTTime, 'NULL'));
    RT_MSIT  = DATA_MSIT.TrialDisplay_RT(idx_RT(1:end))';

    if iscell(RT_MSIT)
        RT_MSIT_temp = zeros (length(RT_MSIT),1);
        for i = 1:length(RT_MSIT) 
            RT_MSIT_temp(i) = str2double(cell2mat(RT_MSIT(i)));
        end
        clear RT_MSIT;
        RT_MSIT = RT_MSIT_temp;
    end
    RT_MSIT_All = RT_MSIT;
    RT_MSIT = RT_MSIT(MSIT_Acc_mat>0);
    RunningSubTrial = DATA_MSIT.RunningSubTrial(idx_RT(1):end);
    RunningSubTrial  = RunningSubTrial(MSIT_Acc_mat>0);
    idx_ConList= find(strncmp(RunningSubTrial , 'ConList', length('ConList')));
    idx_InconList= find(strncmp(RunningSubTrial , 'InconList', length('InconList')));
   
          
    RT_MSIT_Congruent_full      = RT_MSIT(idx_ConList);
    RT_MSIT_Congruent_nonzero   = RT_MSIT_Congruent_full(RT_MSIT_Congruent_full > 0) ;
    RT_MSIT_Congruent_avg       = mean(RT_MSIT_Congruent_nonzero);
            
    RT_MSIT_Incongruent_full    = RT_MSIT(idx_InconList);
    RT_MSIT_Incongruent_nonzero = RT_MSIT_Incongruent_full(RT_MSIT_Incongruent_full > 0);
    RT_MSIT_Incongruent_avg     = mean(RT_MSIT_Incongruent_nonzero);
     %% Accuracy
 
    MSIT_Acc = MSIT_Acc(RT_MSIT_All>0);
    tot_MSIT = sum(str2double(MSIT_Acc));
    MSIT_accuracy = tot_MSIT/length(MSIT_Acc);
    MSIT_RespRate = length(MSIT_Acc)/length(RT_MSIT_All);
    
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     MSIT_stat_xlsx{MSIT_ind,1} = Current_File_name(1:11); %Subject ID
     MSIT_stat_xlsx{MSIT_ind,2} = Current_File_name(13:20);%Date
%       MSIT_stat_xlsx{MSIT_ind,1} = Current_Folder_name; %Subject ID
%       MSIT_stat_xlsx{MSIT_ind,2} = PPGdata(1,21:28);    %Date
     MSIT_stat_xlsx{MSIT_ind,3} = RT_MSIT_Congruent_avg;
     MSIT_stat_xlsx{MSIT_ind,4} =  RT_MSIT_Incongruent_avg ;
     MSIT_stat_xlsx{MSIT_ind,5} =  MSIT_accuracy;
     MSIT_stat_xlsx{MSIT_ind,6} =  MSIT_RespRate;
     MSIT_ind = MSIT_ind+1;
     clearvars variables -except k MSIT_stat_xlsx MSIT_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,MSIT_stat_xlsx,'MSIT',xlRange);