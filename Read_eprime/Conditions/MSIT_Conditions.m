%% Export the data as "EPrime text "  -- Uncheck unicode
close all; clear all; clc;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
DATA_MSIT = read_edat_output_2008('MSIT_Full.txt');
ScannerOnset =DATA_MSIT.WaitforScanner1_RTTime;

idx = find(~strcmp(DATA_MSIT.TrialDisplay_RTTime, 'NULL'));


Onsets_MSIT = DATA_MSIT.TrialDisplay_OnsetTime(idx);

EndTime_MSIT = DATA_MSIT.TrialDisplay_RTTime(idx);


Onsets_MSIT_Corrected = zeros(size(Onsets_MSIT)); 
Durations_MSIT= zeros(size(Onsets_MSIT));
for i = 1:length(Onsets_MSIT)
    Onsets_MSIT_Corrected(i) = str2double(cell2mat(Onsets_MSIT(i))) - ScannerOnset(1);
    if str2double(cell2mat(EndTime_MSIT(i))) == 0
        Durations_MSIT(i) = 0;
    else
        Durations_MSIT(i) = str2double(cell2mat(EndTime_MSIT(i))) - str2double(cell2mat(Onsets_MSIT(i)));
    end
end
Onsets_MSIT_Corrected = (Onsets_MSIT_Corrected'/1000) - 12; %Discard first Four Volumes
Durations_MSIT = Durations_MSIT'/1000;


idx_ConList= find(strncmp(DATA_MSIT.RunningSubTrial(idx(1):end), 'ConList', length('ConList')));
idx_InconList= find(strncmp(DATA_MSIT.RunningSubTrial(idx(1):end), 'InconList', length('InconList')));

Onsets_ConList = Onsets_MSIT_Corrected(idx_ConList)';
Onsets_InconList = Onsets_MSIT_Corrected(idx_InconList)';
Durations_ConList = Durations_MSIT(idx_ConList)';
Durations_InconList = Durations_MSIT(idx_InconList)';

onsets = cell(1,2);
names = cell(1,2);
durations = cell(1,2);

onsets{1,1} = Onsets_ConList;
onsets{1,2} = Onsets_InconList;

durations{1,1} = Durations_ConList;
durations{1,2} = Durations_InconList;

names{1,1} = 'ConList';
names{1,2} = 'InconList';
save('MSIT.mat','onsets','durations','names');

