%% Use the following command in windows cmd
% dir /s /b *. > file_paths.txt
close all;
clear all;
clc
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFolderNames = textread('E:\OPS\SK_For_Preprocessing\file_paths.txt','%s'); 

numberOfFolders = length(listOfFolderNames);
for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
    cd (thisFolder);
    DD = dir([thisFolder, '\*.nii']);% Checking if the folder has any .nii files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
   
    if (Num_of_files ~=0) 
        clear str_file str_file_info ...
            fn_file1 fn_file1_info ...
            fn_file2 fn_file2_info ...
            fn_file3 fn_file3_info ...
            fn_file4 fn_file4_info ... 
            fn_file5 fn_file5_info ...
            fn_file6 fn_file6_info ...
            fn_file7 fn_file7_info ... 
            fn_file8 fn_file8_info; 
        str_file = spm_select('List',pwd,['SAG_MPRAGE.nii$']);
        str_file_info = spm_select('List',pwd,['SAG_MPRAGE_info.txt$']);
        
        
        if (strcmp(str_file,''))
            str_file  = spm_select('List',pwd,['FSPGR_BRAVO.nii$']);
            str_file_info = spm_select('List',pwd,['FSPGR_BRAVO_info.txt$']);
        end
        if (strcmp(str_file,''))
            str_file  = spm_select('List',pwd,['SAG_STRUCTURAL.nii$']);
            str_file_info = spm_select('List',pwd,['SAG_STRUCTURAL_info.txt$']);
        end
        
        fn_file1 = spm_select('List',pwd,['Run_1.nii$']);
        fn_file1_info = spm_select('List',pwd,['Run_1_info.txt$']);
        fn_file2 = spm_select('List',pwd,['Run_2.nii$']);
        fn_file2_info = spm_select('List',pwd,['Run_2_info.txt$']);
       
        if (~strcmp(fn_file1,''))
             mkdir('Gambling/Run_1');
            copyfile(fn_file1,'Gambling/Run_1');
        end
        if (~strcmp(fn_file1_info,''))
            copyfile(fn_file1_info,'Gambling/Run_1');
        end
        if (~strcmp(fn_file2,''))
            mkdir('Gambling/Run_2');
            copyfile(fn_file2,'Gambling/Run_2');
        end
        if (~strcmp(fn_file2_info,''))
            copyfile(fn_file2_info,'Gambling/Run_2');
        end
        
               
        fn_file3 = spm_select('List',pwd,['MSIT.nii$']);
        fn_file3_info = spm_select('List',pwd,['MSIT_info.txt$']);
        
        if (~strcmp(fn_file3,''))
            mkdir('MSIT');
            copyfile(fn_file3,'MSIT');
        end
        if (~strcmp(fn_file3_info,''))
            copyfile(fn_file3_info,'MSIT');
        end
        if (~strcmp(str_file,''))
            copyfile(str_file,'Gambling/Run_1');
            copyfile(str_file,'Gambling/Run_2');
            copyfile(str_file,'MSIT');
        end
        
        if (~strcmp(str_file_info,''))
            copyfile(str_file_info,'Gambling/Run_1');
            copyfile(str_file_info,'Gambling/Run_2');
            copyfile(str_file_info,'MSIT');
        end
        
        %%
         
        fn_file4 = spm_select('List',pwd,['ANT.nii$']);
        fn_file4_info = spm_select('List',pwd,['ANT_info.txt$']);
        if (~strcmp(fn_file4,''))
            mkdir('ANT');
            copyfile(fn_file4,'ANT');
        end
        if (~strcmp(fn_file4_info,''))
            copyfile(fn_file4_info,'ANT');
        end
        
        fn_file5 = spm_select('List',pwd,['AXCPT.nii$']);
        fn_file5_info = spm_select('List',pwd,['AXCPT_info.txt$']);
        if (~strcmp(fn_file5,''))
            mkdir('AXCPT');
            copyfile(fn_file5,'AXCPT');
        end
        if (~strcmp(fn_file5_info,''))
            copyfile(fn_file5_info,'AXCPT');
        end
     %%
        fn_file6 = spm_select('List',pwd,['Task_1.nii$']);
        fn_file6_info = spm_select('List',pwd,['Task_1_info.txt$']);
        fn_file7 = spm_select('List',pwd,['Task_2.nii$']);
        fn_file7_info = spm_select('List',pwd,['Task_2_info.txt$']);
        if (~strcmp(fn_file6,''))
            mkdir('Retaliation/Task_1');
            copyfile(fn_file6,'Retaliation/Task_1');
        end
        if (~strcmp(fn_file6_info,''))
            copyfile(fn_file6_info,'Retaliation/Task_1');
        end
        if (~strcmp(fn_file7,''))
            mkdir('Retaliation/Task_2');
            copyfile(fn_file7,'Retaliation/Task_2');
        end
        if (~strcmp(fn_file7_info,''))
            copyfile(fn_file7_info,'Retaliation/Task_2');
        end
        
               
        fn_file8 = spm_select('List',pwd,['Emotional_Reactivity.nii$']);
        fn_file8_info = spm_select('List',pwd,['Emotional_Reactivity_info.txt$']);
        
        if (~strcmp(fn_file8,''))
            mkdir('Emotional_Reactivity');
            copyfile(fn_file8,'Emotional_Reactivity');
        end
        if (~strcmp(fn_file8_info,''))
            copyfile(fn_file8_info,'Emotional_Reactivity');
        end
        %% Careful
        x = dir(pwd);
        delete(x(3:end-2).name);

    end
end