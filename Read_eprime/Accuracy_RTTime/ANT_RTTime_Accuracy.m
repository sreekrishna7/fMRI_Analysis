%% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear;
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
xlsfilename = 'E:\MR_MAIN\MR_MAIN_ANT_RTTime_Accuracy.xlsx'; 
xlRange = 'A1';
ANT_stat_xlsx{1,1} = 'Subject_ID';    
ANT_stat_xlsx{1,2} = 'Date';        
ANT_stat_xlsx{1,3} = 'ANT_Congruent_RTTime'; 
ANT_stat_xlsx{1,4} = 'ANT_Incongruent_RTTime'; 
ANT_stat_xlsx{1,5} = 'ANT_Accuracy'; 
ANT_ind = 2; 
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
        clear DATA_ANT Eprime_ANT_Textfile;
        %% ANT
%         PPGdata = spm_select('List',pwd,'^PPGData');
        Eprime_ANT_Textfile = spm_select('List',pwd,['ANT_full.txt$']);
        if (~strcmp(Eprime_ANT_Textfile,''))
            DATA_ANT = read_edat_output_2008(Eprime_ANT_Textfile);
            idx_T1_RT = find(~strcmp(DATA_ANT.Target1_RT, 'NULL'));
            idx_T2_RT = find(~strcmp(DATA_ANT.Target2_RT, 'NULL'));
            idx_T3_RT = find(~strcmp(DATA_ANT.Target3_RT, 'NULL'));
            idx_T4_RT = find(~strcmp(DATA_ANT.Target4_RT, 'NULL'));
            RT_ANT  = [DATA_ANT.Target1_RT(idx_T1_RT(1:end))' DATA_ANT.Target2_RT(idx_T2_RT(1:end))' ...
                DATA_ANT.Target3_RT(idx_T3_RT(1:end))' DATA_ANT.Target4_RT(idx_T4_RT(1:end))'];
            if iscell(RT_ANT)
                RT_ANT_temp = zeros (length(RT_ANT),1);
                for i = 1:length(RT_ANT) 
                    RT_ANT_temp(i) = str2double(cell2mat(RT_ANT(i)));
                end
                clear RT_ANT;
                RT_ANT = RT_ANT_temp;
            end
            idx_RT = [idx_T1_RT ; idx_T2_RT ; idx_T3_RT ; idx_T4_RT];
            idx_Congruent   = find(strcmp(DATA_ANT.FlankerType(idx_RT), 'congruent'));
            idx_Incongruent = find(strcmp(DATA_ANT.FlankerType(idx_RT), 'incongruent'));
            
            RT_ANT_Congruent_full      = RT_ANT(idx_Congruent);
            RT_ANT_Congruent_nonzero   = RT_ANT_Congruent_full(RT_ANT_Congruent_full > 0) ;
            RT_ANT_Congruent_avg       = mean(RT_ANT_Congruent_nonzero);
            
            RT_ANT_Incongruent_full    = RT_ANT(idx_Incongruent);
            RT_ANT_Incongruent_nonzero = RT_ANT_Incongruent_full(RT_ANT_Incongruent_full > 0);
            RT_ANT_Incongruent_avg     = mean(RT_ANT_Incongruent_nonzero);
            %% Accuracy
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

%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
            ANT_stat_xlsx{ANT_ind,1} = Upper_Folder_name; %Subject ID
            ANT_stat_xlsx{ANT_ind,2} = Current_Folder_name;%Date
%             ANT_stat_xlsx{ANT_ind,1} = Current_Folder_name; %Subject ID
%             ANT_stat_xlsx{ANT_ind,2} = PPGdata(1,21:28);    %Date
            ANT_stat_xlsx{ANT_ind,3} = RT_ANT_Congruent_avg;
            ANT_stat_xlsx{ANT_ind,4} =  RT_ANT_Incongruent_avg ;
            ANT_stat_xlsx{ANT_ind,5} =  ANT_accuracy;
            ANT_ind = ANT_ind+1;
        end
    end
end
xlswrite(xlsfilename,ANT_stat_xlsx,'ANT',xlRange);