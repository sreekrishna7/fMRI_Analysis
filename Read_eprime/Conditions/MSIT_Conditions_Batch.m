close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\MSIT\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_MSIT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_MSIT = read_edat_output_2008(thisFile);
    ScannerOnset =DATA_MSIT.WaitforScanner1_RTTime;

    idx = find(~strcmp(DATA_MSIT.TrialDisplay_RTTime, 'NULL'));

    idx_Fixation_OnsetTime= find(~strcmp(DATA_MSIT.Fixation_OnsetTime, 'NULL'));
    MSIT_Acc = DATA_MSIT.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end);
    MSIT_Acc_mat = zeros(size(MSIT_Acc));
    for i = 1:length(MSIT_Acc)
        MSIT_Acc_mat(i)  = str2double(cell2mat(MSIT_Acc(i)));
    end
    Onsets_MSIT = DATA_MSIT.TrialDisplay_OnsetTime(idx);
    Onsets_MSIT =Onsets_MSIT(MSIT_Acc_mat>0);
    EndTime_MSIT = DATA_MSIT.TrialDisplay_RTTime(idx);
    EndTime_MSIT = EndTime_MSIT(MSIT_Acc_mat>0);

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

    RunningSubTrial = DATA_MSIT.RunningSubTrial(idx(1):end);
    RunningSubTrial = RunningSubTrial((MSIT_Acc_mat>0));
    idx_ConList= find(strncmp(RunningSubTrial, 'ConList', length('ConList')));
    idx_InconList= find(strncmp(RunningSubTrial, 'InconList', length('InconList')));

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
    save([Current_File_name(1:21) 'MSIT.mat'],'onsets','durations','names');


    clearvars variables -except k listOfFileNames numberOfFiles

end