%% Export the data as "EPrime text "  -- Uncheck unicode

close all; clear all; clc;
DATA_ANT = read_edat_output_2008('ANT_selected.txt');
% ScannerOnset = zeros(size(DATA.FixStim_RTTime));
% ScannerOnset(:) =  DATA.FixStim_RTTime(1);
% 
% idx_MS1_OT = find(~strcmp(DATA.MixedStim1_OnsetTime, 'NULL'));
% idx_MS2_OT = find(~strcmp(DATA.MixedStim2_OnsetTime, 'NULL'));
idx_T1_ACC = find(~strcmp(DATA_ANT.Target1_ACC, 'NULL'));
idx_T2_ACC = find(~strcmp(DATA_ANT.Target2_ACC, 'NULL'));
idx_T3_ACC = find(~strcmp(DATA_ANT.Target3_ACC, 'NULL'));
idx_T4_ACC = find(~strcmp(DATA_ANT.Target4_ACC, 'NULL'));


% Switch = [DATA.MixedStim1_OnsetTime(idx_MS1_OT);DATA.MixedStim2_OnsetTime(idx_MS2_OT)];
Answers_ANT = [DATA_ANT.Target1_ACC(idx_T1_ACC(1:end))' DATA_ANT.Target2_ACC(idx_T2_ACC(1:end))' ...
    DATA_ANT.Target3_ACC(idx_T3_ACC(1:end))' DATA_ANT.Target4_ACC(idx_T4_ACC(1:end))'];
tot_ANT = 0;
for i = 1:length(Answers_ANT)
    tot_ANT = tot_ANT + str2double(cell2mat(Answers_ANT(i)));
end 

ANT_accuracy = tot_ANT/length(Answers_ANT);


DATA_STROOP = read_edat_output_2008('Stroop_selected.txt');
idx_Fixation_OnsetTime= find(~strcmp(DATA_STROOP.Fixation_OnsetTime, 'NULL'));
idx_TrialDisp_ACC = find(DATA_STROOP.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end));

Answers_STROOP = DATA_STROOP.TrialDisplay_ACC(idx_TrialDisp_ACC(1:end)+idx_Fixation_OnsetTime(1)-1)';
tot_STROOP = 0;
for i = 1:length(Answers_STROOP)
    tot_STROOP = tot_STROOP + Answers_STROOP(i);
end 
STROOP_accuracy = tot_STROOP/length(DATA_STROOP.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end));