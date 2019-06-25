close all;
clear;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Retaliation\Task_2\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k = 1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_Retaliation = read_edat_output_2008(thisFile);
%     idx = find(~strcmp(DATA_Retaliation.WaitforScanner_RTTime, 'NULL'));
    ScannerOnset =DATA_Retaliation.WaitforScanner_RTTime;
%     ScannerOnset = str2double(ScannerOnset(1));
    Trial_Type = DATA_Retaliation.TrialType; 
    idx_Loss   = find(strcmp(Trial_Type,'Loss'));
    idx_Win    = find(strcmp(Trial_Type,'Win'));
       
    Task_Onset = DATA_Retaliation.Start_OnsetTime;
    Task_Onset = ((Task_Onset - ScannerOnset)/1000) - 12;
    Task_RT = DATA_Retaliation.Start_RTTime;
    Task_RT =((Task_RT - ScannerOnset)/1000) - 12;
    Task_Duration = Task_RT - Task_Onset;
   %% 
    Smiley_Loss_Onset  = DATA_Retaliation.FaceResponse_OnsetTime(idx_Loss);
    Smiley_Loss_Onset =((Smiley_Loss_Onset - ScannerOnset(idx_Loss))/1000) - 12;
    Smiley_Loss_Duration = 2*ones(size(Smiley_Loss_Onset));
   %% 
    Smiley_Win_Onset    = DATA_Retaliation.FaceResponse_OnsetTime(idx_Win);
    Smiley_Win_Onset =((Smiley_Win_Onset - ScannerOnset(idx_Win))/1000) - 12;
    Smiley_Win_Duration = 2*ones(size(Smiley_Win_Onset));
    %%
    Anticipation_Pain_Onset = DATA_Retaliation.ShockAnticipation_OnsetTime(idx_Loss);
    Anticipation_Pain_Onset =((Anticipation_Pain_Onset - ScannerOnset(idx_Loss))/1000) - 12;
    Anticipation_Pain_Duration = DATA_Retaliation.ShockAnticipation_Duration(idx_Loss)/1000;
    
    slider_value =  DATA_Retaliation.SliderValueTrial(idx_Loss);
    if iscell(slider_value)
        idx_svHigh   = find(cellfun(@str2num,slider_value)>3);
        idx_svLow    = find(cellfun(@str2num,slider_value)<=3);
    else
        idx_svHigh   = find(slider_value>3);
        idx_svLow    = find(slider_value<=3);
    end
        
    Anticipation_High_Pain_Onset = Anticipation_Pain_Onset(idx_svHigh);
    Anticipation_Low_Pain_Onset = Anticipation_Pain_Onset(idx_svLow);
    Anticipation_High_Pain_Duration = Anticipation_Pain_Duration(idx_svHigh);
    Anticipation_Low_Pain_Duration = Anticipation_Pain_Duration(idx_svLow);
    
    if isempty (Anticipation_High_Pain_Onset)
        Anticipation_High_Pain_Onset = 0;
        Anticipation_High_Pain_Duration = 0;
    end
    if isempty (Anticipation_Low_Pain_Onset)
        Anticipation_Low_Pain_Onset = 0;
        Anticipation_Low_Pain_Duration = 0;
    end
    
    %%
    ScaleAdjust_RTTime = DATA_Retaliation.ScaleAdjustPunishment_RTTime(idx_Win);
    ScaleAdjust_RTTime_correct = ((ScaleAdjust_RTTime - ScannerOnset(idx_Win))/1000) - 12;
    ScaleAdjust_nonzeroidx = find(ScaleAdjust_RTTime>0);
    ScaleAdjust_RTTime =ScaleAdjust_RTTime_correct(ScaleAdjust_nonzeroidx);
    
    ScaleAdjust_Onset    = DATA_Retaliation.ScaleAdjustPunishment_OnsetTime(idx_Win);
    ScaleAdjust_Onset_correct =((ScaleAdjust_Onset - ScannerOnset(idx_Win))/1000) - 12;
    ScaleAdjust_Onset = ScaleAdjust_Onset_correct(ScaleAdjust_nonzeroidx);
    ScaleAdjust_Duration = ScaleAdjust_RTTime-ScaleAdjust_Onset;
    
    ScaleValue = DATA_Retaliation.ProcedureSubTrial(idx_Win);
    ScaleValue = ScaleValue(ScaleAdjust_nonzeroidx);
    
    idx_scaleVHigh = find(ismember(ScaleValue,{'Videofor5Response','Videofor4Response'}));
    idx_scaleVLow  = find(ismember(ScaleValue,{'Videofor1Response','Videofor2Response'}));
    
    ScaleAdjustHigh_Onset =  ScaleAdjust_Onset(idx_scaleVHigh);
    ScaleAdjustHigh_Duration = ScaleAdjust_Duration(idx_scaleVHigh);
    if isempty (ScaleAdjustHigh_Onset)
        ScaleAdjustHigh_Onset = 0;
        ScaleAdjustHigh_Duration = 0;
    end
    
    ScaleAdjustLow_Onset = ScaleAdjust_Onset(idx_scaleVLow);
    ScaleAdjustLow_Duration = ScaleAdjust_Duration(idx_scaleVLow);
    if isempty (ScaleAdjustLow_Onset)
        ScaleAdjustLow_Onset = 0;
        ScaleAdjustLow_Duration = 0;
    end
    %%
    idx_V1 = find(ismember(DATA_Retaliation.ProcedureSubTrial,{'Videofor1Response'}));
    idx_V2 = find(ismember(DATA_Retaliation.ProcedureSubTrial,{'Videofor2Response'}));
    idx_V4 = find(ismember(DATA_Retaliation.ProcedureSubTrial,{'Videofor4Response'}));
    idx_V5 = find(ismember(DATA_Retaliation.ProcedureSubTrial,{'Videofor5Response'}));
    V_High_Onset = [];
    V_Low_Onset = [];
    kk = 1;
    if ~isempty(idx_V1)
        if iscell(DATA_Retaliation.ShockVideo1_OnsetTime)
            V_Low_Onset(kk:kk+length(idx_V1)-1) = cellfun(@str2num,DATA_Retaliation.ShockVideo1_OnsetTime(idx_V1)); 
        else
            V_Low_Onset(kk:kk+length(idx_V1)-1) = DATA_Retaliation.ShockVideo1_OnsetTime(idx_V1); 
        end
        kk = kk+length(idx_V1);
    end
    if ~isempty(idx_V2)
        if iscell(DATA_Retaliation.ShockVideo2_OnsetTime)
            V_Low_Onset(kk:kk+length(idx_V2)-1) = cellfun(@str2num,DATA_Retaliation.ShockVideo2_OnsetTime(idx_V2));
        else
            V_Low_Onset(kk:kk+length(idx_V2)-1) = DATA_Retaliation.ShockVideo2_OnsetTime(idx_V2);
        end
    end
    
    
    kk =1;
    if ~isempty(idx_V4)
        if iscell(DATA_Retaliation.ShockVideo4_OnsetTime)
            V_High_Onset(kk:kk+length(idx_V4)-1) = cellfun(@str2num,DATA_Retaliation.ShockVideo4_OnsetTime(idx_V4));
        else
            V_High_Onset(kk:kk+length(idx_V4)-1) = DATA_Retaliation.ShockVideo4_OnsetTime(idx_V4);
        end
        
        kk = kk+length(idx_V4);
    end
    if ~isempty(idx_V5)
        if iscell(DATA_Retaliation.ShockVideo5_OnsetTime)
            V_High_Onset(kk:kk+length(idx_V5)-1) = cellfun(@str2num,DATA_Retaliation.ShockVideo5_OnsetTime(idx_V5));
        else
            V_High_Onset(kk:kk+length(idx_V5)-1) = DATA_Retaliation.ShockVideo5_OnsetTime(idx_V5);
        end
    end
    if ~isempty(V_High_Onset) 
        V_High_Onset = sort(V_High_Onset)';
        V_High_Onset = ((V_High_Onset(:) - ScannerOnset(1))/1000) - 12;
        V_High_Duration = 3*ones(size(V_High_Onset));
    else
        V_High_Onset = 0;
        V_High_Duration = 0;
    end
   
    if ~isempty(V_Low_Onset) 
        V_Low_Onset = sort(V_Low_Onset)';
        V_Low_Onset = ((V_Low_Onset(:) - ScannerOnset(1))/1000) - 12;
        V_Low_Duration = 3*ones(size(V_Low_Onset));
    else
        V_Low_Onset = 0;
        V_Low_Duration = 0;
    end

    onsets = cell(1,9);
    names = cell(1,9);
    durations = cell(1,9);

    onsets{1,1} = Task_Onset;
    onsets{1,2} = Smiley_Loss_Onset;
    onsets{1,3} = Smiley_Win_Onset;
    onsets{1,4} = Anticipation_High_Pain_Onset;
    onsets{1,5} = Anticipation_Low_Pain_Onset;
    onsets{1,6} = ScaleAdjustHigh_Onset;
    onsets{1,7} = ScaleAdjustLow_Onset;
    onsets{1,8} = V_High_Onset;
    onsets{1,9} = V_Low_Onset;

    
    durations{1,1} = Task_Duration;
    durations{1,2} = Smiley_Loss_Duration;
    durations{1,3} = Smiley_Win_Duration;
    durations{1,4} = Anticipation_High_Pain_Duration;
    durations{1,5} = Anticipation_Low_Pain_Duration;
    durations{1,6} = ScaleAdjustHigh_Duration;
    durations{1,7} = ScaleAdjustLow_Duration;
    durations{1,8} = V_High_Duration;
    durations{1,9} = V_Low_Duration;

    names{1,1} = 'Reaction_Time_Task';
    names{1,2} = 'Smiley_Loss';
    names{1,3} = 'Smiley_Win';
    names{1,4} = 'Anticipation_High';
    names{1,5} = 'Anticipation_Low';
    names{1,6} = 'Retaliation_High';
    names{1,7} = 'Retaliation_Low';
    names{1,8} = 'Watching_Opponent_High';
    names{1,9} = 'Watching_Opponent_Low';
    
    save([Current_File_name '.mat'],'onsets','durations','names');


    clearvars variables -except k listOfFileNames numberOfFiles

end