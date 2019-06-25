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
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\ANT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\ANT\OPS_ANT_RTTime_Accuracy.xlsx'; 
xlRange = 'A1';
ANT_stat_xlsx{1,1} = 'Subject_ID';    
ANT_stat_xlsx{1,2} = 'Date';        
ANT_stat_xlsx{1,3} = 'ANT_Congruent_RTTime'; 
ANT_stat_xlsx{1,4} = 'ANT_Incongruent_RTTime'; 
ANT_stat_xlsx{1,5} = 'ANT_no_cue_RTTime'; 
ANT_stat_xlsx{1,6} = 'ANT_centre_cue_RTTime'; 
ANT_stat_xlsx{1,7} = 'ANT_spatial_cue_RTTime'; 
ANT_stat_xlsx{1,8} = 'Alerting_Effect';
ANT_stat_xlsx{1,9} = 'Executive_Control_Effect';
ANT_stat_xlsx{1,10} = 'Orienting_Effect';
ANT_stat_xlsx{1,11} = 'ANT_Accuracy'; 
ANT_stat_xlsx{1,12} = 'ANT_Response_Rate'; 
ANT_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_ANT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);

    DATA_ANT = read_edat_output_2008(Eprime_ANT_Textfile);
    
    idx_T1_ACC = find(~strcmp(DATA_ANT.Target1_ACC, 'NULL'));
    idx_T2_ACC = find(~strcmp(DATA_ANT.Target2_ACC, 'NULL'));
    idx_T3_ACC = find(~strcmp(DATA_ANT.Target3_ACC, 'NULL'));
    idx_T4_ACC = find(~strcmp(DATA_ANT.Target4_ACC, 'NULL'));
    Answers_ANT = [DATA_ANT.Target1_ACC(idx_T1_ACC(1:end))' DATA_ANT.Target2_ACC(idx_T2_ACC(1:end))' ...
        DATA_ANT.Target3_ACC(idx_T3_ACC(1:end))' DATA_ANT.Target4_ACC(idx_T4_ACC(1:end))'];
    Answers_ANT_mat = zeros(size(Answers_ANT));
    for i = 1:length(Answers_ANT)
       Answers_ANT_mat(i)  = str2double(cell2mat(Answers_ANT(i)));
    end
    
    idx_T1_RT = find(~strcmp(DATA_ANT.Target1_RT, 'NULL'));
    idx_T2_RT = find(~strcmp(DATA_ANT.Target2_RT, 'NULL'));
    idx_T3_RT = find(~strcmp(DATA_ANT.Target3_RT, 'NULL'));
    idx_T4_RT = find(~strcmp(DATA_ANT.Target4_RT, 'NULL'));
    RT_ANT  = [DATA_ANT.Target1_RT(idx_T1_RT(1:end))' DATA_ANT.Target2_RT(idx_T2_RT(1:end))' ...
        DATA_ANT.Target3_RT(idx_T3_RT(1:end))' DATA_ANT.Target4_RT(idx_T4_RT(1:end))'];
    
  
    if iscell(RT_ANT)
        RT_ANT_temp = zeros (length(RT_ANT),1);
        for i = 1:length(RT_ANT) 
            RT_ANT_temp(i) = str2double(cell2mat(RT_ANT(i)));
        end
        clear RT_ANT;
        RT_ANT = RT_ANT_temp;
    end
    RT_ANT_All = RT_ANT;
    RT_ANT = RT_ANT(Answers_ANT_mat>0);
    idx_RT = [idx_T1_RT ; idx_T2_RT ; idx_T3_RT ; idx_T4_RT];
    
    FlankerType = DATA_ANT.FlankerType(idx_RT);
    FlankerType = FlankerType(Answers_ANT_mat>0);
    idx_Congruent   = find(strcmp(FlankerType, 'congruent'));
    idx_Incongruent = find(strcmp(FlankerType, 'incongruent'));
        
    CueState = DATA_ANT.CueState(idx_RT);
    CueState = CueState(Answers_ANT_mat>0);
    idx_no_cue   = find(strcmp(CueState, 'no'));
    idx_centre_cue   = find(strcmp(CueState, 'both'));
    idx_spatial_cue = find(ismember(CueState, {'cueup', 'cuedown'}));

    RT_ANT_Congruent_full      = RT_ANT(idx_Congruent);
    RT_ANT_Congruent_nonzero   = RT_ANT_Congruent_full(RT_ANT_Congruent_full > 0) ;
    RT_ANT_Congruent_avg       = mean(RT_ANT_Congruent_nonzero);
            
    RT_ANT_Incongruent_full    = RT_ANT(idx_Incongruent);
    RT_ANT_Incongruent_nonzero = RT_ANT_Incongruent_full(RT_ANT_Incongruent_full > 0);
    RT_ANT_Incongruent_avg     = mean(RT_ANT_Incongruent_nonzero);
     
    RT_ANT_no_cue_full    = RT_ANT(idx_no_cue);
    RT_ANT_no_cue_nonzero = RT_ANT_no_cue_full(RT_ANT_no_cue_full > 0);
    RT_ANT_no_cue_avg     = mean(RT_ANT_no_cue_nonzero);
     
    RT_ANT_centre_cue_full    = RT_ANT(idx_centre_cue);
    RT_ANT_centre_cue_nonzero = RT_ANT_centre_cue_full(RT_ANT_centre_cue_full > 0);
    RT_ANT_centre_cue_avg     = mean(RT_ANT_centre_cue_nonzero);
     
    RT_ANT_spatial_cue_full    = RT_ANT(idx_spatial_cue);
    RT_ANT_spatial_cue_nonzero = RT_ANT_spatial_cue_full(RT_ANT_spatial_cue_full > 0);
    RT_ANT_spatial_cue_avg     = mean(RT_ANT_spatial_cue_nonzero);
     
    Alerting_Effect          = RT_ANT_no_cue_avg - RT_ANT_centre_cue_avg; 
    Executive_Control_Effect = RT_ANT_Incongruent_avg - RT_ANT_Congruent_avg;
    Orienting_Effect         = RT_ANT_centre_cue_avg -RT_ANT_spatial_cue_avg; 
     
     %% Accuracy
     Answers_ANT = Answers_ANT(RT_ANT_All>0);
     tot_ANT = 0;
     for i = 1:length(Answers_ANT)
         tot_ANT = tot_ANT + str2double(cell2mat(Answers_ANT(i)));
     end 
     ANT_accuracy = tot_ANT/length(Answers_ANT);
     ANT_RespRate = length(Answers_ANT)/length(RT_ANT_All);
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     ANT_stat_xlsx{ANT_ind,1} = Current_File_name(1:11); %Subject ID
     ANT_stat_xlsx{ANT_ind,2} = Current_File_name(13:20);%Date
%       ANT_stat_xlsx{ANT_ind,1} = Current_Folder_name; %Subject ID
%       ANT_stat_xlsx{ANT_ind,2} = PPGdata(1,21:28);    %Date
     ANT_stat_xlsx{ANT_ind,3} = RT_ANT_Congruent_avg;
     ANT_stat_xlsx{ANT_ind,4} = RT_ANT_Incongruent_avg;
     ANT_stat_xlsx{ANT_ind,5} = RT_ANT_no_cue_avg;  
     ANT_stat_xlsx{ANT_ind,6} = RT_ANT_centre_cue_avg;
     ANT_stat_xlsx{ANT_ind,7} = RT_ANT_spatial_cue_avg; 
     ANT_stat_xlsx{ANT_ind,8} = Alerting_Effect;   
     ANT_stat_xlsx{ANT_ind,9} = Executive_Control_Effect;
     ANT_stat_xlsx{ANT_ind,10} = Orienting_Effect;
     ANT_stat_xlsx{ANT_ind,11} =  ANT_accuracy;
     ANT_stat_xlsx{ANT_ind,12} = ANT_RespRate;
     ANT_ind = ANT_ind+1;
     clearvars variables -except k ANT_stat_xlsx ANT_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,ANT_stat_xlsx,'ANT',xlRange);