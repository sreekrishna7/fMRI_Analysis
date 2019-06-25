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
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\AXCPT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\AXCPT\OPS_AXCPT_RTime_Accuracy.xlsx'; 
xlRange = 'A1';
AXCPT_stat_xlsx{1,1}  = 'Subject_ID';    
AXCPT_stat_xlsx{1,2}  = 'Date';       
AXCPT_stat_xlsx{1,3}  = 'Mean_CueRTime';
AXCPT_stat_xlsx{1,4}  = 'A_CueRTime'; 
AXCPT_stat_xlsx{1,5}  = 'B_CueRTime'; 
AXCPT_stat_xlsx{1,6}  = 'Mean_ProbeRTime';
AXCPT_stat_xlsx{1,7}  = 'AX_ProbeRTime'; 
AXCPT_stat_xlsx{1,8}  = 'AY_ProbeRTime'; 
AXCPT_stat_xlsx{1,9}  = 'BX_ProbeRTime'; 
AXCPT_stat_xlsx{1,10} = 'BY_ProbeRTime'; 
AXCPT_stat_xlsx{1,11} = 'Mean_CueAccuracy';  
AXCPT_stat_xlsx{1,12} = 'A_CueAccuracy';
AXCPT_stat_xlsx{1,13} = 'B_CueAccuracy';
AXCPT_stat_xlsx{1,14} = 'Mean_ProbeAccuracy';  
AXCPT_stat_xlsx{1,15} = 'AX_ProbeAccuracy';
AXCPT_stat_xlsx{1,16} = 'AY_ProbeAccuracy';
AXCPT_stat_xlsx{1,17} = 'BX_ProbeAccuracy';
AXCPT_stat_xlsx{1,18} = 'BY_ProbeAccuracy';
AXCPT_stat_xlsx{1,19} = 'A_CueRespRate(120 Trials)';  
AXCPT_stat_xlsx{1,20} = 'B_CueRespRate(24 Trials)';
AXCPT_stat_xlsx{1,21} = 'AX_ProbeRespRate(104 Trials)';
AXCPT_stat_xlsx{1,22} = 'AY_ProbeRespRate(16 Trials)';
AXCPT_stat_xlsx{1,23} = 'BX_ProbeRespRate(16 Trials)';
AXCPT_stat_xlsx{1,24} = 'BY_ProbeRespRate(8 Trials)';
AXCPT_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_AXCPT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);

    DATA_AXCPT = read_edat_output_2008(thisFile);
    ScannerOnset =DATA_AXCPT.WaitForScanner_RTTime;
%% Reaction Times
    idx_Probe = find(~strcmp(DATA_AXCPT.WaitForScanner_RTTime, 'NULL'));
    idx_Cue = idx_Probe; 
    Cue_RT    = DATA_AXCPT.Cue_RT(idx_Cue(1):end);
    Probe_RT  = DATA_AXCPT.Probe_RT(idx_Probe(1):end);
     
    AXCPT_Cue_Acc = DATA_AXCPT.Cue_ACC(idx_Cue(1):end);
    AXCPT_Cue_Acc_mat = zeros(size( AXCPT_Cue_Acc));
    for i = 1:length(AXCPT_Cue_Acc)
        AXCPT_Cue_Acc_mat(i)  = str2double(cell2mat(AXCPT_Cue_Acc(i)));
    end
    
    AXCPT_Probe_Acc = DATA_AXCPT.Probe_ACC(idx_Probe(1):end);
    AXCPT_Probe_Acc_mat = zeros(size(AXCPT_Probe_Acc));
    for i = 1:length(AXCPT_Probe_Acc)
        AXCPT_Probe_Acc_mat(i)  = str2double(cell2mat(AXCPT_Probe_Acc(i)));
    end
    
    if iscell(Cue_RT)
        Cue_RT_temp = zeros (length(Cue_RT),1);
        for i = 1:length(Cue_RT) 
            Cue_RT_temp(i) = str2double(cell2mat(Cue_RT(i)));
        end
        clear Cue_RT;
        Cue_RT = Cue_RT_temp;
    end
    Cue_RT_All = Cue_RT;
    Cue_RT = Cue_RT(AXCPT_Cue_Acc_mat>0);
    if iscell(Probe_RT)
        Probe_RT_temp = zeros (length(Probe_RT),1);
        for i = 1:length(Probe_RT) 
            Probe_RT_temp(i) = str2double(cell2mat(Probe_RT(i)));
        end
        clear Probe_RT;
        Probe_RT = Probe_RT_temp;
    end
    Probe_RT_All = Probe_RT;
    Probe_RT = Probe_RT(AXCPT_Probe_Acc_mat>0);
    

    
    
    Cue_RT_nonzero   = Cue_RT(Cue_RT > 0) ;
    Cue_RT_avg = mean(Cue_RT_nonzero);
    
    TrialType = DATA_AXCPT.TrialType(idx_Probe(1):end);
    TrialTypeforCue = TrialType;
    TrialTypeforProbe = TrialTypeforCue;
    TrialTypeforCue = TrialTypeforCue(AXCPT_Cue_Acc_mat>0);
    TrialTypeforProbe = TrialTypeforProbe(AXCPT_Probe_Acc_mat>0);
    
    
    
    Cue_RT_A_id_All  = find(strncmp(TrialType, 'A',1));
    Cue_RT_B_id_All  = find(strncmp(TrialType, 'B',1));
    Cue_RT_A_id  = find(strncmp(TrialTypeforCue, 'A',1));
    Cue_RT_B_id  = find(strncmp(TrialTypeforCue, 'B',1));
    
    Cue_RT_A     =  Cue_RT(Cue_RT_A_id);
    Cue_RT_A_All     =  Cue_RT_All(Cue_RT_A_id_All);
    Cue_RT_A_nonzero   = Cue_RT_A(Cue_RT_A > 0) ;
    Cue_RT_A_avg = mean(Cue_RT_A_nonzero);
    
    Cue_RT_B     =  Cue_RT(Cue_RT_B_id);
    Cue_RT_B_All     =  Cue_RT_All(Cue_RT_B_id_All);
    Cue_RT_B_nonzero   = Cue_RT_B(Cue_RT_B > 0) ;
    Cue_RT_B_avg = mean(Cue_RT_B_nonzero);
    
    
    Probe_RT_nonzero   = Probe_RT(Probe_RT > 0) ;
    Probe_RT_avg = mean(Probe_RT_nonzero);
    
        
    Probe_RT_AX_id_All  = find(strcmp(TrialType, 'AX'));
    Probe_RT_AY_id_All  = find(strcmp(TrialType, 'AY'));
    Probe_RT_BX_id_All  = find(strcmp(TrialType, 'BX'));
    Probe_RT_BY_id_All  = find(strcmp(TrialType, 'BY'));
    
    Probe_RT_AX_id  = find(strcmp(TrialTypeforProbe, 'AX'));
    Probe_RT_AY_id  = find(strcmp(TrialTypeforProbe, 'AY'));
    Probe_RT_BX_id  = find(strcmp(TrialTypeforProbe, 'BX'));
    Probe_RT_BY_id  = find(strcmp(TrialTypeforProbe, 'BY'));
    
    Probe_RT_AX     =  Probe_RT(Probe_RT_AX_id);
    Probe_RT_AX_All     =  Probe_RT_All(Probe_RT_AX_id_All);
    Probe_RT_AX_nonzero   = Probe_RT_AX(Probe_RT_AX > 0) ;
    Probe_RT_AX_avg = mean(Probe_RT_AX_nonzero);
    
    Probe_RT_AY     =  Probe_RT(Probe_RT_AY_id);
    Probe_RT_AY_All     =  Probe_RT_All(Probe_RT_AY_id_All);
    Probe_RT_AY_nonzero   = Probe_RT_AY(Probe_RT_AY > 0) ;
    Probe_RT_AY_avg = mean(Probe_RT_AY_nonzero);
    
    Probe_RT_BX     =  Probe_RT(Probe_RT_BX_id);
    Probe_RT_BX_All     =  Probe_RT_All(Probe_RT_BX_id_All);
    Probe_RT_BX_nonzero   = Probe_RT_BX(Probe_RT_BX > 0) ;
    Probe_RT_BX_avg = mean(Probe_RT_BX_nonzero);
    
    Probe_RT_BY     =  Probe_RT(Probe_RT_BY_id);
    Probe_RT_BY_All     =  Probe_RT_All(Probe_RT_BY_id_All);
    Probe_RT_BY_nonzero   = Probe_RT_BY(Probe_RT_BY > 0) ;
    Probe_RT_BY_avg = mean(Probe_RT_BY_nonzero);
    
   
 %% Accuracy
%%_______
 
    AXCPT_Cue_Acc_nonzero = AXCPT_Cue_Acc(Cue_RT_All > 0); %considering only responses
    tot_AXCPT_Cue = sum(str2double(AXCPT_Cue_Acc_nonzero));
    AXCPT_Cue_accuracy = tot_AXCPT_Cue/length(AXCPT_Cue_Acc_nonzero);
    
    AXCPT_A_Acc =   AXCPT_Cue_Acc(Cue_RT_A_id_All);
    AXCPT_A_Acc_nonzero = AXCPT_A_Acc(Cue_RT_A_All > 0);
    tot_AXCPT_A = sum(str2double(AXCPT_A_Acc_nonzero));
    AXCPT_A_accuracy = tot_AXCPT_A/length(AXCPT_A_Acc_nonzero);
    
    AXCPT_B_Acc =   AXCPT_Cue_Acc(Cue_RT_B_id_All);
    AXCPT_B_Acc_nonzero = AXCPT_B_Acc(Cue_RT_B_All > 0);
    tot_AXCPT_B = sum(str2double(AXCPT_B_Acc_nonzero));
    AXCPT_B_accuracy = tot_AXCPT_B/length(AXCPT_B_Acc_nonzero);
 %%__________

    AXCPT_Probe_Acc_nonzero = AXCPT_Probe_Acc(Probe_RT_All > 0); %considering only responses
    tot_AXCPT_Probe = sum(str2double(AXCPT_Probe_Acc_nonzero));
    AXCPT_Probe_accuracy = tot_AXCPT_Probe/length(AXCPT_Probe_Acc_nonzero);
    
    AXCPT_AX_Acc =   AXCPT_Probe_Acc(Probe_RT_AX_id_All);
    AXCPT_AX_Acc_nonzero = AXCPT_AX_Acc(Probe_RT_AX_All > 0);
    tot_AXCPT_AX = sum(str2double(AXCPT_AX_Acc_nonzero));
    AXCPT_AX_accuracy = tot_AXCPT_AX/length(AXCPT_AX_Acc_nonzero);
    
    AXCPT_AY_Acc =   AXCPT_Probe_Acc(Probe_RT_AY_id_All);
    AXCPT_AY_Acc_nonzero = AXCPT_AY_Acc(Probe_RT_AY_All > 0);
    tot_AXCPT_AY = sum(str2double(AXCPT_AY_Acc_nonzero));
    AXCPT_AY_accuracy = tot_AXCPT_AY/length(AXCPT_AY_Acc_nonzero);

    AXCPT_BX_Acc =   AXCPT_Probe_Acc(Probe_RT_BX_id_All);
    AXCPT_BX_Acc_nonzero =  AXCPT_BX_Acc(Probe_RT_BX_All > 0);
    tot_AXCPT_BX = sum(str2double(AXCPT_BX_Acc_nonzero));
    AXCPT_BX_accuracy = tot_AXCPT_BX/length(AXCPT_BX_Acc_nonzero);
    
    AXCPT_BY_Acc =   AXCPT_Probe_Acc(Probe_RT_BY_id_All);
    AXCPT_BY_Acc_nonzero = AXCPT_BY_Acc(Probe_RT_BY_All > 0);
    tot_AXCPT_BY = sum(str2double(AXCPT_BY_Acc_nonzero));
    AXCPT_BY_accuracy = tot_AXCPT_BY/length(AXCPT_BY_Acc_nonzero);
    
    AXCPT_A_CueRespRate    = length(AXCPT_A_Acc_nonzero)/120;
    AXCPT_B_CueRespRate    = length(AXCPT_B_Acc_nonzero)/24;   
    AXCPT_AX_ProbeRespRate = length(AXCPT_AX_Acc_nonzero)/104;
    AXCPT_AY_ProbeRespRate = length(AXCPT_AY_Acc_nonzero)/16;
    AXCPT_BX_ProbeRespRate = length(AXCPT_BX_Acc_nonzero)/16;
    AXCPT_BY_ProbeRespRate = length(AXCPT_BY_Acc_nonzero)/8;
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     AXCPT_stat_xlsx{AXCPT_ind,1} = Current_File_name(1:11); %Subject ID
     AXCPT_stat_xlsx{AXCPT_ind,2} = Current_File_name(13:20);%Date
%       AXCPT_stat_xlsx{AXCPT_ind,1} = Current_Folder_name; %Subject ID
%       AXCPT_stat_xlsx{AXCPT_ind,2} = PPGdata(1,21:28);    %Date
     AXCPT_stat_xlsx{AXCPT_ind,3} = Cue_RT_avg;
     AXCPT_stat_xlsx{AXCPT_ind,4} = Cue_RT_A_avg;
     AXCPT_stat_xlsx{AXCPT_ind,5} = Cue_RT_B_avg;  
     AXCPT_stat_xlsx{AXCPT_ind,6} = Probe_RT_avg;
     AXCPT_stat_xlsx{AXCPT_ind,7} = Probe_RT_AX_avg;
     AXCPT_stat_xlsx{AXCPT_ind,8} = Probe_RT_AY_avg;  
     AXCPT_stat_xlsx{AXCPT_ind,9} = Probe_RT_BX_avg;
     AXCPT_stat_xlsx{AXCPT_ind,10} = Probe_RT_BY_avg; 
     AXCPT_stat_xlsx{AXCPT_ind,11} = AXCPT_Cue_accuracy;   
     AXCPT_stat_xlsx{AXCPT_ind,12} = AXCPT_A_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,13} = AXCPT_B_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,14} = AXCPT_Probe_accuracy;   
     AXCPT_stat_xlsx{AXCPT_ind,15} = AXCPT_AX_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,16} = AXCPT_AY_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,17} = AXCPT_BX_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,18} = AXCPT_BY_accuracy;
     AXCPT_stat_xlsx{AXCPT_ind,19} = AXCPT_A_CueRespRate;
     AXCPT_stat_xlsx{AXCPT_ind,20} = AXCPT_B_CueRespRate;   
     AXCPT_stat_xlsx{AXCPT_ind,21} = AXCPT_AX_ProbeRespRate;
     AXCPT_stat_xlsx{AXCPT_ind,22} = AXCPT_AY_ProbeRespRate;
     AXCPT_stat_xlsx{AXCPT_ind,23} = AXCPT_BX_ProbeRespRate;
     AXCPT_stat_xlsx{AXCPT_ind,24} = AXCPT_BY_ProbeRespRate;
     AXCPT_ind = AXCPT_ind+1;
     clearvars variables -except k AXCPT_stat_xlsx AXCPT_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,AXCPT_stat_xlsx,'AXCPT',xlRange);