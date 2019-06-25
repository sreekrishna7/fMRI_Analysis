clear all;
addpath C:\Users\ramakrs\Documents\spm12;
addpath C:\Users\ramakrs\Documents\spm8\toolbox\marsbar-0.44;

ROI_PATH = 'C:\Users\ramakrs\Documents\Food_Photo_PBRC\FOOD_ROIs\';
des_path = spm_get(1, 'SPM.mat', 'Select SPM.mat');
des = mardo(des_path);  % make mardo design object
load('SPM.mat');

filename = 'stats_multiple_regression_AllCovariates.xlsx';
xlRange = 'A1';

Attention_roi_files          = spm_get('files', [ROI_PATH 'Attention'], '*roi.mat');
Cognitive_Control_roi_files  = spm_get('files', [ROI_PATH 'Cognitive_Control'], '*roi.mat');
Decision_Making_roi_files    = spm_get('files', [ROI_PATH 'Decision_Making'], '*roi.mat');
Energy_Homeostasis_roi_files = spm_get('files', [ROI_PATH 'Energy_Homeostasis'], '*roi.mat');
Memory_roi_files             = spm_get('files', [ROI_PATH 'Memory'], '*roi.mat');
Motor_Control_roi_files      = spm_get('files', [ROI_PATH 'Motor_Control'], '*roi.mat');
Reward_Motivation_roi_files  = spm_get('files', [ROI_PATH 'Reward_Motivation'], '*roi.mat');
Taste_Sensory_roi_files      = spm_get('files', [ROI_PATH 'Taste_Sensory'], '*roi.mat');
Visual_Perception_roi_files  = spm_get('files', [ROI_PATH 'Visual_Perception'], '*roi.mat');

Attention_rois               = maroi('load_cell', Attention_roi_files); % make maroi ROI objects
Cognitive_Control_rois       = maroi('load_cell', Cognitive_Control_roi_files); % make maroi ROI objects
Decision_Making_rois         = maroi('load_cell', Decision_Making_roi_files); % make maroi ROI objects
Energy_Homeostasis_rois      = maroi('load_cell', Energy_Homeostasis_roi_files); % make maroi ROI objects
Memory_rois                  = maroi('load_cell', Memory_roi_files); % make maroi ROI objects
Motor_Control_rois           = maroi('load_cell', Motor_Control_roi_files); % make maroi ROI objects
Reward_Motivation_rois       = maroi('load_cell', Reward_Motivation_roi_files); % make maroi ROI objects
Taste_Sensory_rois           = maroi('load_cell', Taste_Sensory_roi_files); % make maroi ROI objects
Visual_Perception_rois       = maroi('load_cell', Visual_Perception_roi_files); % make maroi ROI objects

Attention_mY                 = get_marsy(Attention_rois{:}, des, 'mean'); % extract data into marsy data object
Cognitive_Control_mY         = get_marsy(Cognitive_Control_rois{:}, des, 'mean'); % extract data into marsy data object
Decision_Making_mY           = get_marsy(Decision_Making_rois{:}, des, 'mean'); % extract data into marsy data object
Energy_Homeostasis_mY        = get_marsy(Energy_Homeostasis_rois{:}, des, 'mean'); % extract data into marsy data object
Memory_mY                    = get_marsy(Memory_rois{:}, des, 'mean'); % extract data into marsy data object
Motor_Control_mY             = get_marsy(Motor_Control_rois{:}, des, 'mean'); % extract data into marsy data object
Reward_Motivation_mY         = get_marsy(Reward_Motivation_rois{:}, des, 'mean'); % extract data into marsy data object
Taste_Sensory_mY             = get_marsy(Taste_Sensory_rois{:}, des, 'mean'); % extract data into marsy data object
Visual_Perception_mY         = get_marsy(Visual_Perception_rois{:}, des, 'mean'); % extract data into marsy data object

Attention_Stats              = summary_data(Attention_mY );  % get summary time course(s)
Cognitivecontrol_Stats       = summary_data(Cognitive_Control_mY );  % get summary time course(s)
Decisionmaking_Stats         = summary_data(Decision_Making_mY);  % get summary time course(s)
Energyhomeostasis_Stats      = summary_data(Energy_Homeostasis_mY);  % get summary time course(s)
Memory_Stats                 = summary_data(Memory_mY);  % get summary time course(s)
Motorcontrol_Stats           = summary_data(Motor_Control_mY);  % get summary time course(s)
Rewardmotivation_Stats       = summary_data(Reward_Motivation_mY);  % get summary time course(s)
Tastesensory_Stats           = summary_data(Taste_Sensory_mY);  % get summary time course(s)
Visualperception_Stats       = summary_data(Visual_Perception_mY);  % get summary time course(s)

Attention_st                 = y_struct(Attention_mY );  % get summary time course(s)
Cognitivecontrol_st          = y_struct(Cognitive_Control_mY );  % get summary time course(s)
Decisionmaking_st            = y_struct(Decision_Making_mY);  % get summary time course(s)
Energyhomeostasis_st         = y_struct(Energy_Homeostasis_mY);  % get summary time course(s)
Memory_st                    = y_struct(Memory_mY);  % get summary time course(s)
Motorcontrol_st              = y_struct(Motor_Control_mY);  % get summary time course(s)
Rewardmotivation_st          = y_struct(Reward_Motivation_mY);  % get summary time course(s)
Tastesensory_st              = y_struct(Taste_Sensory_mY);  % get summary time course(s)
Visualperception_st          = y_struct(Visual_Perception_mY);  % get summary time course(s)

%% Obtaining filename (Participant ID) from file paths
Image_FilePaths = char(SPM.xY.P);
[rr, cc] = size(Image_FilePaths);
Image_File_name  =  cell(rr,1);
upperPath = cell(rr,1);
for i = 1:rr
    [upperPath{i}, Image_File_name{i}, ~] = fileparts(Image_FilePaths(i,:));
end
Image_File_name_char = char(Image_File_name);

Participant_IDs = ['Participant_ID'; cellstr(Image_File_name_char(:,1:11))];

[r, c]  = size(Attention_Stats);
for i = 1:c
    Attention_Stats_xlsx{1,i} =  Attention_st.regions{1,i}.name;
end

for i = 2:r+1
    for j = 1:c
        Attention_Stats_xlsx{i,j} =  Attention_Stats(i-1,j);
    end
end
Attention_Stats_xlsx  = [Participant_IDs Attention_Stats_xlsx];

[r, c]  = size(Cognitivecontrol_Stats);
for i = 1:c
    Cognitivecontrol_Stats_xlsx{1,i} =  Cognitivecontrol_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Cognitivecontrol_Stats_xlsx{i,j} =  Cognitivecontrol_Stats(i-1,j);
    end
end
Cognitivecontrol_Stats_xlsx  = [Participant_IDs Cognitivecontrol_Stats_xlsx];

[r, c]  = size(Decisionmaking_Stats);
for i = 1:c
    Decisionmaking_Stats_xlsx{1,i} =  Decisionmaking_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Decisionmaking_Stats_xlsx{i,j} =  Decisionmaking_Stats(i-1,j);
    end
end
Decisionmaking_Stats_xlsx = [Participant_IDs Decisionmaking_Stats_xlsx];


[r, c]  = size(Energyhomeostasis_Stats);
for i = 1:c
    Energyhomeostasis_Stats_xlsx{1,i} =  Energyhomeostasis_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Energyhomeostasis_Stats_xlsx{i,j} =  Energyhomeostasis_Stats(i-1,j);
    end
end
Energyhomeostasis_Stats_xlsx = [Participant_IDs Energyhomeostasis_Stats_xlsx];

[r, c]  = size(Memory_Stats);
for i = 1:c
    Memory_Stats_xlsx{1,i} =  Memory_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Memory_Stats_xlsx{i,j} =  Memory_Stats(i-1,j);
    end
end
Memory_Stats_xlsx = [Participant_IDs Memory_Stats_xlsx];

[r, c]  = size(Motorcontrol_Stats);
for i = 1:c
    Motorcontrol_Stats_xlsx{1,i} =  Motorcontrol_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Motorcontrol_Stats_xlsx{i,j} =  Motorcontrol_Stats(i-1,j);
    end
end
Motorcontrol_Stats_xlsx = [Participant_IDs Motorcontrol_Stats_xlsx];

[r, c]  = size(Rewardmotivation_Stats);
for i = 1:c
    Rewardmotivation_Stats_xlsx{1,i} =  Rewardmotivation_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Rewardmotivation_Stats_xlsx{i,j} =  Rewardmotivation_Stats(i-1,j);
    end
end
Rewardmotivation_Stats_xlsx = [Participant_IDs Rewardmotivation_Stats_xlsx];

[r, c]  = size(Tastesensory_Stats);
for i = 1:c
    Tastesensory_Stats_xlsx{1,i} =  Tastesensory_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Tastesensory_Stats_xlsx{i,j} =  Tastesensory_Stats(i-1,j);
    end
end
Tastesensory_Stats_xlsx = [Participant_IDs Tastesensory_Stats_xlsx];


[r, c]  = size(Visualperception_Stats);
for i = 1:c
    Visualperception_Stats_xlsx{1,i} =  Visualperception_st.regions{1,i}.name;
end
for i = 2:r+1
    for j = 1:c
        Visualperception_Stats_xlsx{i,j} =  Visualperception_Stats(i-1,j);
    end
end
Visualperception_Stats_xlsx = [Participant_IDs Visualperception_Stats_xlsx];

xlswrite(filename,Attention_Stats_xlsx,        'Attention',xlRange);
xlswrite(filename,Cognitivecontrol_Stats_xlsx, 'Cognitive_Control',xlRange);
xlswrite(filename,Decisionmaking_Stats_xlsx,   'Decision_Making',xlRange);
xlswrite(filename,Energyhomeostasis_Stats_xlsx,'Energy_Homeostasis',xlRange);
xlswrite(filename,Memory_Stats_xlsx,           'Memory',xlRange);
xlswrite(filename,Motorcontrol_Stats_xlsx,     'Motor_Control',xlRange);
xlswrite(filename,Rewardmotivation_Stats_xlsx, 'Reward_Motivation',xlRange);
xlswrite(filename,Tastesensory_Stats_xlsx,     'Taste_Sensory',xlRange);
xlswrite(filename,Visualperception_Stats_xlsx, 'Visual_Perception',xlRange);

% xlswrite(filename,SPM.xY.P, 'FilePaths',xlRange);% Adds additional sheet
% with file paths

