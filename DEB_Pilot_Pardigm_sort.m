clc;

load food_names_inorder.mat;
load Food_wanting_paradigm.mat;
filename = 'DEB_Pilot_Food_wanting_Paradigm_Sorted.xlsx'; %Output  Filename
xlRange = 'A1';
EnergyDensity_kcal_per_g = cell(105,1);
EnergyDensity_0_low_1_high = cell(105,1);
MaPSCategory = cell(105,1);
TasteCategory = cell(105,1);
FoodCategory = cell(105,1);
%% food_names_inorder should contain names in correct order
%% Food_wanting_paradigm is to be sorted
for i  = 1:105
    for j = 1:105
        if (strcmp(food_names_inorder{i},Food_wanting_paradigm.PhotoName{j})) 
            EnergyDensity_kcal_per_g{i}    = Food_wanting_paradigm.ED_kcal_g_{j};
            EnergyDensity_0_low_1_high{i}  = Food_wanting_paradigm.EnergyDensity_0_low_1_high_{j};
            MaPSCategory{i}                = Food_wanting_paradigm.MaPSCategory{j};
            TasteCategory{i}               = Food_wanting_paradigm.TasteCategory_sweet_Savory_{j};
            FoodCategory{i}                = Food_wanting_paradigm.FoodCategory_breakfast_Entr_e_Side_Snack_Dessert_{j};
        end
    end
end
Headings = [{'Food_names_inorder'} {'EnergyDensity_kcal_per_g'} {'EnergyDensity_0_low_1_high'} {'MaPSCategory'} {'TasteCategory'} {'FoodCategory'}];
    
DEB_Pilot_Food_wanting_Paradigm_Sorted = [Headings;[food_names_inorder EnergyDensity_kcal_per_g EnergyDensity_0_low_1_high MaPSCategory TasteCategory FoodCategory]];
xlswrite(filename,DEB_Pilot_Food_wanting_Paradigm_Sorted ,'Food_wanting_Paradigm',xlRange);