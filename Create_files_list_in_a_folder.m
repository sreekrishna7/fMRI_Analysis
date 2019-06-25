clear;

Out_filename = 'Emotional_Reactivity_behavioural_file_List.xlsx'; %Output  Filename
sheet_name = 'File_List';
xlRange = 'A1';
x = dir ('E:\OPS\OPS_All_EPrime_files\Emotional_Reactivity\*.txt');

filenames = char(x.name);
filenames = filenames(1:end,:);
Participant_IDs = ['Participant_ID';cellstr(filenames(:,1:11))];
Dates = ['Date'; cellstr(filenames(:,13:20))];
To_write = [Participant_IDs Dates];
xlswrite(Out_filename,To_write,sheet_name,xlRange);

