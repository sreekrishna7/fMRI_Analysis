%% Export the data as "EPrime text "  -- Uncheck unicode

close all; clear all; clc;
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
    Durations_ANT(i) = str2double(cell2mat(EndTime_ANT(i))) - str2double(cell2mat(Onsets_ANT(i)));
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

%%
clear all;
DATA_STROOP = read_edat_output_2008('STROOP_full.txt');
idx_Fixation_OnsetTime = find(~strcmp(DATA_STROOP.Fixation_OnsetTime, 'NULL'));
ScannerOnset = DATA_STROOP.WaitForScanner_RTTime(idx_Fixation_OnsetTime);

Onsets_STROOP  =  DATA_STROOP.TrialDisplay_OnsetTime(idx_Fixation_OnsetTime);
% RTtime_STROOP  =  DATA_STROOP.TrialDisplay_RTTime(idx_Fixation_OnsetTime);


Onsets_STROOP_Corrected = Onsets_STROOP - ScannerOnset;
Onsets_STROOP_Corrected = (Onsets_STROOP_Corrected/1000) - 12;

% RTtime_STROOP_Corrected = RTtime_STROOP - ScannerOnset;
% RTtime_STROOP_Corrected = (RTtime_STROOP_Corrected/1000) - 12;%Some of these values may be -ve, therefore not used  

idx_Conlist   = find(strcmp(DATA_STROOP.RunningTrial(idx_Fixation_OnsetTime), 'ConList'));
idx_Inconlist = find(strcmp(DATA_STROOP.RunningTrial(idx_Fixation_OnsetTime), 'InconList'));

Onsets_Conlist_full   = Onsets_STROOP_Corrected(idx_Conlist);
Onsets_Conlist_full   = Onsets_Conlist_full(Onsets_Conlist_full >= 0) ;
Onsets_Inconlist_full = Onsets_STROOP_Corrected(idx_Inconlist);
Onsets_Inconlist_full = Onsets_Inconlist_full(Onsets_Inconlist_full >= 0);
k = 1;
Onsets_Conlist(k)  = Onsets_Conlist_full(1);
for i = 1:length(Onsets_Conlist_full)-1
    
    if((Onsets_Conlist_full(i+1)-Onsets_Conlist_full(i))>10)
        k= k+1;
        Onsets_Conlist(k) = Onsets_Conlist_full(i+1);
    end
end
Onsets_Conlist = Onsets_Conlist';

k = 1;
Onsets_Inconlist(k)  = Onsets_Inconlist_full(1);
for i = 1:length(Onsets_Inconlist_full)-1
    
    if((Onsets_Inconlist_full(i+1)-Onsets_Inconlist_full(i))>10)
        k= k+1;
        Onsets_Inconlist(k) = Onsets_Inconlist_full(i+1);
    end
end
Onsets_Inconlist = Onsets_Inconlist';

Durations_Conlist = repmat(55,length(Onsets_Conlist),1);
Durations_Inconlist = repmat(55,length(Onsets_Inconlist),1);


onsets{1,1} = Onsets_Conlist;
onsets{1,2} = Onsets_Inconlist;

durations{1,1} = Durations_Conlist;
durations{1,2} = Durations_Inconlist;

names{1,1} = 'Conlist';
names{1,2} = 'Inconlist';
save('STROOP.mat','onsets','durations','names');

