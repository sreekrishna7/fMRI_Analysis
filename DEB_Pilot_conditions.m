close all;
clear;
clc
format longg;
format compact;
%Run the windows_cmd_for_file_paths.txt
listOfFileNames = textread('E:\ENS\Behavioural_Data\ENS_All_Conditions\file_paths.txt','%s'); 
load E:\DEB_Pilot\Behavioural_Data\DEB_Pilot_Food_wanting_Paradigm_Sorted.mat


LF_HS_idx      = find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'LF/HS'));
LF_LCHO_HP_idx = find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'LF/LCHO/HP'));
LF_HCCHO_idx   = find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'LF/HCCHO'));
HF_HS_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'HF/HS'));
HF_LCHO_HP_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'HF/LCHO/HP'));
HF_HCCHO_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'HF/HCCHO'));
ED_Low_idx=find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.EnergyDensity_0_low_1_high,'0'));
ED_High_idx=find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.EnergyDensity_0_low_1_high,'1'));
Non_Food_idx  = find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.MaPSCategory,'N/A'));
Sweet_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.TasteCategory,'Sweet'));
Savory_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.TasteCategory,'Savory'));
Dessert_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.FoodCategory,'Dessert'));
Side_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.FoodCategory,'Side'));
Entree_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.FoodCategory,'Entrée'));
Breakfast_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.FoodCategory,'Breakfast'));
Snack_idx= find(strcmp(DEB_Pilot_Food_wanting_Paradigm_Sorted.FoodCategory,'Snack'));

numberOfFiles = length(listOfFileNames);
for k =  1 : numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    DATA_DEB_Pilot_data = load(thisFile); 
    tt=1;
    for i =1:5:525
        DEB_Pilot_allBigPic_onsets(tt) = DATA_DEB_Pilot_data.onsets{i};
%         DEB_Pilot_allBigPic_durations(tt) = DATA_DEB_Pilot_data.durations{i};
%         DEB_Pilot_allBigPic_names(tt) = DATA_DEB_Pilot_data.names{i};
        tt =tt+1;
    end
    LF_HS_onsets      = DEB_Pilot_allBigPic_onsets(LF_HS_idx)';
    LF_LCHO_HP_onsets = DEB_Pilot_allBigPic_onsets(LF_LCHO_HP_idx)'; 
    LF_HCCHO_onsets   = DEB_Pilot_allBigPic_onsets(LF_HCCHO_idx)';
    HF_HS_onsets      = DEB_Pilot_allBigPic_onsets(HF_HS_idx)';
    HF_LCHO_HP_onsets = DEB_Pilot_allBigPic_onsets(HF_LCHO_HP_idx)';
    HF_HCCHO_onsets   = DEB_Pilot_allBigPic_onsets(HF_HCCHO_idx)';
    ED_Low_onsets            = DEB_Pilot_allBigPic_onsets(ED_Low_idx)';
    ED_High_onsets           = DEB_Pilot_allBigPic_onsets(ED_High_idx)'; 
    Non_Food_onsets   = DEB_Pilot_allBigPic_onsets(Non_Food_idx)';
    Sweet_onsets      = DEB_Pilot_allBigPic_onsets(Sweet_idx)';
    Savory_onsets     = DEB_Pilot_allBigPic_onsets(Savory_idx)';
    Dessert_onsets    = DEB_Pilot_allBigPic_onsets(Dessert_idx)';
    Side_onsets       = DEB_Pilot_allBigPic_onsets(Side_idx)';
    Entree_onsets     = DEB_Pilot_allBigPic_onsets(Entree_idx)';
    Breakfast_onsets  = DEB_Pilot_allBigPic_onsets(Breakfast_idx)';
    Snack_onsets      = DEB_Pilot_allBigPic_onsets(Snack_idx)';
    
    LF_HS_durations      = 5 * ones(size(LF_HS_onsets));
    LF_LCHO_HP_durations = 5 * ones(size(LF_LCHO_HP_onsets));
    LF_HCCHO_durations   = 5 * ones(size(LF_HCCHO_onsets));
    HF_HS_durations      = 5 * ones(size(HF_HS_onsets));
    HF_LCHO_HP_durations = 5 * ones(size(HF_LCHO_HP_onsets));
    HF_HCCHO_durations   = 5 * ones(size(HF_HCCHO_onsets));
    ED_Low_durations     = 5 * ones(size(ED_Low_onsets));
    ED_High_durations    = 5 * ones(size(ED_High_onsets));
    Non_Food_durations   = 5 * ones(size(Non_Food_onsets));
    Sweet_durations      = 5 * ones(size(Sweet_onsets));
    Savory_durations     = 5 * ones(size(Savory_onsets));
    Dessert_durations    = 5 * ones(size(Dessert_onsets));
    Side_durations       = 5 * ones(size(Side_onsets));
    Entree_durations     = 5 * ones(size(Entree_onsets));
    Breakfast_durations  = 5 * ones(size(Breakfast_onsets));
    Snack_durations      = 5 * ones(size(Snack_onsets));
    
    onsets = cell(1,16);
    names = cell(1,16);
    durations = cell(1,16);

    onsets{1,1} = LF_HS_onsets;
    onsets{1,2} = LF_LCHO_HP_onsets;
    onsets{1,3} = LF_HCCHO_onsets;
    onsets{1,4} = HF_HS_onsets;
    onsets{1,5} = HF_LCHO_HP_onsets;
    onsets{1,6} = HF_HCCHO_onsets;
    onsets{1,7} = ED_Low_onsets;
    onsets{1,8} = ED_High_onsets;
    onsets{1,9} = Non_Food_onsets;
    onsets{1,10} = Sweet_onsets;
    onsets{1,11} = Savory_onsets;
    onsets{1,12} = Dessert_onsets;
    onsets{1,13} = Side_onsets;
    onsets{1,14} = Entree_onsets;
    onsets{1,15} = Breakfast_onsets;
    onsets{1,16} = Snack_onsets;
    
    durations{1,1} = LF_HS_durations;
    durations{1,2} = LF_LCHO_HP_durations;
    durations{1,3} = LF_HCCHO_durations;
    durations{1,4} = HF_HS_durations;
    durations{1,5} = HF_LCHO_HP_durations;
    durations{1,6} = HF_HCCHO_durations;
    durations{1,7} = ED_Low_durations;
    durations{1,8} = ED_High_durations;
    durations{1,9} = Non_Food_durations;
    durations{1,10} = Sweet_durations;
    durations{1,11} = Savory_durations;
    durations{1,12} = Dessert_durations;
    durations{1,13} = Side_durations;
    durations{1,14} = Entree_durations;
    durations{1,15} = Breakfast_durations;
    durations{1,16} = Snack_durations;
    
    names{1,1} = 'LF_HS';
    names{1,2} = 'LF_LCHO_HP';
    names{1,3} = 'LF_HCCHO';
    names{1,4} = 'HF_HS';
    names{1,5} = 'HF_LCHO_HP';
    names{1,6} = 'HF_HCCHO';
    names{1,7} = 'ED_Low';
    names{1,8} = 'ED_High';
    names{1,9} = 'Non_Food';
    names{1,10} = 'Sweet';
    names{1,11} = 'Savory';
    names{1,12} = 'Dessert';
    names{1,13} = 'Side';
    names{1,14} = 'Entree';
    names{1,15} = 'Breakfast';
    names{1,16} = 'Snack';
    
    month_alp = Current_File_name(16:18);
    switch month_alp
        case 'Jan'
            month = '01';
        case 'Feb'
            month = '02';
        case 'Mar'
            month = '03';
        case 'Apr'
            month = '04';
        case 'May'
            month = '05';
        case 'Jun'
            month = '06';
        case 'Jul'
            month = '07';
        case 'Aug'
            month = '08';
        case 'Sep'
            month = '09';
        case 'Oct'
            month = '10';
        case 'Nov'
            month = '11';
        case 'Dec'
            month = '12';
    end
    Participant_ID = Current_File_name(1:11);
    year           = Current_File_name(20:23);
    day            = Current_File_name(13:14);
    Session        = Current_File_name(end-2:end);
%     save([Participant_ID '_' year month day '_' Session],'onsets','durations','names');
    save([Participant_ID '_' year month day],'onsets','durations','names');

    clearvars variables -except k listOfFileNames numberOfFiles LF_HS_idx LF_LCHO_HP_idx LF_HCCHO_idx HF_HS_idx HF_LCHO_HP_idx HF_HCCHO_idx ...
        Non_Food_idx Sweet_idx Savory_idx Dessert_idx Side_idx Entree_idx Breakfast_idx Snack_idx;

end