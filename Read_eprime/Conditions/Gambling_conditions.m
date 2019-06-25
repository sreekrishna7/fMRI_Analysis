clear; close all; clc;
%% input a list of .dat behavioural data (eg: OPS Gambling)
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Gambling\files.txt','%s'); 
numberOfFiles = length(listOfFileNames);

for k = 1 : numberOfFiles  %*****************************CHANGE*************

    thisFile = listOfFileNames{k};
    fid = fopen(thisFile,'r');
    formatSpec = '%s';
    N = 10000; %Random High Number to read all Rows
    N_c = 22;  % Number of columns in the behavioural file
    C_text = textscan(fid,formatSpec,N_c,'Delimiter','\t')';
    C_data = textscan(fid,repmat(formatSpec,[1,22]) ,N,'headerlines',1,'delimiter','\t');
    size_C_data = size(C_data{1},1);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    Date = [Current_File_name(17:20) '-' Current_File_name(13:14) '-' Current_File_name(15:16)];
    Participant_ID = Current_File_name(1:11);
    
    idxC_date  = strfind(C_data{7},Date);    
    idx_date= find(not(cellfun('isempty', idxC_date)));
    for i = 1:N_c
        B1_data{i} =  C_data{i}(idx_date(1):idx_date(2)-1);
        B2_data{i} = C_data{i}(idx_date(2):size_C_data);
    end
%     full_data = cell2struct(C_data,C_text{1},2); % Creating  structure from the cell data
  
    idxC_CardSelected_B1  = strfind(B1_data{13},'CardSelected');    
    idx_WaitForSelect_Enter_B1= find(not(cellfun('isempty', idxC_CardSelected_B1)))-1;
    B1_Choice_Onsets = B1_data{12}(idx_WaitForSelect_Enter_B1);
%     idxC_WaitForSelect_Leave_B1  = strfind(B1_data{13},'WaitForSelect_Leave');    
%     idx_WaitForSelect_Leave_B1= find(not(cellfun('isempty', idxC_WaitForSelect_Leave_B1)));
%     B1_Choice_Ends = B1_data{12}(idx_WaitForSelect_Leave_B1);
%     B1_Choice_Duration = cellfun(@str2num,B1_Choice_Ends) - cellfun(@str2num,B1_Choice_Onsets) ;
    B1_Choice_Duration = repmat(4,size(B1_Choice_Onsets));
    idxC_DisplaySelectionResult_Enter_B1  = strfind(B1_data{13},'DisplaySelectionResult_Enter');    
    idx_DisplaySelectionResult_Enter_B1= find(not(cellfun('isempty', idxC_DisplaySelectionResult_Enter_B1)));
%     idxC_StateDisplayFollowers_Leave_B1  = strfind(B1_data{13},'StateDisplayFollowers_Leave');    
%     idx_StateDisplayFollowers_Leave_B1= find(not(cellfun('isempty', idxC_StateDisplayFollowers_Leave_B1)));
    B1_Feed_Back_Onsets = B1_data{12}(idx_DisplaySelectionResult_Enter_B1);
%     B1_Feed_Back_Ends = B1_data{12}(idx_StateDisplayFollowers_Leave_B1);
    B1_Feed_Back_Duration = repmat(4,size(B1_Feed_Back_Onsets));
    
    idxC_CardSelected_B2  = strfind(B2_data{13},'CardSelected');    
    idx_WaitForSelect_Enter_B2= find(not(cellfun('isempty', idxC_CardSelected_B2)))-1;
    B2_Choice_Onsets = B2_data{12}(idx_WaitForSelect_Enter_B2);
%     idxC_WaitForSelect_Leave_B2  = strfind(B2_data{13},'WaitForSelect_Leave');    
%     idx_WaitForSelect_Leave_B2= find(not(cellfun('isempty', idxC_WaitForSelect_Leave_B2)));
%     B2_Choice_Ends = B2_data{12}(idx_WaitForSelect_Leave_B2);
%     B2_Choice_Duration = cellfun(@str2num,B2_Choice_Ends) - cellfun(@str2num,B2_Choice_Onsets) ;
    B2_Choice_Duration = repmat(4,size(B2_Choice_Onsets));

    idxC_DisplaySelectionResult_Enter_B2  = strfind(B2_data{13},'DisplaySelectionResult_Enter');    
    idx_DisplaySelectionResult_Enter_B2= find(not(cellfun('isempty', idxC_DisplaySelectionResult_Enter_B2)));
%     idxC_StateDisplayFollowers_Leave_B2  = strfind(B2_data{13},'StateDisplayFollowers_Leave');    
%     idx_StateDisplayFollowers_Leave_B2= find(not(cellfun('isempty', idxC_StateDisplayFollowers_Leave_B2)));
    B2_Feed_Back_Onsets = B2_data{12}(idx_DisplaySelectionResult_Enter_B2);
%     B2_Feed_Back_Ends = B2_data{12}(idx_StateDisplayFollowers_Leave_B2);
    B2_Feed_Back_Duration = repmat(4,size(B2_Feed_Back_Onsets));

    B1_name = cell2mat(B1_data{8}(1));
    B1_name = B1_name(1:4);
    B2_name = cell2mat(B2_data{8}(1));
    B2_name = B2_name(1:4);
    if(strcmp(B1_name, 'life') && strcmp(B2_name, 'cash'))
        Life_Choice_Onsets   = B1_Choice_Onsets;
        Life_Choice_Duration = B1_Choice_Duration;
        Cash_Choice_Onsets   = B2_Choice_Onsets;
        Cash_Choice_Duration = B2_Choice_Duration;
        Life_Feed_Back_Onsets   = B1_Feed_Back_Onsets;
        Life_Feed_Back_Duration = B1_Feed_Back_Duration;
        Cash_Feed_Back_Onsets   = B2_Feed_Back_Onsets;
        Cash_Feed_Back_Duration = B2_Feed_Back_Duration;
    elseif(strcmp(B1_name, 'cash') && strcmp(B2_name, 'life'))
        Life_Choice_Onsets   = B2_Choice_Onsets;
        Life_Choice_Duration = B2_Choice_Duration;
        Cash_Choice_Onsets   = B1_Choice_Onsets;
        Cash_Choice_Duration = B1_Choice_Duration;
        Life_Feed_Back_Onsets   = B2_Feed_Back_Onsets;
        Life_Feed_Back_Duration = B2_Feed_Back_Duration;
        Cash_Feed_Back_Onsets   = B1_Feed_Back_Onsets;
        Cash_Feed_Back_Duration = B1_Feed_Back_Duration;
    end
    onsets1 = cell(1,4);
    names1 = cell(1,4);
    durations1 = cell(1,4);

    onsets{1,1} = Life_Choice_Onsets;
    onsets{1,2} = Life_Feed_Back_Onsets;
    onsets{1,3} = Cash_Choice_Onsets;
    onsets{1,4} = Cash_Feed_Back_Onsets;

    durations{1,1} = Life_Choice_Duration;
    durations{1,2} = Life_Feed_Back_Duration;
    durations{1,3} = Cash_Choice_Duration;
    durations{1,4} = Cash_Feed_Back_Duration;

    names{1,1} = 'Life_Choice';
    names{1,2} = 'Life_Feedback';
    names{1,3} = 'Cash_Choice';
    names{1,4} = 'Cash_Feedback';
    
    save([Participant_ID '_' Current_File_name(13:20) '_Gambling.mat'],'onsets','durations','names');
    fclose(fid);
    clearvars -except k listOfFileNames numberOfFiles
end