%% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear;
clc
format longg;
format compact;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
%% Inputs
%Run the windows_cmd_for_file_paths.txt
%dir /b /s /a:-D > results.txt
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Retaliation\ALL_text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\Retaliation\OPS_Retaliation_Ratings.xlsx'; 
xlRange = 'A1';
Retaliation_stat_xlsx{1,1} = 'Subject_ID';    
Retaliation_stat_xlsx{1,2} = 'Date';        
Retaliation_stat_xlsx{1,3} = 'Time_Point'; 
Retaliation_stat_xlsx{1,4} = 'B1_Anger_response'; 
Retaliation_stat_xlsx{1,5} = 'B1_Compassion_Response'; 
Retaliation_stat_xlsx{1,6} = 'B1_Sympathy_Response'; 
Retaliation_stat_xlsx{1,7} = 'B2_Anger_response'; 
Retaliation_stat_xlsx{1,8} = 'B2_Compassion_Response'; 
Retaliation_stat_xlsx{1,9} = 'B2_Sympathy_Response'; 

Retaliation_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k = [288]
%     if ismember(k,[28 37 54 55 56 61 62 76 78 105 106 117 118 146 158 185 199 200 207 209 222 227 230 251 255 258 262 269 288])
%         continue
%     end
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_Retaliation_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    DATA_Retaliation = read_edat_output_2008(thisFile);
    
    B1_Anger_keystrokes =num2str(DATA_Retaliation.ScaleAdjustAngerQuestion_RESP(1));
    B1_A_count=3;
    for i = 1:length(B1_Anger_keystrokes)
        if(strcmp(B1_Anger_keystrokes(i),'4'))
            B1_A_count   = B1_A_count+1;
        elseif (strcmp(B1_Anger_keystrokes(i),'1'))
            B1_A_count   = B1_A_count-1;
        end
        if B1_A_count == 0
            B1_A_count = 1;
        elseif B1_A_count == 6
            B1_A_count = 5;
        end
    end
    
    B2_Anger_keystrokes = num2str(DATA_Retaliation.ScaleAdjustAngerQuestion_RESP(21));
    B2_A_count=3;
    for i = 1:length(B2_Anger_keystrokes)
        if(strcmp(B2_Anger_keystrokes(i),'4'))
            B2_A_count   = B2_A_count+1;
        elseif (strcmp(B2_Anger_keystrokes(i),'1'))
            B2_A_count   = B2_A_count-1;
        end
        if B2_A_count == 0
            B2_A_count = 1;
        elseif B2_A_count == 6
            B2_A_count = 5;
        end
    end

    B1_Compassion_keystrokes = num2str(DATA_Retaliation.ScaleAdjustCompassionQuestion_RESP(1));
    B1_C_count=3;
    for i = 1:length(B1_Compassion_keystrokes)
        if(strcmp(B1_Compassion_keystrokes(i),'4'))
            B1_C_count   = B1_C_count+1;
        elseif (strcmp(B1_Compassion_keystrokes(i),'1'))
            B1_C_count   = B1_C_count-1;
        end
        if B1_C_count == 0
            B1_C_count = 1;
        elseif B1_C_count == 6
            B1_C_count = 5;
        end
    end

    
    B2_Compassion_keystrokes = num2str(DATA_Retaliation.ScaleAdjustCompassionQuestion_RESP(21)); 
    B2_C_count=3;
    for i = 1:length(B2_Compassion_keystrokes)
        if(strcmp(B2_Compassion_keystrokes(i),'4'))
            B2_C_count   = B2_C_count+1;
        elseif (strcmp(B2_Compassion_keystrokes(i),'1'))
            B2_C_count   = B2_C_count-1;
        end
        if B2_C_count == 0
            B2_C_count = 1;
        elseif B2_C_count == 6
            B2_C_count = 5;
        end
    end
    
    B1_Sympathy_keystrokes = num2str(DATA_Retaliation.ScaleAdjustSympathyQuestion_RESP(1));
    B1_S_count=3;
    for i = 1:length(B1_Sympathy_keystrokes)
        if(strcmp(B1_Sympathy_keystrokes(i),'4'))
            B1_S_count   = B1_S_count+1;
        elseif (strcmp(B1_Sympathy_keystrokes(i),'1'))
            B1_S_count   = B1_S_count-1;
        end
        if B1_S_count == 0
            B1_S_count = 1;
        elseif B1_S_count == 6
            B1_S_count = 5;
        end
    end

    B2_Sympathy_keystrokes = num2str(DATA_Retaliation.ScaleAdjustSympathyQuestion_RESP(21)); 
    B2_S_count=3;
    for i = 1:length(B2_Sympathy_keystrokes)
        if(strcmp(B2_Sympathy_keystrokes(i),'4'))
            B2_S_count   = B2_S_count+1;
        elseif (strcmp(B2_Sympathy_keystrokes(i),'1'))
            B2_S_count   = B2_S_count-1;
        end
        if B2_S_count == 0
            B2_S_count = 1;
        elseif B2_S_count == 6
            B2_S_count = 5;
        end
    end
    
   
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,1} = Current_File_name(1:11); %Subject ID
     Retaliation_stat_xlsx{Retaliation_ind,2} = [Current_File_name(17:20) Current_File_name(13:14) Current_File_name(15:16)];%Date
%       Retaliation_stat_xlsx{Retaliation_ind,1} = Current_Folder_name; %Subject ID
%       Retaliation_stat_xlsx{Retaliation_ind,2} = PPGdata(1,21:28);    %Date
     Retaliation_stat_xlsx{Retaliation_ind,3} = Current_File_name(34:38);
     Retaliation_stat_xlsx{Retaliation_ind,4} = B1_A_count;
     Retaliation_stat_xlsx{Retaliation_ind,5} = B1_C_count;
     Retaliation_stat_xlsx{Retaliation_ind,6} = B1_S_count;
     Retaliation_stat_xlsx{Retaliation_ind,7} = B2_A_count;
     Retaliation_stat_xlsx{Retaliation_ind,8} = B2_C_count;
     Retaliation_stat_xlsx{Retaliation_ind,9} = B2_S_count;
     Retaliation_ind = Retaliation_ind+1;
     clearvars variables -except k Retaliation_stat_xlsx Retaliation_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
% xlswrite(xlsfilename,Retaliation_stat_xlsx,'Retaliation',xlRange);