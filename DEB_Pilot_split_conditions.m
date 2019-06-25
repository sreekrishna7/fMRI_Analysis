close all;
clear;
clc
format longg;
format compact;
%Run the windows_cmd_for_file_paths.txt
listOfFileNames = textread('E:\ENS\Behavioural_Data\ENS_All_Conditions\SPM_Multiple_conditions\file_paths.txt','%s'); 
numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles

    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    Participant_ID = Current_File_name(1:11);
    Date = Current_File_name(13:20);
    DATA_DEB_Pilot_data = load(thisFile); 
   
    onsets    = [DATA_DEB_Pilot_data.onsets(1:6) DATA_DEB_Pilot_data.onsets(9)];
    names     = [DATA_DEB_Pilot_data.names(1:6) DATA_DEB_Pilot_data.names(9)];
    durations = [DATA_DEB_Pilot_data.durations(1:6) DATA_DEB_Pilot_data.durations(9)];
    save([Participant_ID '_' Date '_Maps_conditions' ],'onsets','durations','names');
    clear onsets names durations
    
    onsets    = DATA_DEB_Pilot_data.onsets(7:8);
    names     = DATA_DEB_Pilot_data.names(7:8);
    durations = DATA_DEB_Pilot_data.durations(7:8);
    save([Participant_ID '_' Date '_ED_conditions' ],'onsets','durations','names');
    clear onsets names durations
    
    onsets    = DATA_DEB_Pilot_data.onsets(10:11);
    names     = DATA_DEB_Pilot_data.names(10:11);
    durations = DATA_DEB_Pilot_data.durations(10:11);
    save([Participant_ID '_' Date '_Taste_conditions' ],'onsets','durations','names');
    clear onsets names durations

end