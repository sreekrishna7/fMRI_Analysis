close all;
clear all;
clc;
addpath C:\Users\ramakrs\Documents\spm12 ;
Respdata = spm_select('List',pwd,'^RESPData');
a = load(Respdata);

len1 = length(a);
new_a = zeros(1,2*len1-1);
new_a(1:2:end) = a;
for i = 2:2:length(new_a)
    new_a(i) = (new_a(i-1)+new_a(i+1))/2;
end
new_a(2*len1) = new_a(end)+(new_a(len1-1) -new_a(len1-2));
new_a = new_a';
a =new_a;
len1 = length(a);
new_a = zeros(1,2*len1-1);
new_a(1:2:end) = a;
for i = 2:2:length(new_a)
    new_a(i) = (new_a(i-1)+new_a(i+1))/2;
end
new_a(2*len1) = new_a(end)+(new_a(len1-1) -new_a(len1-2));
new_a = new_a';

[m n] = size(new_a);
save(Respdata,'new_a','-ascii');
PPGdata = spm_select('List',pwd,'^PPGData');
b = load(PPGdata);
