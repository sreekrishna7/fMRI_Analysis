%% Export the data as "EPrime text "  -- Uncheck unicode

close all; clear all; clc;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
DATA_ANT = read_edat_output_2008('ANT_ALL.txt');
ScannerOnset =DATA_ANT.WaitforScanner_RTTime;

idx_T1_ACC = find(~strcmp(DATA_ANT.Target1_ACC, 'NULL'));
idx_T2_ACC = find(~strcmp(DATA_ANT.Target2_ACC, 'NULL'));
idx_T3_ACC = find(~strcmp(DATA_ANT.Target3_ACC, 'NULL'));
idx_T4_ACC = find(~strcmp(DATA_ANT.Target4_ACC, 'NULL'));

Onsets_ANT = [DATA_ANT.CueType1_OnsetTime(idx_T1_ACC(1:end))' DATA_ANT.CueType2_OnsetTime(idx_T2_ACC(1:end))' ...
    DATA_ANT.CueType3_OnsetTime(idx_T3_ACC(1:end))' DATA_ANT.CueType4_OnsetTime(idx_T4_ACC(1:end))'];

EndTime_ANT = [DATA_ANT.Target1_RTTime(idx_T1_ACC(1:end))' DATA_ANT.Target2_RTTime(idx_T2_ACC(1:end))' ...
    DATA_ANT.Target3_RTTime(idx_T3_ACC(1:end))' DATA_ANT.Target4_RTTime(idx_T4_ACC(1:end))'];


Onsets_ANT_Corrected = zeros(size(Onsets_ANT)); 
Durations_ANT= zeros(size(Onsets_ANT));
for i = 1:length(Onsets_ANT)
    Onsets_ANT_Corrected(i) = str2double(cell2mat(Onsets_ANT(i))) - ScannerOnset(1);
    if str2double(cell2mat(EndTime_ANT(i))) == 0
        Durations_ANT(i) = 0;
    else
        Durations_ANT(i) = str2double(cell2mat(EndTime_ANT(i))) - str2double(cell2mat(Onsets_ANT(i)));
    end
end
Onsets_ANT_Corrected = (Onsets_ANT_Corrected'/1000) - 12; %Discard first Four Volumes
Durations_ANT = Durations_ANT'/1000;

idx_Congruent = find(strcmp(DATA_ANT.FlankerType(idx_T1_ACC(1):end), 'congruent'));
idx_Incongruent = find(strcmp(DATA_ANT.FlankerType(idx_T1_ACC(1):end), 'incongruent'));

Onsets_Congruent = Onsets_ANT_Corrected(idx_Congruent);
Onsets_Incongruent = Onsets_ANT_Corrected(idx_Incongruent);
Durations_Congruent = Durations_ANT(idx_Congruent);
Durations_Incongruent = Durations_ANT(idx_Incongruent);

onsets = cell(1,2);
names = cell(1,2);
durations = cell(1,2);

onsets{1,1} = Onsets_Congruent;
onsets{1,2} = Onsets_Incongruent;

durations{1,1} = Durations_Congruent;
durations{1,2} = Durations_Incongruent;

names{1,1} = 'Congruent';
names{1,2} = 'Incongruent';
save('ANT.mat','onsets','durations','names');

