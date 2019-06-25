%% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear all;
clc
format longg;
format compact;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
%% Inputs
% Define a starting folder.
start_path = fullfile('MR_MAIN_EPRIME_files');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
%% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0	
    return;    
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);
%% Output Excel Sheet
xlsfilename = 'E:\MR_MAIN\MR_MAIN_STROOP_RTTime_Accuracy.xlsx'; 
xlRange = 'A1';
STROOP_stat_xlsx{1,1} = 'Subject_ID';    
STROOP_stat_xlsx{1,2} = 'Date';        
STROOP_stat_xlsx{1,3} = 'STROOP_ConList_RTTime'; 
STROOP_stat_xlsx{1,4} = 'STROOP_InconList_RTTime'; 
STROOP_stat_xlsx{1,5} = 'STROOP_Accuracy'; 
STROOP_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  2 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.txt']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    if (Num_of_files ~=0) 
        clear DATA_STROOP Eprime_STROOP_Textfile;
        %% STROOP
%         PPGdata = spm_select('List',pwd,'^PPGTrig');
        Eprime_STROOP_Textfile = spm_select('List',pwd,['STROOP_full.txt$']);
        if (~strcmp(Eprime_STROOP_Textfile,''))
            DATA_STROOP = read_edat_output_2008(Eprime_STROOP_Textfile);
            idx_Fixation_OnsetTime= find(~strcmp(DATA_STROOP.Fixation_OnsetTime, 'NULL'));
            RT_STROOP  =  DATA_STROOP.TrialDisplay_RT(idx_Fixation_OnsetTime);
            if iscell(RT_STROOP)
                RT_STROOP_temp = zeros (length(RT_STROOP),1);
                for i = 1:length(RT_STROOP) 
                    RT_STROOP_temp(i) = str2double(cell2mat(RT_STROOP(i)));
                end
                clear RT_STROOP;
                RT_STROOP = RT_STROOP_temp;
            end
        
            idx_Conlist   = find(strcmp(DATA_STROOP.RunningTrial(idx_Fixation_OnsetTime), 'ConList'));
            idx_Inconlist = find(strcmp(DATA_STROOP.RunningTrial(idx_Fixation_OnsetTime), 'InconList'));
            
            RT_STROOP_Conlist_full      = RT_STROOP(idx_Conlist);
            RT_STROOP_Conlist_nonzero   = RT_STROOP_Conlist_full(RT_STROOP_Conlist_full > 0) ;
            RT_STROOP_Conlist_avg       = mean(RT_STROOP_Conlist_nonzero);
            
            RT_STROOP_Inconlist_full    = RT_STROOP(idx_Inconlist);
            RT_STROOP_Inconlist_nonzero = RT_STROOP_Inconlist_full(RT_STROOP_Inconlist_full > 0);
            RT_STROOP_Inconlist_avg     = mean(RT_STROOP_Inconlist_nonzero);
            %% Accuracy 
            if iscell(DATA_STROOP.TrialDisplay_ACC)
                tot_STROOP = 0;
                for i = idx_Fixation_OnsetTime(1):idx_Fixation_OnsetTime(end)
                    tot_STROOP = tot_STROOP + str2double(cell2mat(DATA_STROOP.TrialDisplay_ACC(i)));
                end
                STROOP_accuracy = tot_STROOP/length(DATA_STROOP.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end));
            end
            if ~iscell(DATA_STROOP.TrialDisplay_ACC)
                idx_TrialDisp_ACC = find(DATA_STROOP.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end));
                Answers_STROOP = DATA_STROOP.TrialDisplay_ACC(idx_TrialDisp_ACC(1:end)+idx_Fixation_OnsetTime(1)-1)';
                tot_STROOP = 0;
                for i = 1:length(Answers_STROOP)
                    tot_STROOP = tot_STROOP + Answers_STROOP(i);
                end 
                STROOP_accuracy = tot_STROOP/length(DATA_STROOP.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end));
            end
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
            STROOP_stat_xlsx{STROOP_ind,1} = Upper_Folder_name; %Subject ID
            STROOP_stat_xlsx{STROOP_ind,2} = Current_Folder_name;%Date
%             STROOP_stat_xlsx{STROOP_ind,1} = Current_Folder_name; %Subject ID
%             STROOP_stat_xlsx{STROOP_ind,2} = PPGdata(1,21:28);    %Date
            STROOP_stat_xlsx{STROOP_ind,3} = RT_STROOP_Conlist_avg;
            STROOP_stat_xlsx{STROOP_ind,4} =  RT_STROOP_Inconlist_avg ;
            STROOP_stat_xlsx{STROOP_ind,5} =  STROOP_accuracy;
            STROOP_ind = STROOP_ind+1;
        end
    end
end
xlswrite(xlsfilename,STROOP_stat_xlsx,'STROOP',xlRange);
