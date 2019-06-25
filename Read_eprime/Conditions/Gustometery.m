close;clear;clc;
x         = readtable('9227-20170106-M6T2.csv');
xx        =  table2struct(x,'ToScalar',true);
Type      = xx.ScannerStart; 
idx_Shake = find(strcmp(Type,'Shake'));
idx_Water = find(strcmp(Type,'Water'));

Shake_Onset =xx.x0(idx_Shake);
Water_Onset =xx.x0(idx_Water);

Shakeswallow_Onset =xx.x0(idx_Shake+1);
Waterswallow_Onset =xx.x0(idx_Water+1);

Shake_Duration =Shakeswallow_Onset -Shake_Onset;
Water_Duration =Waterswallow_Onset -Water_Onset;

onsets    = cell(1,2);
names     = cell(1,2);
durations = cell(1,2);

onsets{1,1} = Shake_Onset;
onsets{1,2} = Water_Onset;
    
durations{1,1} = Shake_Duration;
durations{1,2} = Water_Duration;

names{1,1} = 'Shake';
names{1,2} = 'Water';

save('A00-06-9227_20170106_M62.mat','onsets','durations','names');