close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Emotional_Reactivity\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_Emotional_Reactivity_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_Emotional_Reactivity = read_edat_output_2008(thisFile);
    idx = find(~strcmp(DATA_Emotional_Reactivity.Resting_OnsetTime, 'NULL'));
    ScannerOnset =DATA_Emotional_Reactivity.Resting_OnsetTime(idx);
    ScannerOnset = str2double(ScannerOnset(1));
    idx_Shapes   = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Shapes'));
    idx_Fear     = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Fear'));
    idx_Anger    = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Anger'));
    idx_Surprise = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Surprise'));
    idx_Neutral  = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Neutral'));
    
    Shapes_Acc   = cellfun(@str2num, DATA_Emotional_Reactivity.ShapesTrialProbe1_ACCTrial(idx_Shapes));
    Fear_Acc     = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Fear));
    Anger_Acc    = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Anger));
    Surprise_Acc = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Surprise));
    Neutral_Acc  = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Neutral));
    
    Shapes_Onsets   = ((cellfun(@str2num, DATA_Emotional_Reactivity.ShapesTrialProbe1_OnsetTimeTrial(idx_Shapes)) -  ScannerOnset)/1000) - 12;
    Shapes_Onsets   = Shapes_Onsets(Shapes_Acc>0); 
    Fear_Onsets     = ((cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_OnsetTime(idx_Fear)) - ScannerOnset)/1000) - 12;
    Fear_Onsets     = Fear_Onsets(Fear_Acc>0);
    Anger_Onsets    = ((cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_OnsetTime(idx_Anger)) - ScannerOnset)/1000) - 12;
    Anger_Onsets    = Anger_Onsets(Anger_Acc>0);
    Surprise_Onsets = ((cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_OnsetTime(idx_Surprise)) - ScannerOnset)/1000) - 12;
    Surprise_Onsets = Surprise_Onsets(Surprise_Acc>0);
    Neutral_Onsets  = ((cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_OnsetTime(idx_Neutral)) - ScannerOnset)/1000) - 12;
    Neutral_Onsets  = Neutral_Onsets(Neutral_Acc>0);

    Shapes_Durations   = (cellfun(@str2num, DATA_Emotional_Reactivity.ShapesTrialProbe1_RTTrial(idx_Shapes)))/1000;
    Shapes_Durations   = Shapes_Durations(Shapes_Acc>0); 
    Fear_Durations     = (cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Fear)))/1000;
    Fear_Durations     = Fear_Durations(Fear_Acc>0);
    Anger_Durations    = (cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Anger)))/1000;
    Anger_Durations    = Anger_Durations(Anger_Acc>0);
    Surprise_Durations = (cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Surprise)))/1000;
    Surprise_Durations = Surprise_Durations(Surprise_Acc>0);
    Neutral_Durations  = (cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Neutral)))/1000;
    Neutral_Durations  = Neutral_Durations(Neutral_Acc>0);




    onsets = cell(1,5);
    names = cell(1,5);
    durations = cell(1,5);

    onsets{1,1} = Shapes_Onsets;
    onsets{1,2} = Fear_Onsets;
    onsets{1,3} = Anger_Onsets;
    onsets{1,4} = Surprise_Onsets;
    onsets{1,5} = Neutral_Onsets;
    
    durations{1,1} = Shapes_Durations;
    durations{1,2} = Fear_Durations;
    durations{1,3} = Anger_Durations;
    durations{1,4} = Surprise_Durations;
    durations{1,5} = Neutral_Durations;

    names{1,1} = 'Shapes';
    names{1,2} = 'Fear';
    names{1,3} = 'Anger';
    names{1,4} = 'Surprise';
    names{1,5} = 'Neutral';
    
    save(['A00-06-6899_20160924_Emotional_Reactivity.mat'],'onsets','durations','names');


    clearvars variables -except k listOfFileNames numberOfFiles

end