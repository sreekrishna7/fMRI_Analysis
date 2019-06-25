% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear all;
clc
format longg;
format compact;
%% Inputs
% Define a starting folder.
start_path = fullfile('OPS');% GIVE YOUR FOLDER NAME CONTAINING ALL PARTICIPANTS DATA
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
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\OPS_Task_Accuracy.xlsx'; 
xlRange = 'A1';
MSIT_stat_xlsx{1,1} = 'Subject_ID';    ANT_stat_xlsx{1,1} = 'Subject_ID';    AXCPT_stat_xlsx{1,1} = 'Subject_ID';     EMOTIONAL_REACTIVITY_stat_xlsx{1,1} = 'Subject_ID';
MSIT_stat_xlsx{1,2} = 'Date';          ANT_stat_xlsx{1,2} = 'Date';          AXCPT_stat_xlsx{1,2} = 'Date';           EMOTIONAL_REACTIVITY_stat_xlsx{1,2} = 'Date';
MSIT_stat_xlsx{1,3} = 'MSIT_Accuracy'; ANT_stat_xlsx{1,3} = 'ANT_Accuracy';  AXCPT_stat_xlsx{1,3} = 'AXCPT_Accuracy'; EMOTIONAL_REACTIVITY_stat_xlsx{1,3} = 'Emotional_Reactivity_Accuracy';

MSIT_ind = 2; ANT_ind = 2; AXCPT_ind = 2; EMOTIONAL_REACTIVITY_ind = 2;
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
        clear DATA_MSIT DATA_ANT DATA_AXCPT DATA_EMOTIONAL_REACTIVITY ...
           Eprime_MSIT_Textfile Eprime_ANT_Textfile Eprime_AXCPT_Textfile Eprime_EMOTIONAL_REACTIVITY_Textfile; 
        %% MSIT
        Eprime_MSIT_Textfile = spm_select('List',pwd,['MSIT_Full.txt$']);
        if (~strcmp(Eprime_MSIT_Textfile,''))
            DATA_MSIT = read_edat_output_2008(Eprime_MSIT_Textfile);
            idx_Fixation_OnsetTime= find(~strcmp(DATA_MSIT.Fixation_OnsetTime, 'NULL'));
            MSIT_Acc = DATA_MSIT.TrialDisplay_ACC(idx_Fixation_OnsetTime(1):end);
            tot_MSIT = sum(str2double(MSIT_Acc));
            MSIT_accuracy = tot_MSIT/length(MSIT_Acc);
            MSIT_stat_xlsx{MSIT_ind,1} = Upper_Folder_name;
            MSIT_stat_xlsx{MSIT_ind,2} = Current_Folder_name;
            MSIT_stat_xlsx{MSIT_ind,3} = MSIT_accuracy;
            MSIT_ind = MSIT_ind+1;
        end
        %% ANT
        Eprime_ANT_Textfile = spm_select('List',pwd,['ANT_Full.txt$']);
        if (~strcmp(Eprime_ANT_Textfile,''))
            DATA_ANT = read_edat_output_2008(Eprime_ANT_Textfile );
            idx_T1_ACC = find(~strcmp(DATA_ANT.Target1_ACC, 'NULL'));
            idx_T2_ACC = find(~strcmp(DATA_ANT.Target2_ACC, 'NULL'));
            idx_T3_ACC = find(~strcmp(DATA_ANT.Target3_ACC, 'NULL'));
            idx_T4_ACC = find(~strcmp(DATA_ANT.Target4_ACC, 'NULL'));
            Answers_ANT = [DATA_ANT.Target1_ACC(idx_T1_ACC(1:end))' DATA_ANT.Target2_ACC(idx_T2_ACC(1:end))' ...
                DATA_ANT.Target3_ACC(idx_T3_ACC(1:end))' DATA_ANT.Target4_ACC(idx_T4_ACC(1:end))'];
            tot_ANT = 0;
            for i = 1:length(Answers_ANT)
                tot_ANT = tot_ANT + str2double(cell2mat(Answers_ANT(i)));
            end 
            ANT_accuracy = tot_ANT/length(Answers_ANT);
            ANT_stat_xlsx{ANT_ind,1} = Upper_Folder_name;
            ANT_stat_xlsx{ANT_ind,2} = Current_Folder_name;
            ANT_stat_xlsx{ANT_ind,3} = ANT_accuracy;
            ANT_ind = ANT_ind+1;
        end
        %% AXCPT
        Eprime_AXCPT_Textfile = spm_select('List',pwd,['AXCPT_Full.txt$']);
        if (~strcmp(Eprime_AXCPT_Textfile,''))
            DATA_AXCPT = read_edat_output_2008(Eprime_AXCPT_Textfile);
            idx_Fixation1_OnsetTime= find(~strcmp(DATA_AXCPT.Fixation1_OnsetTime, 'NULL'));
            AXCPT_Acc = DATA_AXCPT.Probe_ACC(idx_Fixation1_OnsetTime(1):end);
            tot_AXCPT = sum(str2double(AXCPT_Acc));
            AXCPT_accuracy = tot_AXCPT/length(AXCPT_Acc);
            AXCPT_stat_xlsx{AXCPT_ind,1} = Upper_Folder_name;
            AXCPT_stat_xlsx{AXCPT_ind,2} = Current_Folder_name;
            AXCPT_stat_xlsx{AXCPT_ind,3} = AXCPT_accuracy;
            AXCPT_ind = AXCPT_ind+1;
        end
        %% EMOTIONAL_REACTIVITY
        Eprime_EMOTIONAL_REACTIVITY_Textfile = spm_select('List',pwd,['EmotionalReact_Full.txt$']);
        if (~strcmp(Eprime_EMOTIONAL_REACTIVITY_Textfile,''))
            DATA_EMOTIONAL_REACTIVITY = read_edat_output_2008(Eprime_EMOTIONAL_REACTIVITY_Textfile);
            idx_face_ACC = find(~strcmp(DATA_EMOTIONAL_REACTIVITY.FacesProcProbe_ACC, 'NULL'));
            idx_shape_ACC = find(~strcmp(DATA_EMOTIONAL_REACTIVITY.ShapesTrialProbe1_ACCTrial, 'NULL'));
            Answers_EMOTIONAL_REACTIVITY = [DATA_EMOTIONAL_REACTIVITY.FacesProcProbe_ACC(idx_face_ACC(1:end))' DATA_EMOTIONAL_REACTIVITY.ShapesTrialProbe1_ACCTrial(idx_shape_ACC(1:end))'];
            tot_EMOTIONAL_REACTIVITY = 0;
            for i = 1:length(Answers_EMOTIONAL_REACTIVITY)
                tot_EMOTIONAL_REACTIVITY = tot_EMOTIONAL_REACTIVITY + str2double(cell2mat(Answers_EMOTIONAL_REACTIVITY(i)));
            end 
            EMOTIONAL_REACTIVITY_accuracy = tot_EMOTIONAL_REACTIVITY/length(Answers_EMOTIONAL_REACTIVITY);
            EMOTIONAL_REACTIVITY_stat_xlsx{EMOTIONAL_REACTIVITY_ind,1} = Upper_Folder_name;
            EMOTIONAL_REACTIVITY_stat_xlsx{EMOTIONAL_REACTIVITY_ind,2} = Current_Folder_name;
            EMOTIONAL_REACTIVITY_stat_xlsx{EMOTIONAL_REACTIVITY_ind,3} = EMOTIONAL_REACTIVITY_accuracy;
            EMOTIONAL_REACTIVITY_ind = EMOTIONAL_REACTIVITY_ind+1;
        end
    end
end
xlswrite(xlsfilename,MSIT_stat_xlsx,'MSIT',xlRange);
xlswrite(xlsfilename,ANT_stat_xlsx,'ANT',xlRange);
xlswrite(xlsfilename,AXCPT_stat_xlsx,'AXCPT',xlRange);
xlswrite(xlsfilename,EMOTIONAL_REACTIVITY_stat_xlsx,'Emotional_Reactivity',xlRange);