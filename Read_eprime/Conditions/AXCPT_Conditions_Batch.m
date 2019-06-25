close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\AXCPT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_AXCPT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_AXCPT = read_edat_output_2008(thisFile);
    ScannerOnset_cell =DATA_AXCPT.WaitForScanner_RTTime;
    idx_Cue = find(~strcmp(DATA_AXCPT.WaitForScanner_RTTime, 'NULL'));
    idx_Probe =idx_Cue; 
    ScannerOnset = str2double(cell2mat(ScannerOnset_cell(idx_Cue(1))));
   
    Fixation1Onset_cell =DATA_AXCPT.Fixation1_OnsetTime;
    idx_Fixation1 = find(~strcmp(DATA_AXCPT.Fixation1_OnsetTime, 'NULL'));
    Fixation1Onset = str2double(cell2mat(Fixation1Onset_cell(idx_Fixation1(1))));
    
    Fixation2Onset_cell =DATA_AXCPT.Fixation2_OnsetTime;
    idx_Fixation2 = find(~strcmp(DATA_AXCPT.Fixation2_OnsetTime, 'NULL'));
    Fixation2Onset = str2double(cell2mat(Fixation2Onset_cell(idx_Fixation2(1))));
    
    Fixation3Onset_cell =DATA_AXCPT.Fixation3_OnsetTime;
    idx_Fixation3 = find(~strcmp(DATA_AXCPT.Fixation3_OnsetTime, 'NULL'));
    Fixation3Onset = str2double(cell2mat(Fixation3Onset_cell(idx_Fixation3(1))));
    %%
 
    AXCPT_Cue_Acc = DATA_AXCPT.Cue_ACC(idx_Cue(1):end);
    AXCPT_Cue_Acc_mat = zeros(size(AXCPT_Cue_Acc));
    for i = 1:length(AXCPT_Cue_Acc)
        AXCPT_Cue_Acc_mat(i)  = str2double(cell2mat(AXCPT_Cue_Acc(i)));
    end

    
 %%__________
    AXCPT_Probe_Acc = DATA_AXCPT.Probe_ACC(idx_Probe(1):end);
    AXCPT_Probe_Acc_mat = zeros(size(AXCPT_Probe_Acc));
    for i = 1:length(AXCPT_Probe_Acc)
        AXCPT_Probe_Acc_mat(i)  = str2double(cell2mat(AXCPT_Probe_Acc(i)));
    end


    %%
    CueOnset = DATA_AXCPT.Cue_OnsetTime(idx_Cue(1):end);
    CueOnset = CueOnset(AXCPT_Cue_Acc_mat>0);
    ProbeOnset = DATA_AXCPT.Probe_OnsetTime(idx_Cue(1):end);
    ProbeOnset = ProbeOnset(AXCPT_Probe_Acc_mat>0);
    TrialOnset = DATA_AXCPT.Cue_OnsetTime(idx_Cue(1):end);
    TrialOnset = TrialOnset((AXCPT_Cue_Acc_mat>0)&(AXCPT_Probe_Acc_mat>0));
    TrialType = DATA_AXCPT.TrialType(idx_Cue(1):end);
    TrialType_forCues = TrialType(AXCPT_Cue_Acc_mat>0);
    TrialType_forProbes = TrialType(AXCPT_Probe_Acc_mat>0);
    TrialType_forTrials = TrialType((AXCPT_Cue_Acc_mat>0)&(AXCPT_Probe_Acc_mat>0));
    Cue_A_id  = find(ismember(TrialType_forCues,{'AX','AY'}));
    Cue_B_id  = find(ismember(TrialType_forCues,{'BX','BY'}));
    Probe_A_id  = find(ismember(TrialType_forProbes,{'AX','AY'}));
    Probe_B_id  = find(ismember(TrialType_forProbes,{'BX','BY'}));
    Trial_A_id  = find(ismember(TrialType_forTrials,{'AX','AY'}));
    Trial_B_id  = find(ismember(TrialType_forTrials,{'BX','BY'}));
   
    CueOnsets_A =  CueOnset(Cue_A_id);
    CueOnsets_B =  CueOnset(Cue_B_id);
    ProbeOnsets_A =  ProbeOnset(Probe_A_id);
    ProbeOnsets_B =  ProbeOnset(Probe_B_id);
    TrialOnsets_A =  TrialOnset(Trial_A_id);
    TrialOnsets_B =  TrialOnset(Trial_B_id);

    CueOnsets_A_Corrected = zeros(size(CueOnsets_A)); 
    CueOnsets_B_Corrected = zeros(size(CueOnsets_B)); 
    ProbeOnsets_A_Corrected = zeros(size(ProbeOnsets_A)); 
    ProbeOnsets_B_Corrected = zeros(size(ProbeOnsets_B)); 
    TrialOnsets_A_Corrected = zeros(size(TrialOnsets_A)); 
    TrialOnsets_B_Corrected = zeros(size(TrialOnsets_B)); 
   
    for i = 1:length(CueOnsets_A)
        CueOnsets_A_Corrected(i) = str2double(cell2mat(CueOnsets_A(i))) - ScannerOnset;
    end
    for i = 1:length(ProbeOnsets_A)
        ProbeOnsets_A_Corrected(i) = str2double(cell2mat(ProbeOnsets_A(i))) - ScannerOnset;
    end
    for i = 1:length(TrialOnsets_A)
        TrialOnsets_A_Corrected(i) = str2double(cell2mat(TrialOnsets_A(i))) - ScannerOnset;
    end   
    
    for i = 1:length(CueOnsets_B)
        CueOnsets_B_Corrected(i) = str2double(cell2mat(CueOnsets_B(i))) - ScannerOnset;
    end
    for i = 1:length(ProbeOnsets_B)
        ProbeOnsets_B_Corrected(i) = str2double(cell2mat(ProbeOnsets_B(i))) - ScannerOnset;
    end
    for i = 1:length(TrialOnsets_B)
        TrialOnsets_B_Corrected(i) = str2double(cell2mat(TrialOnsets_B(i))) - ScannerOnset;
    end
    CueOnsets_A_Corrected = (CueOnsets_A_Corrected'/1000) - 12; %Discard first Four Volumes
    CueOnsets_B_Corrected = (CueOnsets_B_Corrected'/1000) - 12; %Discard first Four Volumes
    ProbeOnsets_A_Corrected = (ProbeOnsets_A_Corrected'/1000) - 12; %Discard first Four Volumes
    ProbeOnsets_B_Corrected = (ProbeOnsets_B_Corrected'/1000) - 12; %Discard first Four Volumes
    TrialOnsets_A_Corrected = (TrialOnsets_A_Corrected'/1000) - 12; 
    TrialOnsets_B_Corrected = (TrialOnsets_B_Corrected'/1000) - 12;
    
    Fixation1Onset_Corrected = Fixation1Onset - ScannerOnset;
    Fixation2Onset_Corrected = Fixation2Onset - ScannerOnset;
    Fixation3Onset_Corrected = Fixation3Onset - ScannerOnset;
   
    Fixation1Onset_Corrected = (Fixation1Onset_Corrected/1000) -12;
    Fixation2Onset_Corrected = (Fixation2Onset_Corrected/1000) -12;
    Fixation3Onset_Corrected = (Fixation3Onset_Corrected/1000) -12;
    RestOnsets = [Fixation1Onset_Corrected;Fixation2Onset_Corrected;Fixation3Onset_Corrected];
    
    CueDuration_A = 1*ones(size(CueOnsets_A)); % CueDurations are one seconds each
    CueDuration_B = 1*ones(size(CueOnsets_B)); % CueDurations are one seconds each
    ProbeDuration_A = 0.5*ones(size(ProbeOnsets_A)); % ProbeDurations are 0.5 seconds each
    ProbeDuration_B = 0.5*ones(size(ProbeOnsets_B)); % ProbeDurations are 0.5 seconds each
    TrialDuration_A = 3.5*ones(size(TrialOnsets_A)); % TrialDurations are 3.5 seconds each
    TrialDuration_B = 3.5*ones(size(TrialOnsets_B)); % TrialDurations are 3.5 seconds each
    RestDuration = [30;30;30];


    onsets = cell(1,7);
    names = cell(1,7);
    durations = cell(1,7);

    onsets{1,1} = CueOnsets_A_Corrected;
    onsets{1,2} = CueOnsets_B_Corrected;
    onsets{1,3} = ProbeOnsets_A_Corrected;
    onsets{1,4} = ProbeOnsets_B_Corrected;
    onsets{1,5} = TrialOnsets_A_Corrected;
    onsets{1,6} = TrialOnsets_B_Corrected;
    onsets{1,7} = RestOnsets;
    
    durations{1,1} = CueDuration_A;
    durations{1,2} = CueDuration_B;
    durations{1,3} = ProbeDuration_A;
    durations{1,4} = ProbeDuration_B;
    durations{1,5} = TrialDuration_A;
    durations{1,6} = TrialDuration_B;
    durations{1,7} = RestDuration;

    names{1,1} = 'CueA';
    names{1,2} = 'CueB';
    names{1,3} = 'ProbeA';
    names{1,4} = 'ProbeB';
    names{1,5} = 'TrialA';
    names{1,6} = 'TrialB';
    names{1,7} = 'Rest';
    


    save([Current_File_name(1:21) 'AXCPT.mat'],'onsets','durations','names');


    clearvars variables -except k listOfFileNames numberOfFiles

end