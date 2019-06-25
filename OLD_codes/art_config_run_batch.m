close all;
clear all;
clc
format longg;
format compact;
addpath C:\Users\ramakrs\Documents\spm12\toolbox\art-2015-10\
listOfFileNames = textread('E:\OPS\SK_Preprocessed\AXCPT\AXCPT_art_config\file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
for k =  1: numberOfFiles
    thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_AXCPT_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
    art('sess_file',thisFile);
    close;
end

