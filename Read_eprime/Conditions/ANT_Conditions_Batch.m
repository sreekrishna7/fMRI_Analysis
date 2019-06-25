close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\ANT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_ANT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_ANT = read_edat_output_2008(thisFile);
    ScannerOnset =DATA_ANT.WaitforScanner_RTTime;

    idx_T1_ACC = find(~strcmp(DATA_ANT.Target1_ACC, 'NULL'));
    idx_T2_ACC = find(~strcmp(DATA_ANT.Target2_ACC, 'NULL'));
    idx_T3_ACC = find(~strcmp(DATA_ANT.Target3_ACC, 'NULL'));
    idx_T4_ACC = find(~strcmp(DATA_ANT.Target4_ACC, 'NULL'));
    %%
     
     Answers_ANT = [DATA_ANT.Target1_ACC(idx_T1_ACC(1:end))' DATA_ANT.Target2_ACC(idx_T2_ACC(1:end))' ...
         DATA_ANT.Target3_ACC(idx_T3_ACC(1:end))' DATA_ANT.Target4_ACC(idx_T4_ACC(1:end))'];
     Answers_ANT_mat = zeros(size(Answers_ANT));
     for i = 1:length(Answers_ANT)
        Answers_ANT_mat(i)  = str2double(cell2mat(Answers_ANT(i)));
     end

    CueOnsets_ANT = [DATA_ANT.CueType1_OnsetTime(idx_T1_ACC(1:end))' DATA_ANT.CueType2_OnsetTime(idx_T2_ACC(1:end))' ...
        DATA_ANT.CueType3_OnsetTime(idx_T3_ACC(1:end))' DATA_ANT.CueType4_OnsetTime(idx_T4_ACC(1:end))'];
    CueOnsets_ANT = CueOnsets_ANT(Answers_ANT_mat>0);
    
    TargetOnsets_ANT = [DATA_ANT.Target1_OnsetTime(idx_T1_ACC(1:end))' DATA_ANT.Target2_OnsetTime(idx_T2_ACC(1:end))' ...
        DATA_ANT.Target3_OnsetTime(idx_T3_ACC(1:end))' DATA_ANT.Target4_OnsetTime(idx_T4_ACC(1:end))'];
    TargetOnsets_ANT = TargetOnsets_ANT(Answers_ANT_mat>0);
    
    EndTime_ANT = [DATA_ANT.Target1_RTTime(idx_T1_ACC(1:end))' DATA_ANT.Target2_RTTime(idx_T2_ACC(1:end))' ...
        DATA_ANT.Target3_RTTime(idx_T3_ACC(1:end))' DATA_ANT.Target4_RTTime(idx_T4_ACC(1:end))'];
   EndTime_ANT = EndTime_ANT(Answers_ANT_mat>0);
    
    IntervalOnsets_ANT = [DATA_ANT.IntertrialInterval1_OnsetTime(idx_T1_ACC(1:end))' DATA_ANT.IntertrialInterval2_OnsetTime(idx_T2_ACC(1:end))' ...
        DATA_ANT.IntertrialInterval3_OnsetTime(idx_T3_ACC(1:end))' DATA_ANT.IntertrialInterval4_OnsetTime(idx_T4_ACC(1:end))'];
    IntervalOnsets_ANT = IntervalOnsets_ANT(Answers_ANT_mat>0);
    
    IntervalDurations_ANT_cell = [DATA_ANT.IntertrialInterval1_Duration(idx_T1_ACC(1:end))' DATA_ANT.IntertrialInterval2_Duration(idx_T2_ACC(1:end))' ...
        DATA_ANT.IntertrialInterval3_Duration(idx_T3_ACC(1:end))' DATA_ANT.IntertrialInterval4_Duration(idx_T4_ACC(1:end))'];
    IntervalDurations_ANT_cell = IntervalDurations_ANT_cell(Answers_ANT_mat>0);


    CueOnsets_ANT_Corrected = zeros(size(CueOnsets_ANT)); 
    TargetOnsets_ANT_Corrected = zeros(size(TargetOnsets_ANT)); 
    IntervalOnsets_ANT_Corrected = zeros(size(IntervalOnsets_ANT));
    TrialDurations_ANT= zeros(size(CueOnsets_ANT));
    TargetDurations_ANT= zeros(size(TargetOnsets_ANT));
    IntervalDurations_ANT= zeros(size(IntervalOnsets_ANT));
    
    for i = 1:length(CueOnsets_ANT)
        CueOnsets_ANT_Corrected(i) = str2double(cell2mat(CueOnsets_ANT(i))) - ScannerOnset(1);
        TargetOnsets_ANT_Corrected(i) = str2double(cell2mat(TargetOnsets_ANT(i))) - ScannerOnset(1);
        IntervalOnsets_ANT_Corrected(i) = str2double(cell2mat(IntervalOnsets_ANT(i))) - ScannerOnset(1);
        if str2double(cell2mat(EndTime_ANT(i))) == 0
            TrialDurations_ANT(i) = 0;
            TargetDurations_ANT(i) = 0;
        else
            TrialDurations_ANT(i) = str2double(cell2mat(EndTime_ANT(i))) - str2double(cell2mat(CueOnsets_ANT(i)));
            TargetDurations_ANT(i) = str2double(cell2mat(EndTime_ANT(i))) - str2double(cell2mat(TargetOnsets_ANT(i)));
        end
        IntervalDurations_ANT(i) = str2double(cell2mat(IntervalDurations_ANT_cell(i)));
    end
    CueOnsets_ANT_Corrected = (CueOnsets_ANT_Corrected'/1000) - 12; %Discard first Four Volumes
    TargetOnsets_ANT_Corrected = (TargetOnsets_ANT_Corrected'/1000) - 12; %Discard first Four Volumes
    IntervalOnsets_ANT_Corrected = (IntervalOnsets_ANT_Corrected'/1000) - 12; %Discard first Four Volumes
    TrialDurations_ANT = TrialDurations_ANT'/1000;
    TargetDurations_ANT = TargetDurations_ANT'/1000;
    IntervalDurations_ANT = IntervalDurations_ANT'/1000;
    
    idx_T = [idx_T1_ACC ; idx_T2_ACC ; idx_T3_ACC ; idx_T4_ACC];
    FlankerType = DATA_ANT.FlankerType(idx_T);
    FlankerType = FlankerType(Answers_ANT_mat>0);
    idx_Congruent = find(strcmp(FlankerType, 'congruent'));
    idx_Incongruent = find(strcmp(FlankerType, 'incongruent'));
    
    CueState  = DATA_ANT.CueState(idx_T);
    CueState = CueState(Answers_ANT_mat>0);
    idx_no_cue   = find(strcmp(CueState, 'no'));
    idx_centre_cue   = find(strcmp(CueState, 'both'));
    idx_spatial_cue = find(ismember(CueState, {'cueup', 'cuedown'}));
    
    TrialOnsets_Congruent    = CueOnsets_ANT_Corrected(idx_Congruent);
    TrialOnsets_Incongruent  = CueOnsets_ANT_Corrected(idx_Incongruent);
    TrialOnsets_no_cue       = CueOnsets_ANT_Corrected(idx_no_cue);
    TrialOnsets_centre_cue   = CueOnsets_ANT_Corrected(idx_centre_cue);
    TrialOnsets_spatial_cue  = CueOnsets_ANT_Corrected(idx_spatial_cue);
    TargetOnsets_Congruent   = TargetOnsets_ANT_Corrected(idx_Congruent);
    TargetOnsets_Incongruent = TargetOnsets_ANT_Corrected(idx_Incongruent);
    TargetOnsets_no_cue      = TargetOnsets_ANT_Corrected(idx_no_cue);
    TargetOnsets_centre_cue  = TargetOnsets_ANT_Corrected(idx_centre_cue);
    TargetOnsets_spatial_cue = TargetOnsets_ANT_Corrected(idx_spatial_cue);
    TargetOnsets_all         = TargetOnsets_ANT_Corrected;
    IntervalOnsets_all       = IntervalOnsets_ANT_Corrected;
    
    TrialDurations_Congruent    = TrialDurations_ANT(idx_Congruent);
    TrialDurations_Incongruent  = TrialDurations_ANT(idx_Incongruent);
    TrialDurations_no_cue       = TrialDurations_ANT(idx_no_cue );
    TrialDurations_centre_cue   = TrialDurations_ANT(idx_centre_cue);
    TrialDurations_spatial_cue  = TrialDurations_ANT(idx_spatial_cue);
    TargetDurations_Congruent   = TargetDurations_ANT(idx_Congruent);
    TargetDurations_Incongruent = TargetDurations_ANT(idx_Incongruent);
    TargetDurations_no_cue      = TargetDurations_ANT(idx_no_cue );
    TargetDurations_centre_cue  = TargetDurations_ANT(idx_centre_cue);
    TargetDurations_spatial_cue = TargetDurations_ANT(idx_spatial_cue);
    TargetDurations_all         = TargetDurations_ANT;
    IntervalDurations_all       = IntervalDurations_ANT;

    onsets = cell(1,12);
    names = cell(1,12);
    durations = cell(1,12);

    onsets{1,1} = TrialOnsets_Congruent;
    onsets{1,2} = TrialOnsets_Incongruent;
    onsets{1,3} = TrialOnsets_no_cue;
    onsets{1,4} = TrialOnsets_centre_cue;
    onsets{1,5} = TrialOnsets_spatial_cue;
    onsets{1,6} = TargetOnsets_Congruent;
    onsets{1,7} = TargetOnsets_Incongruent;
    onsets{1,8} = TargetOnsets_no_cue;
    onsets{1,9} = TargetOnsets_centre_cue;
    onsets{1,10} = TargetOnsets_spatial_cue;
    onsets{1,11} = TargetOnsets_all;
    onsets{1,12} = IntervalOnsets_all;
          
         

    durations{1,1} = TrialDurations_Congruent;
    durations{1,2} = TrialDurations_Incongruent;
    durations{1,3} = TrialDurations_no_cue;
    durations{1,4} = TrialDurations_centre_cue;
    durations{1,5} = TrialDurations_spatial_cue;
    durations{1,6} = TargetDurations_Congruent;
    durations{1,7} = TargetDurations_Incongruent;
    durations{1,8} = TargetDurations_no_cue;
    durations{1,9} = TargetDurations_centre_cue;
    durations{1,10} = TargetDurations_spatial_cue;
    durations{1,11} = TargetDurations_all;
    durations{1,12} = IntervalDurations_all;  
         


    names{1,1} = 'TrialCongruent';
    names{1,2} = 'TrialIncongruent';
    names{1,3} = 'TrialNo_cue';
    names{1,4} = 'TrialCentre_cue';
    names{1,5} = 'TrialSpatial_cue';
    names{1,6} = 'TargetCongruent';
    names{1,7} = 'TargetIncongruent';
    names{1,8} = 'TargetNo_cue';
    names{1,9} = 'TargetCentre_cue';
    names{1,10} = 'TargetSpatial_cue';
    names{1,11} = 'TargetAll';
    names{1,12} = 'IntervalALL';
  
    save([Current_File_name(1:21) 'ANT.mat'],'onsets','durations','names');


    clearvars variables -except k listOfFileNames numberOfFiles

end