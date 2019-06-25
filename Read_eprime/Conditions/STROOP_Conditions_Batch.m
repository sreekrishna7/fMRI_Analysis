close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
listOfFolderNames = textread('E:\BHS_Brain\MARCAP_EPRIME_files\eprime_filepaths.txt','%s'); 

numberOfFolders = length(listOfFolderNames);
for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.txt']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
   
    if (Num_of_files ~=0) 
        clear DATA_STROOP idx_Fixation_OnsetTime ScannerOnset
        
        DATA_STROOP = read_edat_output_2008('STROOP_full.txt');
        idx_Fixation_OnsetTime = find(~strcmp(DATA_STROOP.Fixation_OnsetTime, 'NULL'));
        ScannerOnset = DATA_STROOP.WaitForScanner_RTTime(idx_Fixation_OnsetTime);

        Onsets_STROOP  =  DATA_STROOP.TrialDisplay_OnsetTime(idx_Fixation_OnsetTime);
        if iscell(Onsets_STROOP)
            Onsets_STROOP_temp = zeros (length(Onsets_STROOP),1);
            for i = 1:length(Onsets_STROOP) 
                Onsets_STROOP_temp(i) = str2double(cell2mat(Onsets_STROOP(i)));
            end
            clear Onsets_STROOP;
            Onsets_STROOP = Onsets_STROOP_temp;
                
        end
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
        Conditions_filename  = [Current_Folder_name(1:11) '_STROOP.mat'];
        save(Conditions_filename,'onsets','durations','names');
%           delete('STROOP.mat');


    end
end